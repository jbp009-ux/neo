# NEO-SURGICAL v1.1.0
## Surgical Change Protocol — Zero-Assumption, Evidence-Based Modifications

**Purpose:** The 3 Laws of safe change, backup enforcement, data operation classification, anti-assumption rules, checkpoint enforcement, project isolation
**Scope:** Loaded by ALL NEO roles (Ant, Ghost, Inspector). BECCA enforces via Operator Manual.
**Origin:** Extracted from production incident response — agents destroyed menu/category data by assuming incomplete data was "broken" and rebuilding it.

---

## 0) Why This Exists

```
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║   THE #1 FAILURE MODE:                                                       ║
║                                                                              ║
║   An agent sees data that looks "incomplete" or "wrong."                     ║
║   Instead of investigating, it "fixes" the data by recreating it.            ║
║   The original data was INTENTIONAL. Now it's destroyed.                     ║
║                                                                              ║
║   At 100K tenants, one bad assumption = catastrophic data loss.              ║
║                                                                              ║
║   THIS MODULE PREVENTS THAT.                                                 ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
```

---

## 1) THE 3 LAWS (NON-NEGOTIABLE)

### LAW 1 — NO-GUESS (Understanding Before Action)

Before ANY code or data change, the Ant MUST prove understanding of:

| Check | Question | Evidence Required |
|-------|----------|-------------------|
| Current behavior | What does the system **actually do** right now? | Code paths + test output |
| Design intent | **Why** was it designed this way? | Comments, commit history, or operator confirmation |
| Hidden constraints | What is **intentionally hidden** or constrained? | Guardrails identified in code |
| Blast radius | What breaks at **100K scale** if this goes wrong? | Affected tenants / data scope |

**If ANY check cannot be evidenced: STOP and open an investigation. Do NOT proceed.**

```
┌─────────────────────────────────────────────────────────────────┐
│  "If you don't know WHY something exists, you don't know       │
│   enough to change it."                                         │
│                                                                 │
│  Something looking wrong ≠ something being wrong.               │
│  Investigate. Don't improvise.                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

### LAW 2 — BACKUP (Mandatory Before Destructive Operations)

Before ANY change classified as `DATA_WRITE`, `DATA_DELETE`, `MIGRATION`, or `SEED`:

1. **Create** a backup (timestamped, restorable, verified)
2. **Document** the backup (location, timestamp, restore steps)
3. **Verify** the backup (confirm restore path works)
4. **Present** backup proof to operator
5. **Obtain** `🔑 BACKUP APPROVED` before proceeding

**If backup is not created and verified: DO NOT PROCEED TO PATCH.**

### Backup Proof Format

```markdown
## BACKUP PROOF

| Field | Value |
|-------|-------|
| Timestamp | <ISO 8601> |
| Location | <path or export location> |
| Scope | <what was backed up — collections, files, configs> |
| Restore method | <exact commands/steps to restore> |
| Restore verified | YES / NO — <how verified> |
| Size / record count | <number of records or file size> |
```

### When Backup Is Required

| Data Operation | Backup Required? | Reason |
|----------------|-----------------|--------|
| `DATA_WRITE` | YES | Modifies existing data |
| `DATA_DELETE` | YES | Removes records |
| `MIGRATION` | YES | Transforms data structures |
| `SEED` | YES | Creates initial data (can overwrite) |
| `CODE_ONLY` | NO | Pure code changes, no data impact |
| `CONFIG_WRITE` | YES | Config changes can cascade |
| `READ_ONLY` | NO | No state change |

### Backup Exemption

Tasks classified as `CODE_ONLY` or `READ_ONLY` skip the backup gate. The Ant MUST classify each file change in FOOTPRINT (see Section 3).

---

### LAW 3 — SURGICAL (Minimum Delta)

Every change MUST be:

| Requirement | Description |
|-------------|-------------|
| **Minimal** | Smallest possible diff that achieves the objective |
| **Scoped** | Only files listed in FOOTPRINT are touched |
| **Reversible** | Rollback plan exists and is realistic |
| **Tested** | Validated with known dataset before marking done |

**Explicitly forbidden under LAW 3:**

| Forbidden Action | Why |
|-----------------|-----|
| "Rebuild from scratch" | Unless explicitly approved by operator with migration plan |
| "Clean up while I'm here" | Scope creep — log as separate task |
| "Recreate data that looks wrong" | Assumption — investigate intent first (LAW 1) |
| PUT (full replace) when PATCH (merge) works | Unnecessary blast radius |
| Batch update without per-record validation | Risks overwriting intentional data |

---

## 2) ANTI-ASSUMPTION RULES (FROZEN)

```
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║   THE ANT MUST NEVER:                                                        ║
║                                                                              ║
║   A-01  "Recreate" a menu/dataset because it looks incomplete                ║
║   A-02  Assume missing categories/items are errors                           ║
║   A-03  Re-seed demo content without confirming original intent              ║
║   A-04  "Clean up" data structures unless instructed AND backed up           ║
║   A-05  Run a reset/seed function on live data                               ║
║   A-06  Replace a collection/document when a merge would suffice             ║
║   A-07  Assume "empty" means "broken" — it may mean "not yet configured"    ║
║   A-08  Treat test/demo data patterns as production bugs                     ║
║                                                                              ║
║   IF SOMETHING LOOKS WRONG:                                                  ║
║   Investigate and report. DO NOT improvise a fix.                            ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
```

---

## 3) DATA OPERATION CLASSIFICATION

Every file change in FOOTPRINT MUST be classified with a Data Operation type:

### 3.1 Operation Types

| Type | Code | Description | Backup? | Extra Gate? |
|------|------|-------------|---------|-------------|
| Code Only | `CODE_ONLY` | Source code changes with no data impact | NO | — |
| Read Only | `READ_ONLY` | Analysis task, no modifications | NO | — |
| Data Write | `DATA_WRITE` | Modifies existing data (Firestore, DB, configs) | YES | `🔑 BACKUP APPROVED` |
| Data Delete | `DATA_DELETE` | Removes records or collections | YES | `🔑 BACKUP APPROVED` + confirmation |
| Migration | `MIGRATION` | Transforms data structure (schema changes, re-shapes) | YES | `🔑 BACKUP APPROVED` + dry-run |
| Seed | `SEED` | Creates initial/demo data (can overwrite existing) | YES | `🔑 BACKUP APPROVED` + scope check |
| Config Write | `CONFIG_WRITE` | Modifies configuration that affects behavior | YES | `🔑 BACKUP APPROVED` |

### 3.2 FOOTPRINT Classification Table

Every FOOTPRINT must include this table:

```markdown
## DATA OPERATION CLASSIFICATION

| File | Change Type | Data Op | Backup Required? | Write Semantics |
|------|-------------|---------|------------------|-----------------|
| menuFunctions.ts | MODIFY | DATA_WRITE | YES | PATCH (merge) |
| auth.ts | MODIFY | CODE_ONLY | NO | — |
| seedMenu.ts | MODIFY | SEED | YES | PUT (replace) — requires justification |
```

### 3.3 Write Semantics

| Semantic | Code | Behavior | Default? |
|----------|------|----------|----------|
| PATCH (merge) | `PATCH` | Updates only specified fields, preserves everything else | YES — default for all data updates |
| PUT (replace) | `PUT` | Replaces entire document/collection | NO — requires justification in FOOTPRINT |
| DELETE | `DELETE` | Removes record(s) entirely | NO — requires explicit confirmation |

**PATCH is the default.** Any operation using PUT or DELETE semantics MUST justify why PATCH is insufficient.

---

## 4) BACKUP GATE (Between FOOTPRINT and PATCH)

### 4.1 When Triggered

The BACKUP gate activates when ANY file in the FOOTPRINT is classified as:
- `DATA_WRITE`, `DATA_DELETE`, `MIGRATION`, `SEED`, or `CONFIG_WRITE`

If ALL files are `CODE_ONLY` or `READ_ONLY`, the BACKUP gate is **skipped** (Ant proceeds directly to PATCH after FOOTPRINT APPROVED).

### 4.2 Backup Gate Flow

```
FOOTPRINT APPROVED
    │
    ├── Any DATA_WRITE / DATA_DELETE / MIGRATION / SEED / CONFIG_WRITE?
    │
    ├── YES → STATE: BACKUP
    │         1. Create backup (timestamped)
    │         2. Document backup proof
    │         3. Verify restore path
    │         4. Present to operator
    │         ⏳ STOP: 🔑 BACKUP APPROVED required
    │         │
    │         └── PATCH state
    │
    └── NO (all CODE_ONLY / READ_ONLY) → PATCH state directly
```

### 4.3 Backup Gate Token

| Token | Issued By | Unlocks |
|-------|-----------|---------|
| `🔑 BACKUP APPROVED` | Operator | PATCH state (for tasks with data operations) |

### 4.4 Backup Gate in Gate Log

```markdown
| Gate | Token | Issued By | Timestamp |
|------|-------|-----------|-----------|
| FOOTPRINT | 🔑 FOOTPRINT APPROVED | Operator | <ISO> |
| BACKUP | 🔑 BACKUP APPROVED | Operator | <ISO> |
| PATCH | 🔑 PATCH APPROVED | Operator | <ISO> |
```

*(BACKUP row only present when gate was triggered)*

---

## 5) DRY-RUN REQUIREMENT (For Destructive Operations)

### 5.1 When Required

A dry-run is REQUIRED before applying changes when the task includes:
- `DATA_DELETE` operations
- `MIGRATION` operations
- `SEED` operations on existing data
- Any `PUT` (replace) semantics

### 5.2 Dry-Run Protocol

```
1. Run the change in a safe environment:
   - Local emulator / staging / test tenant
   - NEVER directly on production data (unless explicitly approved)

2. Validate:
   - No unexpected data loss
   - Existing records preserved where expected
   - Hidden constraints maintained
   - Tenant isolation intact

3. Document dry-run results in VERIFY section:
   - Environment used
   - Input dataset
   - Output dataset
   - Comparison (expected vs actual)
```

### 5.3 Dry-Run Evidence

Dry-run results MUST appear in the Ant's VERIFY section. Ghost checks for dry-run evidence when the task involves destructive data operations.

---

## 6) WIPE PROTECTION

### 6.1 Protected Patterns

The following patterns are **protected** — they cannot be executed without explicit multi-step authorization:

| Pattern | Description | Required Authorization |
|---------|-------------|----------------------|
| Collection overwrite | Replacing an entire Firestore collection | `🔑 BACKUP APPROVED` + `🔑 WIPE OVERRIDE: <collection>` |
| Document replace | PUT (replacing entire document, not merging) | `🔑 BACKUP APPROVED` + justification in FOOTPRINT |
| Batch delete | Deleting multiple records in one operation | `🔑 BACKUP APPROVED` + per-record validation |
| Reset function | Any function that "resets" data to initial state | `🔑 BACKUP APPROVED` + operator confirms it's not live data |
| Auto-seed on create | Creating data as a side effect of another operation | Must be flagged in FOOTPRINT — operator reviews |

### 6.2 Demo vs Live Separation

```
┌─────────────────────────────────────────────────────────────────┐
│  HARD RULE: Demo/seed paths and live-edit paths MUST be         │
│  clearly separated in the codebase.                             │
│                                                                 │
│  A function that seeds demo data MUST NOT be callable           │
│  from a live data editing path.                                 │
│                                                                 │
│  If the Ant encounters a function that can both seed AND edit:  │
│  → Flag it as a RED FLAG in DISCOVERY findings                  │
│  → Recommend separation in pheromone output                     │
└─────────────────────────────────────────────────────────────────┘
```

---

## 7) OPERATOR MANUAL REFERENCE

Every project SHOULD have an `OPERATOR_MANUAL_<PROJECT>.md` in `.neo/`. This manual is:

- Created by Scout on first run (or by operator manually)
- Read by BECCA during RECON
- Read by Ants during DISCOVERY (for danger zones and data models)
- Updated by BECCA during CLOSE (if new patterns discovered)

See `templates/OPERATOR_MANUAL.md` for the full template.

The Operator Manual is NOT governance — it's project-specific knowledge. It documents:
- Danger zones (files/endpoints that can wipe data)
- Critical data models (what must not be destroyed)
- Safe operation patterns (how to update menus, configs, etc.)
- Red flags (scripts that should never run on live data)

---

## 8) STOP CONDITIONS (Surgical-Specific)

These STOP conditions are in addition to those in `NEO-GATES.md`:

| # | Trigger | Action | Law |
|---|---------|--------|-----|
| S-19 | Data looks "incomplete" or "wrong" | STOP — investigate intent, do NOT fix on assumption | LAW 1 |
| S-20 | Urge to "recreate" or "rebuild" data | STOP — this is the #1 failure mode. Investigate first | LAW 1 |
| S-21 | Seed/demo function found in live path | STOP — flag demo/live mixing as RED FLAG | LAW 3 |
| S-22 | Batch update/overwrite without PATCH semantics | STOP — justify why PATCH is insufficient | LAW 3 |
| S-23 | Backup not created before data operation | STOP — LAW 2 violation, create backup first | LAW 2 |
| S-24 | PUT semantics used without justification | STOP — default is PATCH (merge), justify replacement | LAW 3 |

---

## 9) CHECKPOINT FIRST (FROZEN)

```
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║   EVERY ANT CREATES A SAFETY NET — NO EXCEPTIONS.                           ║
║                                                                              ║
║   Before reading code, before DISCOVERY, before anything:                   ║
║                                                                              ║
║   1. Verify PROJECT LOCK matches the TODO project                           ║
║   2. Create git checkpoint:                                                  ║
║      a. git stash (save uncommitted work)                                   ║
║      b. Record HEAD hash (the recovery point)                               ║
║   3. Present CHECKPOINT PROOF to operator:                                   ║
║      - HEAD hash, stash status, project lock root                           ║
║   4. Only AFTER checkpoint: transition to DISCOVERY                          ║
║                                                                              ║
║   WHY: The user reported Ants making changes with NO WAY TO UNDO.           ║
║   The checkpoint is your safety net. If anything goes wrong,                ║
║   the operator can restore to the checkpoint.                                ║
║                                                                              ║
║   NO CHECKPOINT = NO WORK. (S-26)                                           ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
```

### Checkpoint Proof Format

```markdown
## CHECKPOINT PROOF

| Field | Value |
|-------|-------|
| Project Lock | <PROJECT> at <absolute path> |
| HEAD hash | <git rev-parse HEAD output> |
| Stash | <git stash output or "working tree clean"> |
| Branch | <current branch name> |
| Timestamp | <ISO 8601> |
```

### When Checkpoint Is Required

| Situation | Checkpoint Required? |
|-----------|---------------------|
| ANY Ant activation | YES — always, no exceptions |
| Ghost activation | NO — Ghost only reads |
| Inspector activation | NO — Inspector only reads |
| BECCA RECON | NO — BECCA only reads |
| Scout | NO — Scout only reads |

---

## 10) PROJECT ISOLATION (FROZEN)

```
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║   🔒 ONE PROJECT PER RUN. NO CROSS-PROJECT WORK.                            ║
║                                                                              ║
║   BECCA declares PROJECT LOCK during RECON:                                 ║
║   • Locked root = absolute path to project directory                        ║
║   • ALL file reads/writes MUST be within this root                          ║
║   • Exception: 🔑 CROSS-PROJECT READ for read-only access to external      ║
║   • Cross-project WRITE is NEVER allowed                                    ║
║                                                                              ║
║   WHY: The user reported BECCA auditing Project A but Ants working on       ║
║   Project B's files. PROJECT LOCK prevents this permanently.                 ║
║                                                                              ║
║   VIOLATION: V-10 (PROJECT LOCK VIOLATION)                                  ║
║   → Ghost: automatic rejection                                              ║
║   → Inspector: compliance fail                                               ║
║   → Operator: arbitrates severity                                            ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
```

### Path Validation Rule

Before EVERY file operation (read, write, grep, glob), the Ant MUST verify:

```
Is this path within the PROJECT LOCK root?

✅ d:\projects\sonny\functions\src\auth.ts    (inside d:\projects\sonny\)
✅ d:\projects\sonny\.neo\STATE.md            (inside d:\projects\sonny\)
❌ d:\projects\rizend\src\api.ts              (OUTSIDE — V-10 VIOLATION)
❌ d:\projects\beccaos\src\app\page.tsx       (OUTSIDE — V-10 VIOLATION)
```

---

## 11) Quick Reference

```
┌─────────────────────────────────────────────────────────────────────────────┐
│  NEO-SURGICAL v1.1.0 — QUICK REFERENCE                                     │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  THE 3 LAWS:                                                                │
│  LAW 1 — NO-GUESS:    Prove understanding before changing anything          │
│  LAW 2 — BACKUP:      Create + verify backup before data operations         │
│  LAW 3 — SURGICAL:    Minimum delta. PATCH by default. No rebuilds.         │
│                                                                             │
│  ANTI-ASSUMPTION RULES (A-01 → A-08):                                      │
│  "Looks wrong" ≠ "is wrong." Investigate. Don't improvise.                 │
│                                                                             │
│  DATA OPS: CODE_ONLY | READ_ONLY | DATA_WRITE | DATA_DELETE |              │
│            MIGRATION | SEED | CONFIG_WRITE                                  │
│                                                                             │
│  WRITE SEMANTICS: PATCH (merge, default) | PUT (replace, justify) |        │
│                   DELETE (remove, confirm)                                   │
│                                                                             │
│  BACKUP GATE: Triggered when any file is DATA_WRITE/DELETE/MIGRATION/SEED  │
│  Token: 🔑 BACKUP APPROVED (between FOOTPRINT and PATCH)                  │
│  Skipped for CODE_ONLY / READ_ONLY tasks                                   │
│                                                                             │
│  DRY-RUN: Required for DATA_DELETE, MIGRATION, SEED, any PUT semantics     │
│  Run in safe environment, document results in VERIFY                        │
│                                                                             │
│  WIPE PROTECTION: Collection overwrite, batch delete, reset functions       │
│  require 🔑 BACKUP APPROVED + additional authorization                     │
│                                                                             │
│  OPERATOR MANUAL: .neo/OPERATOR_MANUAL_<PROJECT>.md                        │
│  Project-specific danger zones, data models, safe operations                │
│                                                                             │
│  STOP CONDITIONS: S-19 → S-24 (assumption, rebuild, seed/live, PUT)        │
│  ISOLATION STOPS: S-25 → S-28 (project lock, checkpoint, scope, wrong)     │
│                                                                             │
│  ⛑️ CHECKPOINT FIRST: git stash + record HEAD hash BEFORE any work         │
│  No checkpoint = no work (S-26). Every Ant, every time.                     │
│                                                                             │
│  🔒 PROJECT LOCK: One project per run. Set by BECCA in RECON.              │
│  V-10 = file outside locked root. WRITE outside = NEVER.                    │
│  🔑 CROSS-PROJECT READ for read-only exceptions only.                      │
│                                                                             │
│  GOLDEN RULE: If something looks wrong, INVESTIGATE and REPORT.             │
│  DO NOT "fix" it. You may be destroying intentional design.                 │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Changelog

### [1.1.0] 2026-02-11
- CHECKPOINT FIRST (FROZEN): Every Ant creates git checkpoint before ANY work
- Checkpoint Proof Format: project lock, HEAD hash, stash, branch, timestamp
- PROJECT ISOLATION (FROZEN): One project per run, no cross-project work
- Path Validation Rule: every file op must verify path is within locked root
- V-10 reference: PROJECT LOCK VIOLATION (defined in NEO-GATES.md v1.5.0)
- S-25→S-28 reference: project lock stops (defined in NEO-GATES.md v1.5.0)
- Quick Reference: CHECKPOINT FIRST + PROJECT LOCK sections added
- Section numbering: Quick Reference is now Section 11 (was 9)
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.0.0] 2026-02-10
- Initial release — Surgical Change Protocol
- LAW 1: NO-GUESS (understanding before action, 4-check proof table)
- LAW 2: BACKUP (mandatory for data operations, backup proof format, backup gate)
- LAW 3: SURGICAL (minimum delta, PATCH default, no rebuilds)
- Anti-Assumption Rules (A-01 → A-08, FROZEN)
- Data Operation Classification (7 types, FOOTPRINT table format)
- Write Semantics (PATCH/PUT/DELETE with defaults)
- Backup Gate (between FOOTPRINT and PATCH, conditional on data ops)
- Dry-Run Requirement (for destructive operations)
- Wipe Protection (protected patterns, demo/live separation)
- STOP Conditions (S-19 → S-24)
- Operator Manual reference
- ALL rules are MANUAL ONLY — NO AUTOMATION
