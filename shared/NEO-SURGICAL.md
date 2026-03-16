# NEO-SURGICAL v1.4.0
## Surgical Change Protocol — Zero-Assumption, Evidence-Based Modifications

**Purpose:** The 3 Laws of safe change, backup enforcement, data operation classification, anti-assumption rules, checkpoint enforcement, project isolation, protected features, SaaS data safety (tenant isolation, secret handling, PII protection, environment gates)
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

### Backup Scope Requirements

The backup MUST cover ALL data that could be affected by the task. "I backed up the file" is insufficient.

| Task Type | Minimum Backup Scope | Example |
|-----------|---------------------|---------|
| Single document change | That document + parent collection snapshot (count + sample) | `users/uid123` + `users` collection count |
| Collection-level operation | Full collection export (all docs) | `firestore export --collection=menus` |
| Cross-collection operation | All affected collections | `menus` + `categories` + `menuItems` |
| Schema/migration change | Full database export or affected collections + rollback script | `firestore export --all` or targeted exports |
| Config change | Current config file + deployment state | `.env` backup + `firebase functions:config:get` |
| Auth/security change | Auth config + affected user records (sample) | `firebase auth:export` + security rules backup |

**Rule: When in doubt, back up MORE, not less. A 5-minute broader backup prevents a 5-hour recovery.**

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

### Restore Test Protocol (MANDATORY for DATA_DELETE and MIGRATION)

```
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║   BACKUP WITHOUT RESTORE TEST = FALSE CONFIDENCE                            ║
║                                                                              ║
║   "Restore verified: YES" is NOT acceptable as self-attestation.            ║
║   For destructive operations, you must PROVE the restore works.             ║
║                                                                              ║
║   RESTORE TEST (required for DATA_DELETE and MIGRATION):                    ║
║   1. Export the backup to a verifiable location                              ║
║   2. Attempt a restore in a SAFE environment (emulator, test tenant)        ║
║   3. Compare restored data to original (record count, sample docs)          ║
║   4. Document the restore test result:                                       ║
║                                                                              ║
║   RESTORE TEST PROOF:                                                        ║
║   | Field | Value |                                                          ║
║   |-------|-------|                                                          ║
║   | Test environment | <emulator / staging / test tenant> |                  ║
║   | Records backed up | <N> |                                                ║
║   | Records restored | <N> — must match backed up |                          ║
║   | Sample verified | <doc ID checked — fields match> |                      ║
║   | Restore time | <how long the restore took> |                             ║
║   | Result | PASS / FAIL |                                                   ║
║                                                                              ║
║   For CODE_ONLY backup (git): verify git stash pop or checkout works.       ║
║   For CONFIG_WRITE: verify config can be re-applied.                        ║
║                                                                              ║
║   IF RESTORE TEST FAILS: DO NOT PROCEED. Fix backup first.                  ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
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

### Desktop Backup (Two-Layer Safety — HIGH Risk Tasks Only)

```
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║   🔴 HIGH RISK TASKS — TWO-LAYER BACKUP                                    ║
║                                                                              ║
║   For tasks classified as 🔴 HIGH risk (Fire Ant, Financial Ant,            ║
║   Color Expert Ant), the standard git checkpoint is NOT enough.              ║
║                                                                              ║
║   LAYER 1: Git checkpoint (standard — all Ants do this)                     ║
║   LAYER 2: Desktop copy OUTSIDE the repo                                    ║
║                                                                              ║
║   Before PATCH, copy the target files to a backup folder:                   ║
║   → <Desktop>/neo-backup/<TASK_ID>/<original filenames>                     ║
║                                                                              ║
║   Present DESKTOP BACKUP PROOF:                                              ║
║   | Field | Value |                                                          ║
║   |-------|-------|                                                          ║
║   | Location | <Desktop>/neo-backup/<TASK_ID>/ |                            ║
║   | Files | <list of files copied> |                                        ║
║   | Verified | YES — ls shows files present |                               ║
║                                                                              ║
║   WHY: Git checkpoints can be lost to accidental force-push or              ║
║   branch deletion. A filesystem copy outside the repo is the                ║
║   ultimate safety net for high-risk tasks.                                   ║
║                                                                              ║
║   🟡🟢 STANDARD/LOW risk: Git checkpoint only (Layer 1 sufficient)         ║
║   🟠 MEDIUM risk: Git checkpoint only (Layer 1 sufficient)                  ║
║   🔴 HIGH risk: Both layers required                                        ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
```

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

### 2b) ANTI-ASSUMPTION RULES FOR CODE FEATURES (FROZEN)

```
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║   THE ANT MUST NEVER:                                                        ║
║                                                                              ║
║   A-09  Remove a feature because it "seems unused" — SEARCH EXHAUSTIVELY    ║
║   A-10  Replace an implementation with a "better" one in a different file    ║
║   A-11  Delete components, hooks, or utilities outside the task scope        ║
║   A-12  Claim "this feature doesn't exist" without grep evidence            ║
║   A-13  "Consolidate" or "simplify" by reducing feature count               ║
║   A-14  Reclassify feature removal as "refactoring" or "cleanup"            ║
║                                                                              ║
║   JUST AS "LOOKS WRONG" ≠ "IS WRONG" FOR DATA:                             ║
║   "LOOKS UNUSED" ≠ "IS UNUSED" FOR CODE.                                    ║
║                                                                              ║
║   If you think code is unused: PROVE IT with exhaustive grep + import       ║
║   tracing. Then REPORT it as a finding. DO NOT DELETE IT.                   ║
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

## 6b) PROTECTED FEATURES (Code Feature Protection)

### Why This Exists

```
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║   THE #2 FAILURE MODE:                                                       ║
║                                                                              ║
║   Data has Protected Collections (count before/after, backup gate).          ║
║   Code features had NOTHING equivalent.                                      ║
║                                                                              ║
║   An Ant removes 10 voice files (3,288 lines) as CODE_ONLY.                 ║
║   No backup gate. No count verification. No safety net.                      ║
║   The operator approves FOOTPRINT without realizing the feature is gone.     ║
║                                                                              ║
║   THIS SECTION CLOSES THAT GAP.                                             ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
```

### 6b.1 What Is a Protected Feature

A **Protected Feature** is a named group of source code files that together implement a user-facing capability. Removing, gutting, or relocating a protected feature requires the same rigor as deleting a data collection.

### 6b.2 Protected Feature Registry

Each project SHOULD maintain a `.neo/PROTECTED_FEATURES.md` file:

```markdown
# PROTECTED FEATURES — <Project Name>

## Features requiring 🔑 FEATURE REMOVAL OVERRIDE

| Feature ID | Name | Files | Owner |
|------------|------|-------|-------|
| PF-001 | Voice (Web) | frontend/src/**/voice*, hooks/useSonnyTTS*, hooks/useVoiceInput*, lib/voiceStorage* | Run 007 |
| PF-002 | Voice (Native) | frontend-native/src/**/voice*, hooks/useNativeTTS*, hooks/useNativeSTT* | Run 007 |
| PF-003 | Order Flow | frontend/src/app/order/*, lib/orderEngine* | Run 001 |
| PF-004 | TTS Backend | functions/src/functions/ttsFunctions* | Run 007 |
```

**If this file doesn't exist, the Ant MUST still apply Protected Feature rules to any feature with 3+ related files.**

### 6b.3 Protected Feature Rules

| Rule | Description |
|------|-------------|
| **Count before / count after** | Before PATCH, count all files + exported functions/components in the feature. After PATCH, count again. If count DECREASES → STOP (S-29) |
| **Feature Impact in FOOTPRINT** | FOOTPRINT must include a FEATURE IMPACT section listing which user-facing features are affected and whether each survives intact (see NEO-GATES.md) |
| **No silent removal** | Any file deletion or function removal that belongs to a protected feature requires `🔑 FEATURE REMOVAL OVERRIDE: <Feature ID>` |
| **No relocation without mapping** | Moving feature code to a different file/path requires a RELOCATION MAP in FOOTPRINT showing old path → new path for every file |
| **3-file threshold** | Any group of 3+ related files implementing one capability is AUTOMATICALLY a protected feature, even if not in the registry |

### 6b.4 Feature Removal Override Protocol

```
1. Ant identifies feature removal in FOOTPRINT
2. Ant flags it: "⚠️ FEATURE REMOVAL: <Feature ID / name>"
3. Ant presents:
   - Feature file count and total LOC being removed
   - Reason for removal
   - Confirmation that no other code depends on these files
   - Rollback plan (git commit hash to restore from)
4. Operator reviews and issues: 🔑 FEATURE REMOVAL OVERRIDE: <Feature ID>
5. Override is SINGLE-USE — one feature, one task
```

### 6b.5 Feature Count Verification (VERIFY Step)

The Ant MUST include a **Feature Inventory** in the VERIFY section:

```markdown
## FEATURE INVENTORY

| Feature | Files Before | Files After | Exports Before | Exports After | Status |
|---------|-------------|-------------|----------------|---------------|--------|
| Voice (Web) | 10 | 10 | 15 | 15 | ✅ INTACT |
| Order Flow | 5 | 6 | 8 | 10 | ✅ EXPANDED (new helper) |
| Auth | 3 | 3 | 5 | 5 | ✅ INTACT |
```

**If any feature shows DECREASED counts without `🔑 FEATURE REMOVAL OVERRIDE`, the task FAILS verification.**

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
| S-29 | Feature file/export count decreased after PATCH | STOP — protected feature shrunk. Requires `🔑 FEATURE REMOVAL OVERRIDE` if intentional | LAW 3 |
| S-30 | Claiming code "doesn't exist" or is "unused" without evidence | STOP — prove non-existence with exhaustive grep + import tracing before proceeding | LAW 1 |
| S-31 | Existing feature removed or disabled during task | STOP — scope contraction detected. Feature removal is NOT a side effect — it's a separate task | LAW 3 |

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

## 10b) SAFE FEATURE DEPRECATION PROTOCOL

When a feature is intentionally being removed (not accidentally — see Protected Features above), follow this protocol:

### 10b.1 Feature Deprecation Checklist

```
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║   FEATURE DEPRECATION — DO NOT "JUST DELETE"                                 ║
║                                                                              ║
║   Removing a feature is the REVERSE of building one.                        ║
║   It requires the same rigor: plan, evidence, verification.                 ║
║                                                                              ║
║   1. INVENTORY: List ALL files, exports, routes, UI elements, and           ║
║      database collections that belong to the feature.                       ║
║      → Use Protected Feature Registry or 3-file detection                   ║
║                                                                              ║
║   2. DEPENDENCY SCAN: Find ALL code that references the feature:            ║
║      → grep for imports, function calls, route references                   ║
║      → grep for string references (feature names in UI, configs)            ║
║      → Check tests that test this feature                                   ║
║      → Check CI/CD pipelines for feature-specific steps                     ║
║                                                                              ║
║   3. DATA IMPACT: Does the feature have associated data?                    ║
║      → Firestore collections? User preferences? Stored configs?             ║
║      → Data does NOT get deleted with the code — plan for orphaned data    ║
║      → Decision: keep data (archive) or migrate/clean up (separate task)   ║
║                                                                              ║
║   4. USER IMPACT: Does this feature have active users?                      ║
║      → If yes: plan deprecation notice, migration path, sunset date         ║
║      → If no: proceed with removal                                          ║
║                                                                              ║
║   5. FOOTPRINT: The removal FOOTPRINT must include:                          ║
║      → Feature Inventory (before state — all files/exports)                 ║
║      → Dependency list (what breaks when feature is removed)                ║
║      → Data impact plan (keep/archive/migrate/delete)                       ║
║      → User impact assessment                                                ║
║      → Cleanup plan (orphaned imports, unused dependencies, dead routes)    ║
║      → 🔑 FEATURE REMOVAL OVERRIDE: <Feature ID>                           ║
║                                                                              ║
║   6. VERIFY: After removal, verify:                                          ║
║      → Build passes (no broken imports)                                     ║
║      → Tests pass (no references to removed code)                           ║
║      → No orphaned files left behind                                        ║
║      → No orphaned routes (404s where feature used to be)                   ║
║      → UI has no dead links to removed feature                              ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
```

### 10b.2 Feature Removal is ALWAYS Its Own Task

Feature removal is NEVER a side effect of another task:
- A bug fix does NOT remove a feature
- A refactor does NOT remove a feature
- "Cleanup" does NOT remove a feature
- If removal is needed, create a SEPARATE task with the Deprecation Checklist

---

## 11) SECRET HANDLING (SaaS Safety)

```
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║   🔒 SECRET HANDLING — NO SECRETS IN CODE, LOGS, OR REPORTS                 ║
║                                                                              ║
║   Secrets include: API keys, tokens, passwords, connection strings,          ║
║   private keys, webhook signing secrets, service account JSON,               ║
║   encryption keys, OAuth client secrets, database credentials.               ║
║                                                                              ║
║   DETECTION (Ant MUST scan during DISCOVERY):                               ║
║   1. Grep for common secret patterns in target files:                        ║
║      → /[Aa]pi[_-]?[Kk]ey|[Ss]ecret|[Pp]assword|[Tt]oken|[Cc]redential/  ║
║      → /(sk|pk|rk)_(live|test)_[a-zA-Z0-9]/  (Stripe-style keys)          ║
║      → /-----BEGIN (RSA |EC |)PRIVATE KEY-----/                             ║
║      → Hardcoded base64 strings > 20 chars in source files                  ║
║   2. Check .env files are in .gitignore                                      ║
║   3. Check for secrets in Firestore documents or client-visible code        ║
║                                                                              ║
║   IF SECRET FOUND IN CODE:                                                   ║
║   → STOP — S-12 (Hardcoded secrets found)                                   ║
║   → Emit ⚫ NUCLEAR pheromone: CREDENTIAL_EXPOSURE                          ║
║   → Do NOT include the actual secret value in your report                   ║
║   → Report: file path, line number, secret TYPE (not value)                 ║
║                                                                              ║
║   WHERE SECRETS BELONG:                                                      ║
║   ✅ Environment variables (.env.local, .env.production)                    ║
║   ✅ Firebase Secret Manager (defineSecret in Cloud Functions)              ║
║   ✅ Cloud provider secret storage (GCP Secret Manager, AWS Secrets)        ║
║   ❌ Source code (hardcoded strings)                                        ║
║   ❌ Firestore documents                                                    ║
║   ❌ Client-side JavaScript                                                 ║
║   ❌ Git history (if committed, must be rotated immediately)                ║
║   ❌ Ant reports, Ghost reviews (never paste secret values in reports)      ║
║                                                                              ║
║   ANTI-PATTERN: "I'll just hardcode it for now and fix it later"            ║
║   → This is how production secrets leak. NEVER. Use env vars from day 1.    ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
```

---

## 12) TENANT ISOLATION ENFORCEMENT (SaaS Safety)

```
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║   🏢 TENANT ISOLATION — THE #1 SaaS SAFETY REQUIREMENT                      ║
║                                                                              ║
║   At 100K tenants, ONE unscoped query exposes ALL tenants' data.            ║
║   This is not a bug. This is a lawsuit.                                      ║
║                                                                              ║
║   MANDATORY TENANT ISOLATION SCAN (Ant DISCOVERY step):                     ║
║                                                                              ║
║   If the project is multi-tenant (check CLAUDE.md / Operator Manual):       ║
║                                                                              ║
║   1. IDENTIFY the tenant boundary:                                           ║
║      → Firestore: subcollection path (businesses/{bid}/...)                 ║
║      → Or: businessId / tenantId field on every document                    ║
║      → Document this in DISCOVERY output                                     ║
║                                                                              ║
║   2. SCAN target files for unscoped queries:                                 ║
║      → grep for collection group queries: collectionGroup(                   ║
║      → grep for top-level queries without tenant filter                     ║
║      → grep for .where() chains — verify tenant ID is present              ║
║                                                                              ║
║   3. VERIFY every data access path includes tenant scoping:                  ║
║      → Direct reads: doc path must include tenant segment                   ║
║      → Queries: .where('businessId', '==', ...) OR subcollection path      ║
║      → Aggregations: must be within tenant boundary                         ║
║                                                                              ║
║   4. REPORT in DISCOVERY output:                                             ║
║      TENANT ISOLATION SCAN:                                                  ║
║      | Check | Result |                                                      ║
║      |-------|--------|                                                      ║
║      | Tenant boundary | <path pattern or field> |                           ║
║      | Unscoped queries found | <N> (list if > 0) |                          ║
║      | Collection group queries | <N> — all tenant-filtered? YES/NO |        ║
║      | Verdict | ✅ ISOLATED / ⚫ BREACH DETECTED |                          ║
║                                                                              ║
║   IF BREACH DETECTED: STOP → S-07/S-08 → ⚫ NUCLEAR pheromone              ║
║                                                                              ║
║   NON-MULTI-TENANT PROJECTS: Skip scan, note "Single-tenant — N/A"         ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
```

---

## 13) PII & PAYMENT DATA CLASSIFICATION (SaaS Safety)

### 13.1 Data Sensitivity Tiers

Every data field touched by the task MUST be classified by sensitivity:

| Tier | Classification | Examples | Handling Rules |
|------|---------------|----------|----------------|
| 🔴 **T1 — RESTRICTED** | PII + Payment + Auth | SSN, credit card, password hash, auth tokens, private keys | Never log. Never in reports. Encrypt at rest. Access audit required. |
| 🟠 **T2 — CONFIDENTIAL** | Business-sensitive | Email, phone, address, billing info, revenue data, tenant configs | Minimize logging. Mask in reports (show last 4 only). Tenant-scoped access. |
| 🟡 **T3 — INTERNAL** | Operational | User preferences, feature flags, usage metrics, system configs | Normal handling. Tenant-scoped. OK in internal reports. |
| 🟢 **T4 — PUBLIC** | Non-sensitive | Product descriptions, menu items, public settings | No restrictions. |

### 13.2 PII Handling Rules

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│   PII IN ANT REPORTS:                                           │
│   • NEVER paste real user data in reports (emails, names, etc.) │
│   • Use anonymized examples: user@example.com, "User 12345"    │
│   • If you need to reference specific data: use document IDs    │
│   • Screenshots: blur/redact PII before including               │
│                                                                 │
│   PII IN CODE:                                                  │
│   • console.log() must NOT log T1/T2 data in production        │
│   • Error messages must NOT include user PII                    │
│   • API responses must NOT leak cross-tenant PII                │
│                                                                 │
│   PII IN BACKUPS:                                               │
│   • Backups containing T1/T2 data must note this in BACKUP PROOF│
│   • Backup location must be access-controlled                   │
│   • Do NOT store T1 backups in shared/public locations          │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 13.3 Ant DISCOVERY: Data Classification Check

When the task involves data operations (DATA_WRITE, DATA_DELETE, MIGRATION, SEED):

```
DATA CLASSIFICATION:
| Field/Collection | Tier | Contains PII? | Handling |
|-----------------|------|---------------|----------|
| <field name>    | T1-T4 | YES/NO       | <rule>   |
```

Ghost verifies that T1/T2 data has appropriate handling. Inspector audits PII compliance.

---

## 14) ENVIRONMENT GATE (SaaS Safety)

```
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║   🌍 ENVIRONMENT GATE — KNOW WHERE YOU'RE DEPLOYING                         ║
║                                                                              ║
║   Every FOOTPRINT MUST declare TARGET_ENVIRONMENT:                          ║
║                                                                              ║
║   TARGET_ENVIRONMENT: <EMULATOR / STAGING / PRODUCTION>                     ║
║                                                                              ║
║   EMULATOR:    Local Firebase emulator, localhost dev server                 ║
║   STAGING:     Non-production deployment (preview, test tenant)              ║
║   PRODUCTION:  Live deployment serving real users and real data              ║
║                                                                              ║
║   PRODUCTION SAFETY RULES:                                                   ║
║                                                                              ║
║   1. Destructive operations (DATA_DELETE, MIGRATION, SEED with PUT)         ║
║      targeting PRODUCTION require:                                           ║
║      → 🔑 BACKUP APPROVED (standard)                                       ║
║      → 🔑 PRODUCTION CONFIRMED (additional — operator explicitly confirms  ║
║         "yes, this targets production and I accept the risk")               ║
║      → Dry-run in EMULATOR or STAGING first (mandatory, not optional)       ║
║                                                                              ║
║   2. FOOTPRINT must show:                                                    ║
║      | Environment | PRODUCTION |                                            ║
║      | Dry-run completed in | EMULATOR/STAGING — <date/evidence> |           ║
║      | Rollback plan | <specific steps to undo in production> |              ║
║      | Blast radius | <N tenants / N users affected> |                       ║
║                                                                              ║
║   3. CODE_ONLY changes targeting PRODUCTION: normal gate flow               ║
║      (no additional confirmation needed — code deploys are reversible)      ║
║                                                                              ║
║   4. SEED operations: NEVER target PRODUCTION unless:                        ║
║      → Operator Manual explicitly marks the seed as production-safe         ║
║      → 🔑 PRODUCTION CONFIRMED issued                                      ║
║      → Dry-run evidence from emulator/staging provided                      ║
║                                                                              ║
║   IF TARGET_ENVIRONMENT IS MISSING FROM FOOTPRINT:                           ║
║   Ghost MUST reject — "Environment not declared. S-35."                     ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
```

---

## 15) DESTRUCTIVE OPERATION REGISTRY (SaaS Safety)

Beyond the existing WIPE PROTECTION (Section 6), these operations are classified as **destructive** and require heightened scrutiny:

| Operation | Classification | Required Evidence | Gate |
|-----------|---------------|-------------------|------|
| `deleteDoc()` / `deleteCollection()` | DATA_DELETE | Backup proof + scope + count before/after | 🔑 BACKUP APPROVED |
| `setDoc()` without `{ merge: true }` | PUT (destructive) | Justification why PATCH insufficient | Must justify in FOOTPRINT |
| `batch.delete()` / bulk delete | BATCH_DELETE | Per-record validation + backup | 🔑 BACKUP APPROVED + confirmation |
| Firebase rules deploy | CONFIG_WRITE | Rules diff + emulator test | 🔑 BACKUP APPROVED |
| `DROP TABLE` / schema migration | MIGRATION | Full backup + dry-run + restore test | 🔑 BACKUP APPROVED + 🔑 PRODUCTION CONFIRMED |
| User auth changes (claims, disable) | AUTH_WRITE | Affected user count + rollback plan | 🔑 CRITICAL SURFACE OVERRIDE |
| Stripe price/product changes | FINANCIAL_WRITE | Current state snapshot + rollback | 🔑 CRITICAL SURFACE OVERRIDE |
| Environment variable changes | CONFIG_WRITE | Current values backed up (not in report) | 🔑 BACKUP APPROVED |
| Cron/scheduled function changes | CONFIG_WRITE | Current schedule documented + rollback | 🔑 BACKUP APPROVED |
| DNS/domain changes | INFRA_WRITE | Current DNS records snapshot | 🔑 PRODUCTION CONFIRMED |

### Audit Trail for Destructive Ops

Every destructive operation MUST be logged in the Ant report with:

```
DESTRUCTIVE OPERATION LOG:
| # | Operation | Target | Before State | After State | Reversible? |
|---|-----------|--------|-------------|-------------|-------------|
| 1 | <op>      | <target> | <state>   | <state>     | YES/NO     |
```

Ghost verifies each logged operation. Inspector audits the audit trail completeness.

---

## 16) Quick Reference

```
┌─────────────────────────────────────────────────────────────────────────────┐
│  NEO-SURGICAL v1.4.0 — QUICK REFERENCE                                     │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  THE 3 LAWS:                                                                │
│  LAW 1 — NO-GUESS:    Prove understanding before changing anything          │
│  LAW 2 — BACKUP:      Create + verify backup before data operations         │
│  LAW 3 — SURGICAL:    Minimum delta. PATCH by default. No rebuilds.         │
│                                                                             │
│  ANTI-ASSUMPTION RULES (A-01 → A-08 data, A-09 → A-14 code):              │
│  "Looks wrong" ≠ "is wrong." "Looks unused" ≠ "is unused."               │
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
│  🔴 DESKTOP BACKUP (HIGH risk only — Two-Layer Safety):                    │
│  Layer 1: Git checkpoint (all Ants). Layer 2: Desktop copy outside repo.  │
│  Copy target files to <Desktop>/neo-backup/<TASK_ID>/                      │
│  Present DESKTOP BACKUP PROOF before PATCH.                                │
│                                                                             │
│  DRY-RUN: Required for DATA_DELETE, MIGRATION, SEED, any PUT semantics     │
│  Run in safe environment, document results in VERIFY                        │
│                                                                             │
│  WIPE PROTECTION: Collection overwrite, batch delete, reset functions       │
│  require 🔑 BACKUP APPROVED + additional authorization                     │
│                                                                             │
│  PROTECTED FEATURES (Section 6b):                                           │
│  Code features with 3+ files = automatically protected                     │
│  Count files+exports BEFORE and AFTER PATCH — decrease = S-29 STOP         │
│  Removal requires 🔑 FEATURE REMOVAL OVERRIDE: <Feature ID>               │
│  FOOTPRINT must include FEATURE IMPACT section                              │
│  VERIFY must include FEATURE INVENTORY table                                │
│                                                                             │
│  OPERATOR MANUAL: .neo/OPERATOR_MANUAL_<PROJECT>.md                        │
│  Project-specific danger zones, data models, safe operations                │
│                                                                             │
│  STOP CONDITIONS: S-19 → S-24 (assumption, rebuild, seed/live, PUT)        │
│  FEATURE STOPS:   S-29 → S-31 (count decreased, non-existence claim,      │
│                   feature removal as side-effect)                           │
│  ISOLATION STOPS: S-25 → S-28 (project lock, checkpoint, scope, wrong)     │
│                                                                             │
│  ⛑️ CHECKPOINT FIRST: git stash + record HEAD hash BEFORE any work         │
│  No checkpoint = no work (S-26). Every Ant, every time.                     │
│                                                                             │
│  🔒 PROJECT LOCK: One project per run. Set by BECCA in RECON.              │
│  V-10 = file outside locked root. WRITE outside = NEVER.                    │
│  🔑 CROSS-PROJECT READ for read-only exceptions only.                      │
│                                                                             │
│  SAAS DATA SAFETY (Sections 11-15):                                        │
│  🔒 SECRET HANDLING: Grep for secrets in DISCOVERY. Never in code/reports.│
│     S-12: secret found → STOP → ⚫ NUCLEAR CREDENTIAL_EXPOSURE            │
│  🏢 TENANT ISOLATION: Mandatory scan in DISCOVERY for multi-tenant.       │
│     Verify every query is tenant-scoped. Breach → ⚫ NUCLEAR              │
│  🔴 PII TIERS: T1 Restricted | T2 Confidential | T3 Internal | T4 Public │
│     Never log T1/T2. Mask in reports. Encrypt at rest.                    │
│  🌍 ENVIRONMENT GATE: FOOTPRINT must declare TARGET_ENVIRONMENT.          │
│     PRODUCTION + destructive → 🔑 PRODUCTION CONFIRMED required          │
│     Dry-run in emulator/staging FIRST (mandatory for prod destructive)    │
│  💥 DESTRUCTIVE OPS: Registry of dangerous operations with required gates │
│     DESTRUCTIVE OPERATION LOG in Ant report (before/after/reversible)     │
│  🔑 PRODUCTION CONFIRMED: New token for prod destructive ops             │
│  🔑 BACKUP APPROVED: Scope must match task (not just "I backed up")      │
│     RESTORE TEST: Mandatory for DATA_DELETE and MIGRATION                 │
│                                                                             │
│  GOLDEN RULE: If something looks wrong, INVESTIGATE and REPORT.             │
│  DO NOT "fix" it. You may be destroying intentional design.                 │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---
