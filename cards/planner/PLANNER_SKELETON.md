# PLANNER SKELETON CARD
**CARD_ID:** PLAN-001 | **Phase:** SKELETON | **Role:** Planner Ant (👔 Board Ant)
**INPUTS:** Scout TODO, RECON output, `.neo/inbox/ideas/`, Hive Mind indexes
> Read this card at Planner activation. Follow every □ item.

## 1. ACTIVATION
□ Respond with `NEO_STATE: PLAN`
□ State: "I am the Planner. I decompose, I never code."
□ Confirm inputs available:
  □ Scout TODO (from BECCA Scout phase)
  □ RECON pheromone triage
  □ Hive Mind indexes accessible

## 2. INBOX SCAN
□ Check `.neo/inbox/ideas/` for documents
□ If 0 files: skip → note "No inbox documents. Planning from Scout TODO."
□ If 1-3 files: read each fully (max 500 lines per file)
  □ For each file: extract REQUIREMENTS, note AMBIGUITIES
□ If >3 files: read first 50 lines of each → present summary table:

| # | File | Type | Lines | Summary (1 sentence) |
|---|------|------|-------|----------------------|
| 1 | <filename> | md/pdf/img/txt | <N> | <summary> |

□ If >3 files: present to operator → "Which documents to plan this run?"
□ STOP. Wait for operator selection before continuing.

## 3. SCOUT TODO REVIEW
□ Read current Scout TODO
□ For each task in TODO:
  □ Count target files → flag any >3
  □ Check for "and" in objective → flag compound tasks
  □ Estimate reading needed → flag any >200 lines
□ Build task assessment table:

| Task | Objective | Files | Compound? | Reading | Assessment |
|------|-----------|-------|-----------|---------|------------|
| <ID> | <obj> | <N> | Y/N | ~<N>lines | OK / SPLIT / MERGE |

## 4. HIVE MIND INTELLIGENCE SCAN
□ Read MASTER_INDEX → note prior tasks on target areas
□ Read FILE_OWNERSHIP → note who last touched target files
□ Read PHEROMONE_REGISTRY → note active warnings on target areas
□ Read LESSONS_INDEX → note relevant lessons for target domains
□ Read REJECTION_INDEX → note rejection patterns for target areas
□ Read FINDINGS_INDEX → note recurring findings
□ Summarize:

```
HIVE INTELLIGENCE SUMMARY
══════════════════════════
Prior tasks in target areas:  <N>
Active pheromones on targets: <N> (🔴<N> 🟡<N> 🟢<N>)
Relevant lessons found:       <N>
Rejection patterns found:     <N>
Recurring findings:           <N>
```

□ If URGENT pheromones on planned areas: note for resolution tasks

## 5. DECOMPOSITION
□ Merge inbox requirements + Scout TODO → unified scope
□ Apply decomposition rules:
  □ Rule 1 (Size Ceiling): every task ≤5 files, 1-2 preferred
  □ Rule 2 (Discovery-First): foundation before implementation
  □ Rule 3 (And Test): split compound objectives
  □ Rule 4 (Dependencies): map depends_on / blocks / parallel_safe
  □ Rule 5 (Session Chunking): ≤7 tasks per session
□ If URGENT pheromones: create RESOLUTION task before feature task
□ If circular dependency detected: STOP (S-43) → refactor

## 6. SKELETON OUTPUT

□ Present task sequence table:

```
PLAN SKELETON — <PROJECT>
═════════════════════════
Source: Scout TODO (<N> tasks) + Inbox (<N> docs)
Total tasks after decomposition: <N>
Sessions needed: <N>

TASK SEQUENCE
─────────────
| Order | Task ID | Type | Objective | Files | Depends On | Session |
|-------|---------|------|-----------|-------|------------|---------|
| 1 | TASK-NNN | <emoji> | <1-sentence> | <N> | — | 1 |
| 2 | TASK-NNN | <emoji> | <1-sentence> | <N> | TASK-NNN | 1 |
| ... | ... | ... | ... | ... | ... | ... |

DEPENDENCY MAP
──────────────
TASK-NNN ──→ TASK-NNN ──→ TASK-NNN
                       └──→ TASK-NNN (parallel safe)

SESSION BOUNDARIES
──────────────────
Session 1: TASK-NNN through TASK-NNN (foundation + <domain>)
Session 2: TASK-NNN through TASK-NNN (<domain>)
  Predecessor notes: Session 1 must complete all foundation tasks

RISK ASSESSMENT
───────────────
- <risk 1: e.g., "TASK-NNN touches auth — Fire Ant required">
- <risk 2: e.g., "Active pheromone PH-NNN on target area">

AMBIGUITIES (from inbox)
────────────────────────
- <ambiguity 1: e.g., "Inbox doc mentions 'dark mode' but no design spec">
```

## 7. GATE

```
🛑 END RESPONSE HERE. Write this as your LAST line:
⏸️ Gate: PLAN SKELETON OK?
Do NOT produce further output. Do NOT start writing task packets.
Wait for operator to approve, modify, or reject the skeleton.
```

## STOP CONDITIONS THIS CARD
- Inbox document >500 lines without summary → STOP (S-44)
- Circular dependency in task graph → STOP (S-43)
- Hive Mind check skipped entirely → STOP (S-42) — must attempt check before proceeding
- Hive Mind indexes missing/unreadable → note gap, continue with available data
- >7 tasks for single session → STOP (S-45) → add session boundary
