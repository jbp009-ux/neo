# NEO-GATES v1.14.0
## State Machine, Transitions, Approval Tokens & Card-Deck Execution System

**Purpose:** Defines the NEO pipeline state machine, gate tokens, STOP rules, permission hierarchy, enforcement doctrine, SaaS safety gates, and CDEX card compliance protocol
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
| FOOTPRINT | Ant | Propose changes, data op classification, **feature impact analysis**, risk assessment, rollback plan |
| BACKUP | Ant | Create backup, document proof, verify restore (conditional — see NEO-SURGICAL.md) |
| PATCH | Ant | Apply approved changes, show diffs |
| VERIFY | Ant | Run tests, validate, capture evidence, **feature inventory** (before/after counts) |
| REPORT | Ant | Write structured report with all evidence |
| REVIEW | Ghost | Validate evidence, check DoD, quality gate |
| INSPECT | Inspector | Audit for standards compliance, drift detection |
| PLAN | Planner (👔 Board Ant) | [CONDITIONAL] Decompose big work into Ant-sized tasks, produce RUN_PLAN + task packets |
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
| `🔑 PLAN SKELETON OK` | Operator | Planner proceeds to DETAIL pass |
| `🔑 TASK BATCH <N> OK` | Operator | Planner proceeds to next batch or RUN_PLAN |
| `🔑 RUN PLAN APPROVED` | Operator | Planner hands off to BECCA for Ant dispatch |
| `🔑 DEVTOOLS_CHIEF COMPLETE` | BECCA (after Sentinel finishes) | Specialists or DEVTOOLS verdict |
| `🔑 DEVTOOLS_SPECIALISTS COMPLETE` | BECCA (after specialists finish) | DEVTOOLS verdict |
| `🔑 DEVTOOLS VERIFICATION APPROVED` | BECCA/Operator | GOVERNANCE (CLOSE continues) |

### 3.3 Token Rules

| Rule | Description |
|------|-------------|
| Prefix required | Must start with `🔑` emoji |
| Human-issued only | Only the operator can issue tokens |
| One per gate | Exactly one token per gate transition |
| No self-approval | An Ant cannot approve its own gate |
| No skipping | Cannot skip gates (e.g., DISCOVERY → PATCH is INVALID) |
| **Exact verbatim** | Tokens must match the vocabulary EXACTLY — paraphrases are INVALID |

### 3.4 Token Normalization Rule (FROZEN)

```
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║   TOKEN NORMALIZATION — EXACT VERBATIM OR STOP                              ║
║                                                                              ║
║   Gate tokens must be EXACT VERBATIM as defined in Section 3.2/13.          ║
║   Paraphrases, abbreviations, and "close enough" are INVALID.               ║
║                                                                              ║
║   ✅ VALID:                                                                  ║
║   • "🔑 FOOTPRINT APPROVED"                                                 ║
║   • "🔑 PATCH APPROVED"                                                     ║
║   • "🔑 GHOST REJECTED: missing evidence in Section 4"                      ║
║                                                                              ║
║   ❌ INVALID (paraphrases — Ant must STOP and request exact token):          ║
║   • "looks good, go ahead"                                                   ║
║   • "approved" (missing 🔑 prefix and gate name)                            ║
║   • "yeah that's fine, proceed"                                              ║
║   • "LGTM"                                                                   ║
║   • "ok" / "sure" / "yes"                                                    ║
║   • "🔑 APPROVED" (missing gate name — which gate?)                         ║
║   • "FOOTPRINT APPROVED" (missing 🔑 prefix)                                ║
║                                                                              ║
║   WHEN PARAPHRASE DETECTED:                                                  ║
║   1. STOP — do NOT interpret intent                                          ║
║   2. Quote the exact token needed:                                           ║
║      "To proceed, please issue: 🔑 FOOTPRINT APPROVED"                     ║
║   3. Wait for exact token — no exceptions                                    ║
║                                                                              ║
║   WHY: Colony OS proved that loose approvals ("sure, go ahead") caused       ║
║   Ants to proceed through gates the operator didn't intend to approve.       ║
║   Exact tokens force conscious, deliberate gate decisions.                   ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
```

### 3.5 Normalization Exceptions

| Scenario | Rule |
|----------|------|
| `🔑 CONTINUE` or `🔑 GO` | Both are valid to clear a STOP (defined in Section 13.2) |
| `🔑 FOOTPRINT APPROVED WITH CHANGES: <text>` | The `<text>` portion is freeform — only the prefix must be exact |
| `🔑 GHOST REJECTED: <reason>` | The `<reason>` portion is freeform — only the prefix must be exact |
| Operator re-issues with typo | If operator clearly attempted the token (e.g., "🔑 FOTOPRINT APPROVED"), request correction — do NOT auto-correct |

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
| S-29 | Feature file/export count decreased after PATCH | STOP — protected feature shrunk. Requires `🔑 FEATURE REMOVAL OVERRIDE` if intentional | HIGH |
| S-30 | Claiming code "doesn't exist" or is "unused" without evidence | STOP — prove non-existence with exhaustive grep + import tracing | HIGH |
| S-31 | Existing feature removed or disabled during task | STOP — scope contraction. Feature removal is a separate task, not a side effect | HIGH |
| S-32 | TODO run number ahead of STATE.md last run | STOP — previous run did not CLOSE. Operator must resolve state mismatch before new run | BLOCKER |
| S-33 | Scout survey without git freshness check | STOP — Scout must verify git is CLEAN before surveying. BECCA RECON step 0 | HIGH |
| S-34 | Manual drift >10 runs since last audit | STOP — MANUAL_DRIFT inspection is non-negotiable. BECCA will dispatch mandatory task | HIGH |
| S-35 | TARGET_ENVIRONMENT missing from FOOTPRINT | STOP — every FOOTPRINT must declare environment (EMULATOR/STAGING/PRODUCTION) | BLOCKER |
| S-36 | Destructive operation targeting PRODUCTION without 🔑 PRODUCTION CONFIRMED | STOP — production destructive ops require explicit operator confirmation beyond standard BACKUP APPROVED | ⚫ NUCLEAR |
| S-37 | Ant continued working after NUCLEAR detection | STOP — NUCLEAR = HALT, not pause. Any work after NUCLEAR without resolution = V-13 | ⚫ NUCLEAR |
| S-41 | Planner task has >5 target files after decomposition | STOP — re-decompose until ≤5 files per task. Big tasks cause "plain Claude" takeover | HIGH |
| S-42 | Planner skipped Hive Mind check before decomposing | STOP — read all 6 Hive Mind indexes before decomposition. Institutional memory prevents re-doing completed work | HIGH |
| S-43 | Circular dependency detected in Planner task graph | STOP — refactor dependency chain. Task A depends on B depends on A is invalid | BLOCKER |
| S-44 | Inbox document >500 lines, not summarized | STOP — apply summary-first protocol. Read first 50 lines, present summary, operator picks sections | MEDIUM |
| S-45 | >7 tasks planned for single session without session boundary | STOP — add session boundary. NEO is single-chat: 7 tasks × ~8 interactions = context limit | HIGH |

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

Gate behavior varies based on the task's **Ant Type risk level**. See `roles/NEO-ANT.md` for the full 16-type taxonomy.

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
║   1. HALT IMMEDIATELY — pipeline transitions to HALTED state                ║
║   2. Emit ⚫ NUCLEAR pheromone (see NEO-EVIDENCE.md)                        ║
║   3. Present NUCLEAR INCIDENT REPORT to operator (see below)                ║
║   4. Operator MUST resolve before ANY pipeline progress                      ║
║   5. There is NO token that bypasses NUCLEAR                                 ║
║   6. "Continue after NUCLEAR" without resolution = V-13 VIOLATION           ║
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
1. HALT — Pipeline transitions to HALTED state (not just STOP — full HALT)
2. DOCUMENT — Record exactly what was found (file, line, evidence)
3. EMIT — Log ⚫ NUCLEAR pheromone in report
4. PRESENT — Show NUCLEAR INCIDENT REPORT to operator (see 9.3)
5. WAIT — Only operator can resolve. NO further work of any kind.
6. NO WORKAROUND — There is no "read-only exception" for NUCLEAR
7. NO SELF-CLEARANCE — Ant cannot clear its own NUCLEAR. Only operator.
```

### 9.3 NUCLEAR INCIDENT REPORT (Mandatory)

When NUCLEAR is detected, the Ant MUST present this report BEFORE any other output:

```markdown
## ⚫ NUCLEAR INCIDENT REPORT
═══════════════════════════════════════════════════════════════

| Field | Value |
|-------|-------|
| Task | <TASK_ID> |
| Trigger | <which NUCLEAR category — see 9.1> |
| File | <file path:line number> |
| Evidence | <what was found — exact code or query> |
| Blast radius | <how many tenants / users / records affected> |
| Immediate risk | <what happens if this is exploited RIGHT NOW> |
| Recommended action | <what the operator should do> |

Pipeline state: HALTED
Awaiting operator resolution.
═══════════════════════════════════════════════════════════════
```

The operator resolves NUCLEAR by:
- `🔑 NUCLEAR RESOLVED: <action taken>` — Pipeline resumes from where it stopped
- `🔑 ROLLBACK` — Revert all changes
- `🔑 STOP` — Abort the entire task

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

## 12b) Feature Impact Analysis (FOOTPRINT + VERIFY)

### Why This Exists

FOOTPRINT showed files and data ops but NEVER showed which **user-facing features** were affected. The operator could approve "MODIFY: 8 files (CODE_ONLY)" without realizing that approval meant deleting the entire voice system.

### 12b.1 FOOTPRINT: Feature Impact Section (MANDATORY)

Every FOOTPRINT MUST include a **Feature Impact** table listing all user-facing features touched by the task:

```markdown
## FEATURE IMPACT

| Feature | Current State | After This Task | Impact | Override Needed? |
|---------|--------------|-----------------|--------|------------------|
| Voice (Web) | 10 files, active | REMOVING — all files deleted | 🔴 REMOVAL | YES — 🔑 FEATURE REMOVAL OVERRIDE |
| Voice (Native) | 4 files, active | UNCHANGED | ✅ NONE | NO |
| Chat (Web) | 3 files, active | MODIFIED — text-only mode | 🟡 REDUCED | NO (feature still exists) |
| Order Flow | 5 files, active | UNCHANGED | ✅ NONE | NO |
```

**Impact levels:**
| Level | Meaning | Override Required? |
|-------|---------|-------------------|
| ✅ NONE | Feature not touched | NO |
| 🟡 REDUCED | Feature loses some capability but still exists | NO — but must be documented |
| 🟠 RELOCATED | Feature moved to different files/paths | NO — but RELOCATION MAP required |
| 🔴 REMOVAL | Feature being deleted entirely | YES — `🔑 FEATURE REMOVAL OVERRIDE` |

### 12b.2 VERIFY: Feature Inventory (MANDATORY)

Every VERIFY step MUST include a **Feature Inventory** comparing before/after counts for all features in the task's scope:

```markdown
## FEATURE INVENTORY

| Feature | Files Before | Files After | Exports Before | Exports After | Delta | Status |
|---------|-------------|-------------|----------------|---------------|-------|--------|
| Voice (Web) | 10 | 10 | 15 | 15 | 0 | ✅ INTACT |
| Order Flow | 5 | 6 | 8 | 10 | +2 | ✅ EXPANDED |
| Auth | 3 | 3 | 5 | 5 | 0 | ✅ INTACT |
```

**If Delta is NEGATIVE and no `🔑 FEATURE REMOVAL OVERRIDE` was issued → S-29 STOP.**

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
| `🔑 FEATURE REMOVAL OVERRIDE: <feature>` | Operator | Allow removal of a protected code feature (see NEO-SURGICAL.md Section 6b) |
| `🔑 PRODUCTION CONFIRMED` | Operator | Allow destructive operation targeting production environment |
| `🔑 NUCLEAR RESOLVED: <action>` | Operator | Clear NUCLEAR HALT — pipeline resumes |
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
║   V-11  FEATURE REMOVAL WITHOUT OVERRIDE                                     ║
║         Deleting or disabling a protected feature (3+ related files)         ║
║         without 🔑 FEATURE REMOVAL OVERRIDE = AUTOMATIC REJECTION           ║
║                                                                              ║
║   V-12  TOKEN PARAPHRASE ACCEPTED                                            ║
║         Ant proceeded past a gate based on a paraphrased approval            ║
║         (e.g., "looks good" instead of exact 🔑 token) = AUTOMATIC REJECTION║
║                                                                              ║
║   V-13  NUCLEAR VIOLATION                                                    ║
║         Ant continued working after ⚫ NUCLEAR detection without             ║
║         operator resolution (🔑 NUCLEAR RESOLVED). NUCLEAR = HALT.          ║
║         Any work after NUCLEAR = AUTOMATIC REJECTION + COMPLIANCE FAIL      ║
║                                                                              ║
║   RESPONSE: Ghost flags. Inspector audits. Operator arbitrates.              ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
```

---

## 7) Quick Reference

```
┌─────────────────────────────────────────────────────────────────────────────┐
│  NEO-GATES v1.9.0 — QUICK REFERENCE                                        │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  PIPELINE:                                                                  │
│  [LAB] → DISCOVERY → FOOTPRINT → [BACKUP] → PATCH → VERIFY → REPORT →    │
│  GHOST → [INSPECTOR] → COMPLETE                                            │
│                                                                             │
│  BECCA PIPELINE (with optional PLAN):                                       │
│  RECON → SCOUT → [PLAN] → HANDOFF → [Ant→Ghost→Inspector] → CLOSE        │
│                                                                             │
│  LAB state is OPTIONAL — only for 🎨 Color Expert Ant. No gate.            │
│  PLAN state is CONDITIONAL — tasks>3, files>3, or inbox non-empty.         │
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
│  🔑 PRODUCTION CONFIRMED                                                   │
│  🔑 NUCLEAR RESOLVED: <action>                                             │
│  🔑 PLAN SKELETON OK              → Planner proceeds to DETAIL             │
│  🔑 TASK BATCH <N> OK             → Planner proceeds to next batch         │
│  🔑 RUN PLAN APPROVED             → Planner hands off for Ant dispatch     │
│  🔑 CONTINUE / GO / ROLLBACK / STOP                                        │
│                                                                             │
│  ⚫ NUCLEAR (ABOVE CRITICAL — HARD HALT):                                   │
│  Tenant isolation breach, cross-tenant data, credential exposure            │
│  HALT (not just STOP). NUCLEAR INCIDENT REPORT required.                   │
│  Only 🔑 NUCLEAR RESOLVED clears. V-13: continue after = auto-reject     │
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
│  V-10 Project lock     V-11 Feature removal    V-12 Token paraphrase       │
│  V-13 NUCLEAR violation (continued after NUCLEAR without resolution)       │
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
│  S-29→S-31: feature count decreased, non-existence claim, scope contraction│
│  S-32→S-34: TODO state mismatch, git freshness, manual drift overdue     │
│  S-35→S-37: missing env, prod destructive without confirm, post-NUCLEAR  │
│  S-41→S-45: Planner task >5 files, hive skip, circular dep, inbox, 7+   │
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
│  FEATURE IMPACT (Section 12b — NEO-SURGICAL.md Section 6b):                │
│  FOOTPRINT: Feature Impact table (which features affected, impact level)   │
│  VERIFY: Feature Inventory table (file/export counts before vs after)      │
│  Negative delta without 🔑 FEATURE REMOVAL OVERRIDE = S-29 STOP          │
│  🔑 FEATURE REMOVAL OVERRIDE: <feature> — one feature, one task          │
│                                                                             │
│  TOKEN NORMALIZATION (Section 3.4 — FROZEN):                                │
│  Tokens must be EXACT VERBATIM. No paraphrases.                            │
│  "looks good" ≠ 🔑 FOOTPRINT APPROVED                                     │
│  If paraphrase detected: STOP, quote exact token needed, wait.             │
│  V-12: Accepting paraphrased approval = AUTOMATIC REJECTION                │
│                                                                             │
│  SAAS SAFETY (NEO-SURGICAL.md v1.4.0):                                     │
│  ENVIRONMENT GATE: FOOTPRINT must declare TARGET_ENVIRONMENT               │
│  PRODUCTION + destructive → 🔑 PRODUCTION CONFIRMED required             │
│  NUCLEAR = HARD HALT (not STOP) → 🔑 NUCLEAR RESOLVED to clear          │
│  SECRET/TENANT/PII: See NEO-SURGICAL.md Sections 11-15                    │
│                                                                             │
│  RULES:                                                                     │
│  • No self-approval                                                         │
│  • No skipping gates                                                        │
│  • No auto-approvals                                                        │
│  • Default is STOP and wait                                                 │
│  • Silence ≠ approval                                                       │
│  • Paraphrase ≠ approval (exact tokens only)                               │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Appendix A) Master Reference — All STOP Conditions, Violations & Tokens

One-stop lookup for every numbered rule in the NEO pipeline. Roles should reference this appendix rather than hunting across sections.

### A.1 STOP Conditions (S-01 → S-37)

| # | Trigger | Severity | Section |
|---|---------|----------|---------|
| S-01 | Missing required input | BLOCKER | 5.1 |
| S-02 | Tests fail after PATCH | HIGH | 5.1 |
| S-03 | Scope creep detected | HIGH | 5.1 |
| S-04 | Security concern found | HIGH | 5.1 |
| S-05 | Unrecoverable error → HALTED | BLOCKER | 5.1 |
| S-06 | Evidence validation fails | HIGH | 5.1 |
| S-07 | Cross-tenant query detected | ⚫ NUCLEAR | 5.1 |
| S-08 | Tenant isolation breach | ⚫ NUCLEAR | 5.1 |
| S-09 | Permission escalation attempted | HIGH | 5.1 |
| S-10 | Environment mismatch | HIGH | 5.1 |
| S-11 | Race condition risk identified | MEDIUM | 5.1 |
| S-12 | Hardcoded secrets found | ⚫ NUCLEAR | 5.1 |
| S-13 | Critical surface edit without override | HIGH | 5.1 |
| S-14 | Evidence budget exceeded | MEDIUM | 5.1 |
| S-15 | Build breaks after PATCH | HIGH | 5.1 |
| S-16 | Dependency vulnerability found | MEDIUM | 5.1 |
| S-17 | Data deletion operation proposed | HIGH | 5.1 |
| S-18 | *(reserved)* | — | — |
| S-19 | Data looks "incomplete" — investigate intent (LAW 1) | HIGH | 5.1 |
| S-20 | Urge to "recreate" or "rebuild" data (LAW 1) | HIGH | 5.1 |
| S-21 | Seed/demo function found in live path (LAW 3) | HIGH | 5.1 |
| S-22 | Batch update without PATCH semantics (LAW 3) | HIGH | 5.1 |
| S-23 | Backup not created before data operation (LAW 2) | BLOCKER | 5.1 |
| S-24 | PUT semantics used without justification (LAW 3) | MEDIUM | 5.1 |
| S-25 | File path outside PROJECT LOCK root | BLOCKER | 5.1 |
| S-26 | Checkpoint not created before DISCOVERY | BLOCKER | 5.1 |
| S-27 | Target file outside task SCOPE BOUNDARY | HIGH | 5.1 |
| S-28 | Working on wrong project's files | BLOCKER | 5.1 |
| S-29 | Feature file/export count decreased after PATCH | HIGH | 5.1 |
| S-30 | Claiming code "doesn't exist" without evidence | HIGH | 5.1 |
| S-31 | Existing feature removed/disabled during task | HIGH | 5.1 |
| S-32 | TODO run number ahead of STATE.md last run | BLOCKER | 5.1 |
| S-33 | Scout survey without git freshness check | HIGH | 5.1 |
| S-34 | Manual drift >10 runs since last audit | HIGH | 5.1 |
| S-35 | TARGET_ENVIRONMENT missing from FOOTPRINT | BLOCKER | 5.1 |
| S-36 | Destructive op targeting PRODUCTION without 🔑 PRODUCTION CONFIRMED | ⚫ NUCLEAR | 5.1 |
| S-37 | Ant continued after NUCLEAR detection | ⚫ NUCLEAR | 5.1 |
| S-41 | Planner task >5 target files after decomposition | HIGH | 5.1 |
| S-42 | Planner skipped Hive Mind check | HIGH | 5.1 |
| S-43 | Circular dependency in Planner task graph | BLOCKER | 5.1 |
| S-44 | Inbox document >500 lines, not summarized | MEDIUM | 5.1 |
| S-45 | >7 tasks in single session without boundary | HIGH | 5.1 |

### A.2 Violations (V-01 → V-13) — All Auto-Reject

| # | Violation | Section |
|---|-----------|---------|
| V-01 | Gate skipping (e.g., DISCOVERY → PATCH) | 14 |
| V-02 | Budget continue without expansion token | 14 |
| V-03 | Read-only exception claim past STOP | 14 |
| V-04 | Token fabrication (self-issued 🔑) | 14 |
| V-05 | Multi-gate message (>1 gate per message) | 14 |
| V-06 | Acknowledge and continue past STOP | 14 |
| V-07 | Wrong prefix (approval without 🔑) | 14 |
| V-08 | Critical surface edit without override | 14 |
| V-09 | Data operation without backup proof | 14 |
| V-10 | Project lock violation (file outside root) | 14 |
| V-11 | Feature removal without override | 14 |
| V-12 | Token paraphrase accepted | 14 |
| V-13 | NUCLEAR violation (continued after NUCLEAR without resolution) | 14 |

### A.3 All Tokens

**Pipeline Gates:**

| Token | Unlocks |
|-------|---------|
| `🔑 DISCOVERY APPROVED` | L1 permissions (read + verify) |
| `🔑 DISCOVERY EXPANSION APPROVED` | Extended DISCOVERY budget |
| `🔑 FOOTPRINT APPROVED` | PATCH state |
| `🔑 FOOTPRINT APPROVED WITH CHANGES: <changes>` | PATCH state (modified) |
| `🔑 BACKUP APPROVED` | PATCH state (data ops) |
| `🔑 PATCH APPROVED` | VERIFY state |
| `🔑 VERIFY APPROVED` | REPORT state |
| `🔑 REPORT APPROVED` | Ghost REVIEW |
| `🔑 GHOST APPROVED` | Inspector or COMPLETE |
| `🔑 INSPECTOR PASS` | COMPLETE |
| `🔑 TASK COMPLETE` | Pipeline ends |
| `🔑 RUN COMPLETE` | BECCA CLOSE ends (all tasks done) |
| `🔑 QA REPORT COMPLETE` | QA Ant finishes QA report |
| `🔑 PLAN SKELETON OK` | Planner proceeds to DETAIL pass |
| `🔑 TASK BATCH <N> OK` | Planner proceeds to next batch or RUN_PLAN |
| `🔑 RUN PLAN APPROVED` | Planner hands off to BECCA for Ant dispatch |
| `🔑 DEVTOOLS_CHIEF COMPLETE` | Sentinel Ant finishes inspection |
| `🔑 DEVTOOLS_SPECIALISTS COMPLETE` | Perf/Network Ants finish (or SKIPPED) |
| `🔑 DEVTOOLS VERIFICATION APPROVED` | BECCA CLOSE proceeds to GOVERNANCE |

**Overrides:**

| Token | Purpose |
|-------|---------|
| `🔑 CRITICAL SURFACE OVERRIDE: <file>` | Edit critical surface (single file, single task) |
| `🔑 WIPE OVERRIDE: <collection>` | Collection overwrite |
| `🔑 FEATURE REMOVAL OVERRIDE: <feature>` | Remove protected feature |
| `🔑 PRODUCTION CONFIRMED` | Destructive op targeting production |
| `🔑 NUCLEAR RESOLVED: <action>` | Clear NUCLEAR HALT |
| `🔑 BRANCH_PROTECTION_BYPASS APPROVED` | Push to protected branch |
| `🔑 CONTINUE` | Clear a STOP condition |
| `🔑 GO` | Clear a STOP condition (alias) |
| `🔑 ROLLBACK` | Revert to pre-patch state |
| `🔑 STOP` | Halt all pipeline activity |
| `🔑 CROSS-PROJECT READ` | Read file outside PROJECT LOCK (write = NEVER) |

**Rejections:**

| Token | Effect |
|-------|--------|
| `🔑 REJECTED: <reason>` | Step must be revised |
| `🔑 GHOST REJECTED: <reason>` | Back to Ant |
| `🔑 GHOST CHANGES REQUESTED: <list>` | Back to Ant for specific fixes |
| `🔑 GHOST APPROVED WITH NOTES: <notes>` | Proceed with observations |
| `🔑 INSPECTOR FAIL: <reason>` | Operator decides |

---

## Appendix B) Card-Deck Execution System (CDEX)

### CARD_WAIVER Protocol

A CORE card may ONLY be skipped if the agent includes a formal CARD_WAIVER.

**CARD_WAIVER format:**

| Field | Required | Description |
|-------|----------|-------------|
| Card ID | YES | Which card is being skipped (e.g., CARD-CORE-002) |
| Reason | YES | Specific reason for skipping (not "not needed") |
| Risk | YES | LOW / MEDIUM / HIGH — assessed risk of skipping |
| Mitigation | YES | What replaces the skipped card's safety check |
| Approved By | YES | Ghost Inspector (or Operator for CORE waivers) |

**Rules:**
- No waiver → no skip. Period.
- Skipping without a waiver = NUCLEAR severity (same weight as V-13)
- Ghost MUST verify all waivers during review (Ghost Gate)
- Inspector MUST verify all waivers during CARD_COMPLIANCE audit
- TASK and TOOL cards can be waived with just reason + risk (lighter process)
- CORE cards require full waiver with all 5 fields

### CDEX Tokens

| Token | Purpose |
|-------|---------|
| `OUTPUT_INVALID: CARD_COMPLIANCE_FAILED` | Agent output rejected — missing CARD_RECEIPT or required cards |
| `CARD_WAIVER: <CARD_ID>` | Formal waiver for skipping a card |
| `FAIL_BLOCKING` | Card acceptance criteria not met — cannot proceed |

### S-38: CARD_RECEIPT missing from agent output

```
STOP — Every agent output MUST include a CARD_RECEIPT section.
Missing receipt = OUTPUT_INVALID. Output is discarded.
Re-execute the work with proper card discipline.
```

### S-39: CORE card skipped without CARD_WAIVER

```
STOP — CORE cards are mandatory. Skipping without a formal CARD_WAIVER
is equivalent to skipping a pipeline gate. NUCLEAR severity.
```

### S-40: DevTools verification skipped during closeout

```
STOP — DevTools verification is a HARD GATE in BECCA CLOSE.
The Sentinel Ant MUST run every closeout. If Chrome DevTools MCP is not
available, STOP and request operator to configure it before proceeding.
Override requires explicit operator justification recorded in RUN_INDEX.
```

### S-41: Planner task has >5 target files

```
STOP — Re-decompose until every task has ≤5 target files (1-2 preferred).
Big tasks cause "plain Claude" takeover — the Ant loses protocol mid-task.
```

### S-42: Planner skipped Hive Mind check

```
STOP — Read all 6 Hive Mind indexes before decomposition.
Institutional memory prevents re-doing completed work and warns about
known pitfalls. Skipping this = planning blind.
```

### S-43: Circular dependency in Planner task graph

```
STOP — Circular dependencies are forbidden. If Task A depends on B and B
depends on A, refactor: extract the shared concern into a new task that
both A and B depend on.
```

### S-44: Inbox document >500 lines, not summarized

```
STOP — Apply summary-first protocol. Read first 50 lines, present summary
to operator, let operator pick which sections to plan this run. Reading
500+ lines raw will overflow Planner context.
```

### S-45: >7 tasks in single session without boundary

```
STOP — Add session boundary. NEO is single-chat: 7 tasks × ~8 interactions
each = ~56 turns = context limit. Split at a natural checkpoint (all
foundations done, or all of module X done).
```

---
