# NEO Pipeline v2.4.0

A manual-first task execution pipeline. Every gate requires explicit human approval — no automation, no auto-approvals. Everything starts and ends with BECCA.

**Source:** `d:\projects\neo\`
**Origin:** Extracted from the IAMBecca multi-agent governance framework

---

## Quick Start

### 1. Deploy NEO to a project

```powershell
# First time — creates .neo/ in your project
d:\projects\neo\scripts\neo-init.ps1 -ProjectPath "d:\projects\sonny"

# First time + archive existing governance files
d:\projects\neo\scripts\neo-init.ps1 -ProjectPath "d:\projects\sonny" -ArchiveExisting

# Later — sync governance updates (preserves project data)
d:\projects\neo\scripts\neo-refresh.ps1 -ProjectPath "d:\projects\sonny"

# Preview what would change before syncing
d:\projects\neo\scripts\neo-refresh.ps1 -ProjectPath "d:\projects\sonny" -DryRun
```

### 2. Resulting structure

```
your-project/
  .neo/
    roles/          ← NEO-BECCA, NEO-ANT, NEO-GHOST, NEO-INSPECTOR
    shared/         ← NEO-ACTIVATION, NEO-GATES, NEO-EVIDENCE, NEO-OUTPUTS, NEO-TOOLS, NEO-HIVE, NEO-SURGICAL
    templates/      ← 13 templates (reports, packets, TODO, indexes, Operator Manual)
    prompts/        ← Specialized Ant prompts (Color Expert)
    scripts/        ← neo-init.ps1, neo-refresh.ps1 (self-update tools)
    inbox/          ← Task packets waiting for assignment
    outbox/
      ants/         ← Completed Ant reports
      ghost/        ← Ghost review verdicts
      inspector/    ← Inspector audit reports
    audit/
      evidence/     ← Evidence artifacts (diffs, test output, screenshots)
      reviews/      ← Archived reviews
      gate-logs/    ← Completed gate logs
    index/          ← Hive Mind indexes (MASTER_INDEX, FILE_OWNERSHIP, PHEROMONE)
    archive/        ← Completed TODOs from previous runs
    runtime/        ← Active task state
    STATE.md        ← Run counter + last task ID
    RUN_INDEX.md    ← BECCA's institutional memory (one entry per run)
    TODO_<PROJECT>.md  ← Active TODO (created by Scout)
    OPERATOR_MANUAL_<PROJECT>.md  ← Project-specific danger zones & safe ops (created by Scout)
```

### 3. Start a run

Tell BECCA what project to work on. She handles the rest:

```
You:   "deep dive into Sonny"
BECCA: RECON → checks state, reads history → dispatches Scout
You:   "I AM" → Scout surveys, creates TODO
You:   "I AM" → First Ant activates from TODO
...pipeline runs...
BECCA: VERIFY → regression check → CLOSE → archive + update index
```

---

## Four Roles

| Role | Does | Doesn't |
|------|------|---------|
| **BECCA** (Orchestrator) | RECON, Scout dispatch, continuity, VERIFY, CLOSE, run history | Write code, review reports, approve anything |
| **Ant** (Worker) | Reads code, plans changes, writes patches, runs tests, writes reports | Approve its own work, skip gates, merge code |
| **Ghost** (Reviewer) | 8-section structured review, evidence validation, pheromone audit | Fix code, write patches, execute tools |
| **Inspector** (Auditor) | Audits for drift/compliance/quality/NUCLEAR/SURGICAL, reports findings | Fix findings, approve its own recommendations |

---

## The "I AM" Protocol

Every role transition requires the operator to say **"I AM"**. This is the universal activation trigger.

- Only the **human** says "I AM"
- Only the **human** decides when
- No role activates itself or another role
- Silence does not equal "I AM" — roles wait until told

---

## Full Pipeline

```
BECCA RECON
    |  Reads STATE.md, RUN_INDEX.md, checks for incomplete runs
    |  Sets 🔒 PROJECT LOCK (all roles bound to this project)
    |
    v  "I AM"
SCOUT (Ant)
    |  Surveys project, creates TODO_<PROJECT>.md with tasks
    |
    v  "I AM"                          +------------------+
ANT (per task)                         |  REJECTION LOOP  |
    |  CHECKPOINT -> DISCOVERY ->      |                  |
    |  FOOTPRINT -> [BACKUP] ->        |  Ghost/Inspector |
    |  PATCH -> VERIFY -> REPORT       |  rejects -> back |
    |  (4-5 gates, each needs          |  to Ant (max 3)  |
    v  "I AM"                          +------------------+
GHOST (per task)
    |  8-section structured review
    |  Evidence score < 50% = AUTO REJECT
    |  NUCLEAR condition = AUTO REJECT
    |
    v  "I AM"
INSPECTOR (per task, optional)
    |  COMPLIANCE / DRIFT / QUALITY / NUCLEAR / PHEROMONE / SURGICAL audit
    |  BLOCKER findings = FAIL
    |
    v  ... repeat for each task in TODO ...
    |
    v  "I AM" (all tasks done)
BECCA VERIFY
    |  Regression check: did any Ant break a previous Ant's work?
    |
    v
BECCA CLOSE
    Archive TODO, update STATE.md, update RUN_INDEX.md, update Hive Mind indexes,
    update Operator Manual with new patterns/dangers
    RUN COMPLETE
```

---

## 14 Ant Types

Tasks are classified by risk. Risk level affects gate behavior and review requirements.

| Risk | Type | Use When |
|------|------|----------|
| HIGH | Fire Ant | Security fixes, auth changes, critical patches |
| HIGH | Financial Ant | Payment logic, billing, subscription changes |
| MEDIUM | Soldier Ant | Input validation, data integrity, edge cases |
| STANDARD | Carpenter Ant | New features, refactoring, structural changes |
| STANDARD | Toolbox Ant | Dependency updates, config changes, tooling |
| STANDARD | Harvester Ant | Data collection, analytics, logging |
| STANDARD | Debugger Ant | Diagnose only — never fix (TEST_REPORT output) |
| LOW | Analyst Ant | Research, analysis, recommendations |
| LOW | Flying Scout Ant | Survey project, create TODO, assess scope |
| LOW | Leafcutter Ant | Documentation, comments, naming cleanup |
| LOW | Board Ant | Architecture decisions, design reviews |
| LOW | Advisor Ant | Cross-team coordination, dependency alignment |
| HIGH | Color Expert Ant | Theme/CSS changes, color contrast, accessibility, dark/light mode |
| LOW | Support Ant | User-facing issues, support tickets, UX fixes |

---

## Gate Approval Guide

### Ant Gates (4–5 per task)

| Gate | What Happens | Approve With |
|------|-------------|--------------|
| **FOOTPRINT** | Ant presents plan (files, risk, data ops, rollback) | `FOOTPRINT APPROVED` |
| **BACKUP** | Ant shows backup proof *(conditional — data ops only)* | `BACKUP APPROVED` |
| **PATCH** | Ant shows actual code diffs | `PATCH APPROVED` |
| **VERIFY** | Ant shows test/build/lint results | `VERIFY APPROVED` |
| **REPORT** | Ant shows full ANT_REPORT | `REPORT APPROVED` |

### Review Gates

| Gate | What Happens | Approve With |
|------|-------------|--------------|
| **GHOST** | Ghost completes 8-section review | `GHOST APPROVED` |
| **INSPECTOR** | Inspector audits for compliance | `INSPECTOR PASS` |

### Rejection

At any gate: `REJECTED: <specific reason>` — Ant revises and re-presents.

---

## Ghost 8-Section Review

Every Ghost review has exactly 8 sections, always in order, never skipped:

| # | Section | Auto-Reject? |
|---|---------|-------------|
| 1 | **REVIEW HEADER** — task, Ant type, risk, paths | — |
| 2 | **REPORT COMPLETENESS** — 10 sections + snapshot sub-check | — |
| 3 | **DEFINITION OF DONE** — each criterion vs evidence | — |
| 4 | **EVIDENCE VALIDATION** — paths, claims, score | YES: < 50% |
| 5 | **COMPLIANCE CHECK** — Ant type, critical surfaces, gate log | — |
| 6 | **NUCLEAR & PHEROMONE AUDIT** — NUCLEAR check + violations | YES: any NUCLEAR / violation |
| 7 | **FINDINGS** — severity summary table | — |
| 8 | **VERDICT & HANDOFF** — decision + score card | — |

---

## Evidence Rules

Every claim must have proof. The pipeline rejects:

| Rejected Pattern | Example |
|-----------------|---------|
| Placeholder paths | `path/to/file.ts` |
| Generic text | "Tests were run and passed" |
| Missing line numbers | "Changed the function" (which line?) |
| Fabricated output | Test results not from actual execution |
| Unverifiable claims | "No regressions" without test evidence |

Evidence is scored on 5 dimensions (see `shared/NEO-EVIDENCE.md`):
- Path Validity (30%) — real files, real lines
- Specificity (25%) — exact locations, not vague references
- Completeness (20%) — all changes documented
- Verification (15%) — test/build output included
- No Placeholders (10%) — zero template text remaining

Minimum passing score: **70%** (Ghost auto-rejects below 50%)

---

## BECCA's Institutional Memory

Every completed run is recorded in `.neo/RUN_INDEX.md`. BECCA reads this during RECON to:
- Understand what was done before (avoid duplicate work)
- Spot recurring problem areas (suggest targeted Ants)
- Track deferred findings across runs
- Give the Scout context for better task planning

Task IDs are **global per project and never reset**:
```
Run 1: TASK-001, TASK-002, TASK-003
Run 2: TASK-004, TASK-005, TASK-006, TASK-007
Run 3: TASK-008
```

---

## Hive Mind (Shared Intelligence)

Every Ant works with full awareness of what came before. Three index types make this possible:

| Index | Purpose | Sharding |
|-------|---------|----------|
| **MASTER_INDEX** | One line per completed task (pipe-delimited, grep-searchable) | 500 entries per shard |
| **FILE_OWNERSHIP** | Per-file modification history (which tasks touched which files) | By directory prefix |
| **PHEROMONE_REGISTRY** | Active warnings by severity, with resolution tracking | 5 files (one per severity) |

### How it works

1. **Ant DISCOVERY** — Before reading code, the Ant checks all 3 indexes for target files. Active pheromones and high-traffic files are surfaced in a Hive Mind Briefing
2. **NUCLEAR STOP** — If a target file has an active NUCLEAR pheromone, the Ant STOPS and requests operator clearance
3. **Ant REPORT Section 10** — Hive context is recorded (previous tasks, active pheromones, hive risk per file)
4. **Ghost Section 5b** — Ghost validates the Ant's hive context claims against actual indexes
5. **BECCA CLOSE** — After all tasks complete, BECCA writes to all 3 indexes (single writer, atomic)
6. **BECCA RECON** — On next run, BECCA checks index health before dispatching Scout
7. **Inspector HIVE audit** — 8-point consistency check across all indexes

### Scale

| Scale | Index Files | Search Time |
|-------|------------|-------------|
| 100 ANTs | ~11 | < 1 grep |
| 1,000 ANTs | ~27 | < 2 greps |
| 10,000 ANTs | ~125 | < 3 greps |

Indexes live in `.neo/index/` and are preserved across governance refreshes.

---

## Surgical Change Protocol

Every code change follows 3 Laws that prevent assumption-based data destruction:

| Law | Name | Rule |
|-----|------|------|
| **LAW 1** | NO-GUESS | Prove you understand existing code BEFORE changing it |
| **LAW 2** | BACKUP | Backup data BEFORE any write/delete/migration/seed operation |
| **LAW 3** | SURGICAL | Minimum delta — PATCH default, no rebuilds, no unnecessary changes |

### Anti-Assumption Rules (FROZEN)

8 rules (A-01 → A-08) that prevent the #1 failure mode — agents destroying data they think is "broken":

| Rule | Name | Prevents |
|------|------|----------|
| A-01 | Never Assume Broken | Empty ≠ missing, placeholder ≠ bug |
| A-02 | Never Assume Stale | Timestamps may be intentional, caches may be warm |
| A-03 | Never Assume Unused | Dead code may be waiting for launch |
| A-04 | Never Assume Default | Values may be owner-configured |
| A-05 | Never Assume Test | Demo/test data may be production data |
| A-06 | Never Assume Schema | Missing fields may be optional by design |
| A-07 | Read Before Rename | Check Operator Manual before reporting something as "wrong" |
| A-08 | Verify Before Delete | Deletion requires proof that data is truly orphaned |

### Data Operation Classification

Every task's FOOTPRINT classifies its data operations:

| Operation | Gate Behavior |
|-----------|--------------|
| `CODE_ONLY` | Normal flow (no BACKUP gate) |
| `READ_ONLY` | Normal flow (no BACKUP gate) |
| `DATA_WRITE` | Triggers BACKUP gate + backup proof |
| `DATA_DELETE` | Triggers BACKUP gate + wipe protection |
| `MIGRATION` | Triggers BACKUP gate + dry-run |
| `SEED` | Triggers BACKUP gate + environment check |
| `CONFIG_WRITE` | Triggers BACKUP gate + rollback plan |

### Operator Manual

Each project gets a `.neo/OPERATOR_MANUAL_<PROJECT>.md` documenting:
- Critical data models (what MUST NOT be destroyed)
- Danger zones (scripts/endpoints that can wipe data)
- Safe operation patterns (PATCH vs PUT, merge vs replace)
- Red flags (patterns that should NEVER run on live data)
- Known intentional patterns (things that LOOK wrong but ARE correct)

Created by Scout on first BECCA run. Updated by BECCA during CLOSE.

---

## Project Isolation

Every run is locked to **one project**. No cross-project confusion.

### PROJECT LOCK (set by BECCA during RECON)
- BECCA declares the locked project root (absolute path) at the end of RECON
- All roles inherit the lock — every Ant, Ghost, and Inspector operates within that path
- Files outside the locked root are **V-10 violations** (automatic rejection)
- Read-only exceptions require `🔑 CROSS-PROJECT READ` token
- Cross-project **writes are NEVER allowed**
- Lock persists from RECON through CLOSE

### CHECKPOINT FIRST (every Ant, every time)
- Before reading code, before DISCOVERY, before anything
- Ant creates a git checkpoint: stash + record HEAD hash
- Presents **CHECKPOINT PROOF** to operator (hash, stash status, branch, project lock)
- No checkpoint = no work (S-26 STOP)
- If anything goes wrong, operator can restore to the checkpoint

### Scope Boundary (per task in TODO)
- Each task in the TODO has a **scope boundary** listing allowed files
- Ant MUST NOT touch files outside this list without operator approval (S-27 STOP)
- Prevents "while I'm here" scope creep into unrelated files

---

## Operator Commands

| Command | Effect |
|---------|--------|
| **I AM** | Activate the next role in the pipeline |
| **SKIP INSPECTOR** | Skip Inspector for current task (Ghost to next Ant) |
| **SKIP GHOST** | Skip Ghost for current task (Ant to Inspector) |
| **PAUSE** | Pause current task, resume later |
| **ABORT** | Stop the entire run |

---

## Updating Governance

When you update NEO source files (`d:\projects\neo\`), push changes to all projects:

```powershell
# Preview changes
.neo\scripts\neo-refresh.ps1 -ProjectPath "d:\projects\sonny" -DryRun

# Apply changes (preserves all project data)
.neo\scripts\neo-refresh.ps1 -ProjectPath "d:\projects\sonny"
```

The refresh script:
- Syncs roles/, shared/, templates/, prompts/, scripts/ (hash-based, only changed files)
- Creates missing directories from newer NEO versions
- Migrates legacy NEO_STATE.json to STATE.md if found
- Preserves: inbox, outbox, audit, archive, runtime, index, STATE.md, RUN_INDEX.md, TODO, CRITICAL_SURFACES.md, OPERATOR_MANUAL
- Seeds hive mind index files on v2.1 upgrade (if missing)

---

## File Manifest

### Roles (4)
| File | Version | Role |
|------|---------|------|
| `NEO-BECCA.md` | v1.7.0 | Orchestrator (index writes + health check + Operator Manual + feedback aggregation + PROJECT LOCK) |
| `NEO-ANT.md` | v1.9.0 | Worker (14 Ant Types, Hive Mind Check, BACKUP gate, Color Expert LAB, CHECKPOINT FIRST, PROJECT LOCK validation) |
| `NEO-GHOST.md` | v1.8.0 | Reviewer (8-section output + hive + surgical + prompt feedback validation) |
| `NEO-INSPECTOR.md` | v1.4.0 | Auditor (7 inspection types incl. HIVE + SURGICAL) |

### Shared Modules (7)
| File | Version | Purpose |
|------|---------|---------|
| `NEO-ACTIVATION.md` | v1.4.0 | "I AM" protocol, TODO coordination, BECCA bookends, PROJECT LOCK binding |
| `NEO-GATES.md` | v1.5.0 | State machine, approval tokens, BACKUP gate, LAB state, STOP rules, violations, V-10 PROJECT LOCK |
| `NEO-EVIDENCE.md` | v1.3.0 | Evidence doctrine, pheromones, surgical protocol evidence |
| `NEO-OUTPUTS.md` | v1.8.0 | Output contracts per role (incl. hive context + surgical + Color Expert) |
| `NEO-TOOLS.md` | v1.1.0 | Tool permissions, critical surfaces |
| `NEO-HIVE.md` | v1.0.0 | Hive Mind indexes, sharding, read/write contracts |
| `NEO-SURGICAL.md` | v1.1.0 | 3 Laws, anti-assumption rules, backup gate, data ops, Operator Manual, CHECKPOINT FIRST, PROJECT ISOLATION |

### Prompts (1)
| File | Purpose |
|------|---------|
| `COLOR_EXPERT_ANT.md` | Specialized prompt for 🎨 Color Expert Ant (LAB workflow, CSS safety, WCAG compliance) |

*Specialized prompts extend the base NEO-ANT role with domain-specific context. Loaded alongside NEO-ANT.md when that Ant type activates.*

### Templates (13)
| File | Purpose |
|------|---------|
| `ANT_REPORT.md` | Ant's 13-section report + header (incl. Hive Context, Backup Proof, Lessons, Prompt Feedback) |
| `GHOST_REVIEW.md` | Ghost's 8-section structured review (incl. Hive + Surgical Compliance) |
| `INSPECTOR_REPORT.md` | Inspector's findings + verdict |
| `TASK_PACKET.md` | Task request form (input to Ant) |
| `PROJECT_TODO.md` | Active TODO template |
| `RUN_INDEX.md` | BECCA's institutional memory template |
| `TEST_REPORT.md` | Debugger Ant's diagnosis output |
| `GATE_LOG.md` | Approval token trail (incl. BACKUP gate) |
| `CRITICAL_SURFACES.md` | Project-specific critical files template |
| `MASTER_INDEX.md` | Hive Mind task registry template |
| `FILE_OWNERSHIP.md` | Hive Mind per-file history template |
| `PHEROMONE_REGISTRY.md` | Hive Mind active warnings template |
| `OPERATOR_MANUAL.md` | Project-specific danger zones, safe ops, red flags |

### Scripts (2)
| File | Purpose |
|------|---------|
| `neo-init.ps1` | First-time deployment to a project |
| `neo-refresh.ps1` | Sync governance updates to a project |
