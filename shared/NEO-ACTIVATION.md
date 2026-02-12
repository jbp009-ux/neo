# NEO-ACTIVATION v1.4.0
## The "I AM" Protocol — Role Activation, Handoff & Tactical TODO Coordination

**Version:** 1.4.0
**Date:** 2026-02-11
**Purpose:** Defines how roles activate, hand off, and coordinate through a shared TODO document
**Mode:** MANUAL ONLY — Every role transition requires human "I AM" trigger. NO AUTOMATION.

---

## 1. The "I AM" Protocol

```
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║   "I AM" — The Universal Role Activation Trigger                            ║
║                                                                              ║
║   When the operator says "I AM", the next role in the pipeline activates.   ║
║   No role may self-activate. No role may activate another role.             ║
║   Only the human says "I AM". Only the human decides when.                  ║
║                                                                              ║
║   "I AM" is a GATE. Silence is not "I AM". Shortcuts are not "I AM".        ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
```

### What "I AM" Does

| Step | Action |
|------|--------|
| 1 | Current role finishes and suggests the next role |
| 2 | Operator says **"I AM"** |
| 3 | Next role activates: reads its prompt file, then reads the TODO |
| 4 | Role identifies current task from TODO and begins work |
| 5 | Role works, updates TODO with progress and artifact paths |
| 6 | Role finishes and suggests next role → back to step 2 |

### What "I AM" Does NOT Do

- Does NOT mean "yes" or "approved" — it specifically means "activate the next role"
- Does NOT skip gates — gate tokens (🔑) are still required within each role's work
- Does NOT auto-chain — each transition requires a separate "I AM"
- Does NOT work retroactively — you can't say "I AM" to redo a completed stage

### Project Binding (FROZEN)

```
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║   🔒 PROJECT LOCK — Every Role Is Bound to One Project                      ║
║                                                                              ║
║   BECCA declares PROJECT LOCK during RECON. From that point:                ║
║   • Every role activated via "I AM" inherits the locked project root        ║
║   • The Ant MUST verify its TODO matches the locked project                 ║
║   • Ghost and Inspector operate ONLY on artifacts from that project         ║
║   • No role may read or write files outside the locked root (V-10)          ║
║                                                                              ║
║   "I AM" activates a role WITHIN the locked project.                        ║
║   It does NOT change the project. It does NOT unlock new projects.          ║
║                                                                              ║
║   The lock persists from BECCA RECON through BECCA CLOSE.                   ║
║   Only a new "deep dive into <project>" creates a new lock.                 ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
```

---

## 2. The Tactical TODO

### What It Is

A single markdown file per project that serves as:
- **Task queue** — ordered list of work to do
- **Pipeline tracker** — shows each task's progress through Ant → Ghost → Inspector
- **Artifact registry** — links to every report, review, and inspection
- **Activation log** — audit trail of every role transition
- **Archival manifest** — when complete, contains everything needed to archive the run

### Naming Convention

```
TODO_<PROJECT>.md

Examples:
  TODO_SONNY.md
  TODO_TRAINER.md
  TODO_BECCAOS.md
```

### Where It Lives

```
<PROJECT_ROOT>/.neo/TODO_<PROJECT>.md
```

Example: `d:\projects\sonny\.neo\TODO_SONNY.md`

### Who Reads and Writes

| Role | Reads TODO | Writes TODO |
|------|-----------|-------------|
| BECCA | YES — checks state, dispatches Scout | YES — Scout creates it |
| Operator | YES — reviews it | YES — approves/modifies tasks |
| Ant | YES — finds current task | YES — marks progress, adds report path |
| Ghost | YES — finds Ant's report path | YES — marks progress, adds review path |
| Inspector | YES — finds both paths | YES — marks progress, adds inspection path |

---

## 3. Pipeline Flow

### Normal Flow (Happy Path)

```
              "deep dive"        "I AM"         "I AM"           "I AM"            "I AM"
Operator ────→ 👑 BECCA ───────→ 🚁 Scout ────→ 🐜 Ant ────────→ 👻 Ghost ────────→ 🔍 Inspector
               RECON              creates TODO   works task #1    reviews task #1   audits task #1
               checks state       fills tasks    updates TODO     updates TODO      updates TODO
                                                                                        │
                                                                          "I AM" ←──────┘
                                                                            ↓
                                                                      🐜 Ant (task #2)
                                                                          ...
```

### Step-by-Step

**0. Operator says "deep dive into <project>" → BECCA activates**
- BECCA does RECON: checks `.neo/STATE.md`, prior TODOs, last task ID
- Archives any completed-but-not-archived TODOs
- Flags incomplete prior runs
- BECCA says: **"RECON complete. Activate Scout? → I AM"**

**0b. Operator says "I AM" → Scout activates**
- Scout (🚁 Flying Scout Ant) surveys the project codebase
- Scout creates `TODO_<PROJECT>.md` with task list, sequential IDs
- Scout says: **"TODO created. First task: <task>. Activate Ant? → I AM"**

**1. Operator says "I AM" → Ant activates (task #1)**
- Ant reads `roles/NEO-ANT.md` (its prompt)
- Ant reads the TODO → finds task #1 (first ⬜ QUEUED task)
- Ant works through: DISCOVERY → FOOTPRINT → PATCH → VERIFY → REPORT
- Ant updates TODO: marks Ant stage ✅, adds report path
- Ant says: **"Ant complete. Report at `<path>`. Activate Ghost? → I AM"**

**3. Operator says "I AM" → Ghost activates**
- Ghost reads `roles/NEO-GHOST.md` (its prompt)
- Ghost reads the TODO → finds task #1, reads Ant's report path
- Ghost reviews the Ant report
- Ghost updates TODO: marks Ghost stage (✅ or ❌), adds review path
- Ghost says: **"Ghost [APPROVED/REJECTED]. Review at `<path>`. Activate Inspector? → I AM"**

**4. Operator says "I AM" → Inspector activates**
- Inspector reads `roles/NEO-INSPECTOR.md` (its prompt)
- Inspector reads the TODO → finds task #1, reads both paths
- Inspector audits (COMPLIANCE inspection by default)
- Inspector updates TODO: marks Inspector stage (✅ or ❌), adds report path
- Inspector says: **"Inspector [PASS/FAIL]. Report at `<path>`. Next task? → I AM"**

**5. Operator says "I AM" → Ant activates (task #2)**
- Cycle repeats for next ⬜ QUEUED task

**6. When all tasks are done → BECCA reactivates**
- Inspector says: **"All tasks complete. Activate BECCA for final verification? → I AM"**
- Operator says "I AM" → BECCA reactivates for VERIFY + CLOSE (see Section 6)

---

## 4. Rejection Loops

### Ghost REJECTS → Back to Ant

```
                         "I AM"                    "I AM"
Ghost (❌ REJECTED) ────→ Operator ─────────────→ 🐜 Ant (same task)
  adds deficiency list    reads deficiency list     fixes issues
  marks Ghost ❌           decides to send back      re-runs pipeline
```

- Ghost marks its stage ❌ REJECTED in TODO
- Ghost lists deficiencies in TODO notes
- Ghost says: **"Ghost REJECTED. Deficiencies: `<list>`. Send back to Ant? → I AM"**
- Operator says "I AM" → Ant re-activates for same task
- Ant reads Ghost's deficiency list from TODO, fixes, re-submits
- Pipeline continues: Ant → Ghost → Inspector (same task, new attempt)

### Inspector FAILS → Back to Ant

Same pattern as Ghost rejection:
- Inspector marks its stage ❌ FAIL
- Inspector lists blockers
- Inspector says: **"Inspector FAIL. Blockers: `<list>`. Send back to Ant? → I AM"**
- Operator says "I AM" → Ant re-activates

### Loop Tracking

Each rejection adds a **loop counter** to the task in the TODO:

```markdown
**Loops:** 0 → 1 (Ghost rejected: missing tests) → 2 (Inspector fail: NUCLEAR finding)
```

After **3 loops** on the same task, the role MUST flag it:
**"⚠️ Task <ID> has looped 3 times. Operator review recommended before continuing."**

---

## 5. Same-Chat Rules

```
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║   ALL ROLES WORK IN THE SAME CHAT SESSION.                                  ║
║                                                                              ║
║   When "I AM" triggers a new role, the LLM reads that role's prompt file    ║
║   to adopt its identity, rules, and checklist. The chat history provides    ║
║   full context of what the previous role did.                                ║
║                                                                              ║
║   RULES:                                                                     ║
║   1. One role active at a time — never two roles simultaneously             ║
║   2. The active role presents its activation response first                  ║
║   3. The active role reads the TODO to find its task                         ║
║   4. When a role finishes, it suggests the next role but does NOT            ║
║      activate it — only "I AM" from the operator does that                   ║
║   5. A role that has finished MUST NOT continue working if the               ║
║      operator starts a different conversation                                ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
```

### Cross-Session Continuity

If a chat session ends mid-run:
1. The TODO persists on disk (it's a file)
2. New session starts → operator says "I AM"
3. Role reads the TODO → sees where the pipeline left off
4. Work continues from the last incomplete stage

The TODO is the **single source of truth** for pipeline state. Not the chat history.

---

## 6. BECCA Final Verification & Archival

### Everything Starts and Ends with BECCA

```
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║   BECCA starts the run (RECON → SCOUT → HANDOFF)                            ║
║   The pipeline executes (Ant → Ghost → Inspector, per task)                 ║
║   BECCA ends the run (VERIFY → CLOSE)                                       ║
║                                                                              ║
║   No run is complete until BECCA signs off.                                  ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
```

### When to Reactivate BECCA

After the last Inspector completes the last task, BECCA reactivates to:

1. **VERIFY** — Confirm no Ant broke something from a previous Ant's work
2. **CLOSE** — Archive the TODO and update STATE.md

### BECCA VERIFY Protocol

```
1. Read ALL Ant reports from this run
2. Check: did any later Ant revert or break a previous Ant's fix?
   → If Ant #3 modified a file that Ant #1 fixed, verify the fix still holds
3. Check: did the project build/tests pass after the LAST Ant's work?
4. Check: are there any unresolved ⚫ NUCLEAR or ❌ REJECTED findings?
5. Check: all tasks in TODO show ✅ across all three stages?

VERDICT:
  ✅ VERIFIED — System is complete and consistent
  ❌ REGRESSION — Ant <N> broke Ant <M>'s work → list specifics
  ❌ INCOMPLETE — Unresolved findings remain
```

If REGRESSION found: BECCA flags the specific issue and asks operator whether to dispatch a fix Ant.

### BECCA CLOSE Protocol

After VERIFY passes:

1. Mark TODO: `**Status:** ✅ COMPLETE`
2. Add completion timestamp
3. Move TODO to archive:

```
FROM: <PROJECT>/.neo/TODO_<PROJECT>.md
TO:   <PROJECT>/.neo/archive/TODO_<PROJECT>_<run_number>.md
```

4. Update `.neo/STATE.md` with last run + last task ID
5. Update `.neo/RUN_INDEX.md` — append run summary with:
   - Run number, date, task count, task ID range
   - Brief summary of what was accomplished (1-3 sentences)
   - Key outcomes (bullet list)
   - Archive location of the completed TODO
   - Update QUICK STATS (total runs, total tasks, ID range, last run date)
   - (Optional) Add cross-run observations to NOTES if patterns emerge
6. All artifact files stay in their original locations
7. The archived TODO serves as the manifest; RUN_INDEX serves as the directory

### Archive Naming

```
TODO_SONNY_001.md    ← first run
TODO_SONNY_002.md    ← second run
TODO_SONNY_003.md    ← third run
```

### BECCA CLOSE Output

```
👑 BECCA — Run <N> VERIFIED and CLOSED.

Verification: ✅ No regressions. All tasks consistent.
TODO archived: .neo/archive/TODO_<PROJECT>_<N>.md
Run index updated: .neo/RUN_INDEX.md
Tasks completed: <count>
Task ID range: TASK-<first> to TASK-<last>

Project ready for next run.
```

---

## 7. Role Activation Responses (TODO-Aware)

When a role activates via "I AM", it follows this sequence:

### BECCA Activation
```
NEO_STATE: RECON

👑 BECCA activated.

I see the beginning and the end.
I organize the team. I do NOT execute the work.

Target project: <PROJECT>
🔒 PROJECT LOCK will be set after RECON.
Running RECON...
```

### Ant Activation
```
NEO_STATE: CHECKPOINT

🐜 ANT activated.

I am the Ant. Surgical execution with evidence.
Manual gates at every step. No auto-approvals.

🔒 PROJECT LOCK: <PROJECT> (root: <path>)
Reading TODO...
Current task: <TASK_ID> — <emoji> <Ant Type>
Objective: <objective from TODO>
Scope: <target files from TODO>

Creating CHECKPOINT before any work...
```

### Ghost Activation
```
NEO_STATE: REVIEW

👻 GHOST activated.

I am the Ghost. I validate evidence and enforce quality.
No claims without proof. No approval without verification.

Reading TODO...
Current task: <TASK_ID> — reviewing Ant report
Report path: <path from TODO>

Beginning REVIEW.
```

### Inspector Activation
```
NEO_STATE: INSPECT

🔍 INSPECTOR activated.

I am the Inspector. I audit for compliance and drift.
I report findings. I do NOT fix them.

Reading TODO...
Current task: <TASK_ID> — auditing task
Ant report: <path from TODO>
Ghost review: <path from TODO>

Beginning INSPECTION (COMPLIANCE).
```

---

## 8. TODO Update Rules

### What Each Role Updates

| Role | Updates in TODO |
|------|----------------|
| Ant | Marks task status → 🐜 ANT | Marks Ant stage 🔄 IN PROGRESS → ✅ DONE | Adds report path |
| Ghost | Marks task status → 👻 GHOST | Marks Ghost stage 🔄 → ✅/❌ | Adds review path + verdict |
| Inspector | Marks task status → 🔍 INSPECTOR | Marks Inspector stage 🔄 → ✅/❌ | Adds report path + verdict |

### Status Icons

| Icon | Meaning |
|------|---------|
| ⬜ | QUEUED — not started |
| 🔄 | IN PROGRESS — role is working |
| ✅ | DONE — stage passed |
| ❌ | REJECTED / FAILED — needs redo |
| ⏸️ | PAUSED — operator halted |

### Rules

1. Only the active role may write to the TODO
2. A role marks its stage ✅ only when genuinely complete (report written, review done, inspection done)
3. Rejection marks the stage ❌ and adds a note explaining why
4. The TODO is updated AFTER the role shows its output in chat (chat first, file second)

---

## 9. Task ID Continuity

```
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║   TASK IDs ARE GLOBAL PER PROJECT — THEY NEVER RESET.                       ║
║                                                                              ║
║   Run 001: TASK-001, TASK-002, TASK-003                                     ║
║   Run 002: TASK-004, TASK-005, TASK-006, TASK-007                           ║
║   Run 003: TASK-008, TASK-009                                                ║
║                                                                              ║
║   BECCA determines the next ID during RECON by reading .neo/STATE.md        ║
║   Fallback: scan .neo/outbox/ants/ for highest ANT_REPORT_TASK-NNN.md       ║
║                                                                              ║
║   Task IDs are NEVER reused. NEVER reset. NEVER skipped.                    ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
```

### .neo/STATE.md Format

```markdown
# NEO STATE: <PROJECT>

**Last Run:** <N>
**Last Task ID:** TASK-<NNN>
**Last Pheromone ID:** PH-<NNN>
**Status:** COMPLETE / IN PROGRESS / INITIALIZED
```

BECCA creates STATE.md on first run. Updates it on every CLOSE.

### .neo/RUN_INDEX.md — Institutional Memory

```markdown
# RUN INDEX: <PROJECT>

## COMPLETED RUNS

### Run 001 — <date>
| Tasks | Task IDs | Archive | Verdict |
| <count> | TASK-<first> → TASK-<last> | .neo/archive/TODO_<PROJECT>_001.md | ✅ VERIFIED |
**Summary:** <what was done>

### Run 002 — <date>
...

## QUICK STATS
| Total Runs | Total Tasks | Task ID Range | First Run | Last Run |

## NOTES
<!-- Cross-run observations, recurring patterns, deferred findings -->
```

BECCA creates RUN_INDEX.md on first run. Appends to it on every CLOSE. Reads it during RECON.

---

## 10. Operator Commands

Beyond "I AM", the operator can say:

| Command | Effect |
|---------|--------|
| **I AM** | Activate the next role in pipeline |
| **SKIP INSPECTOR** | Skip Inspector for this task (Ant + Ghost sufficient) |
| **SKIP GHOST** | Skip Ghost for this task (rare — operator takes responsibility) |
| **PAUSE** | Halt current role, resume later |
| **ABORT <TASK_ID>** | Cancel a specific task (mark ⏸️ in TODO) |
| **ABORT ALL** | Cancel entire TODO run |

All commands are manual. The role MUST acknowledge the command before acting on it.

---

## 11. Quick Reference

```
┌─────────────────────────────────────────────────────────────────┐
│  NEO-ACTIVATION v1.4.0 — QUICK REFERENCE                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  EVERYTHING STARTS AND ENDS WITH BECCA.                          │
│                                                                  │
│  FULL RUN:                                                       │
│  👑 BECCA (RECON) → 🚁 Scout (TODO) → 🐜 Ant → 👻 Ghost →     │
│  🔍 Inspector → ... → 👑 BECCA (VERIFY + CLOSE)                 │
│                                                                  │
│  "I AM" = Operator activates next role. Only human says it.      │
│                                                                  │
│  TODO = Single file per project. All roles read + write it.      │
│  STATE = .neo/STATE.md tracks run counter + last task ID.        │
│  INDEX = .neo/RUN_INDEX.md — BECCA's institutional memory.       │
│  HIVE  = .neo/index/ — MASTER_INDEX + FILE_OWNERSHIP + PHEROMONE│
│  Task IDs NEVER reset — they're global per project.              │
│                                                                  │
│  PIPELINE PER TASK:                                              │
│  "I AM" → 🐜 Ant → "I AM" → 👻 Ghost → "I AM" → 🔍 Inspector  │
│                                                                  │
│  REJECTION: Ghost ❌ or Inspector ❌ → "I AM" → back to Ant      │
│  MAX LOOPS: 3 per task, then flag for operator review            │
│                                                                  │
│  BECCA VERIFY (end of run):                                      │
│  • Did any Ant break a previous Ant's work? → REGRESSION         │
│  • All tasks ✅? No unresolved findings? → CLOSE + archive       │
│  • CLOSE updates: STATE.md + RUN_INDEX.md + HIVE indexes + TODO  │
│                                                                  │
│  OPERATOR COMMANDS:                                              │
│  I AM | SKIP INSPECTOR | SKIP GHOST | PAUSE | ABORT             │
│                                                                  │
│  🔒 PROJECT LOCK:                                                │
│  BECCA sets lock during RECON — all roles inherit it             │
│  Every "I AM" activates within the locked project                │
│  V-10 = file outside locked root → auto-reject                   │
│                                                                  │
│  ⛑️ CHECKPOINT FIRST:                                            │
│  Ant creates git checkpoint BEFORE any work (CHECKPOINT state)   │
│  No checkpoint = no work. S-26 STOP if missing.                  │
│                                                                  │
│  CARDINAL RULE: Only "I AM" transitions roles.                   │
│  No self-activation. No auto-chaining. No shortcuts.             │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Changelog

### [1.4.0] 2026-02-11
- PROJECT LOCK binding (FROZEN): every role activated via "I AM" inherits the locked project root
- Lock set by BECCA during RECON, persists through CLOSE, only new "deep dive" creates new lock
- Ant activation response: now shows CHECKPOINT state, PROJECT LOCK, and scope
- BECCA activation response: now mentions PROJECT LOCK will be set after RECON
- Quick Reference: PROJECT LOCK + CHECKPOINT FIRST sections added
- Cross-reference: V-10 (project lock violation) in NEO-GATES.md v1.5.0
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.3.0] 2026-02-10
- Hive Mind: .neo/index/ directory added to project file paths
- STATE.md: now tracks Last Pheromone ID (PH-NNN)
- BECCA CLOSE: now updates HIVE indexes alongside STATE.md and RUN_INDEX.md
- Quick Reference: HIVE line added, CLOSE updates list updated
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.2.0] 2026-02-09
- RUN_INDEX.md: BECCA's institutional memory — one entry per completed run
- BECCA CLOSE protocol: step 5 appends run summary to RUN_INDEX.md
- BECCA CLOSE output: mentions "Run index updated"
- Section 9: added .neo/RUN_INDEX.md format alongside STATE.md
- Quick Reference: added INDEX line + CLOSE updates list
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.1.0] 2026-02-09
- BECCA orchestration: everything starts and ends with BECCA
- BECCA RECON: checks .neo/STATE.md, prior TODOs, last task ID, run counter
- BECCA SCOUT dispatch: "I AM" → 🚁 Scout surveys project → creates TODO
- BECCA VERIFY: final regression check — did any Ant break previous Ant's work?
- BECCA CLOSE: archives TODO, updates STATE.md, signs off on run
- Task ID continuity: global per project, never reset, tracked in STATE.md
- .neo/STATE.md format: last run, last task ID, status
- Updated pipeline flow diagram to show BECCA at both ends
- BECCA activation response added to Section 7
- Updated Quick Reference with full BECCA-bookended flow
- ALL transitions are MANUAL ONLY — NO AUTOMATION

### [1.0.0] 2026-02-09
- Initial release
- "I AM" protocol: universal role activation trigger
- Tactical TODO: shared coordination document per project
- Pipeline flow: Ant → Ghost → Inspector per task
- Rejection loops: Ghost/Inspector reject → back to Ant (max 3 loops)
- Same-chat rules: one role at a time, TODO is single source of truth
- Cross-session continuity: TODO persists, new session reads where left off
- Archival protocol: all tasks done → move TODO to archive/
- TODO update rules: status icons, who writes what, chat-first/file-second
- Operator commands: I AM, SKIP INSPECTOR, SKIP GHOST, PAUSE, ABORT
- Inspired by IAMBecca ACTIVATION (packets), QUEUE (distribution), LEDGER (logging)
- ALL transitions are MANUAL ONLY — NO AUTOMATION
