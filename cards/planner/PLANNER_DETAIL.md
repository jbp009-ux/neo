# PLANNER DETAIL CARD
**CARD_ID:** PLAN-002 | **Phase:** DETAIL | **Role:** Planner Ant (👔 Board Ant)
**INPUTS:** Approved SKELETON, Hive Mind indexes, code access (read-only)
> Read this card after SKELETON is approved. Follow every □ item.

## 1. BATCH PREPARATION
□ Take approved skeleton task sequence
□ Group tasks into batches of 3-5 tasks each
□ First batch = first 3-5 tasks in sequence order
□ Record: total batches = ceil(total_tasks / 4)

## 2. PER-TASK ENRICHMENT (repeat for each task in current batch)

For each task in the current batch:

### 2a. TARGET FILE VALIDATION
□ Read target files (or first 50 lines if >200 lines)
□ Confirm files exist and match the objective
□ If file doesn't exist and task creates it: note as NEW FILE
□ If file has moved or been renamed: update target path
□ Final target file count ≤5 → if >5: SPLIT (S-41)

### 2b. HIVE CONTEXT ENRICHMENT
□ Query FILE_OWNERSHIP for each target file:

| File | Last Task | Last Ant Type | Last Change | Pheromones |
|------|-----------|---------------|-------------|------------|
| <path> | TASK-NNN | <emoji> <type> | <date> | <PH-NNN or NONE> |

□ Query PHEROMONE_REGISTRY for active pheromones on target files:

| PH-ID | Severity | Category | Target | Message | Age |
|-------|----------|----------|--------|---------|-----|
| PH-NNN | <emoji> | <cat> | <file:line> | <msg> | <N days> |

□ Score LESSONS_INDEX for this task (use BECCA scoring function):
  - File overlap: +8 per matching file
  - Ant type match: +5
  - GOTCHA/FRAGILE category: +4
  - Domain match: +3
  - Recency (last 5 runs): +2
  - Hit rate >80%: +3 / Hit rate <30%: -5
□ Select top 3 lessons by score

| Rank | L-ID | Score | Category | Lesson Summary |
|------|------|-------|----------|----------------|
| 1 | L-NNN | <score> | <cat> | <summary> |

□ Query REJECTION_INDEX for patterns on target files/Ant type:

| Pattern | Occurrences | Last Seen | Rule | Stage |
|---------|-------------|-----------|------|-------|
| <cat> | <N> | Run <N> | <S-NN/V-NN> | <stage> |

### 2c. CARD DECK GENERATION
□ Determine Ant type from task domain
□ Build CARD DECK using `cards/CARD_GPS_MAP.md`:
  - CORE cards (always: CORE-001 through CORE-005)
  - TASK cards (standard 7 Ant cards, or specialized if Debugger/Color/Figma/QA)
  - TOOL cards (from project Operator Manual)
□ Set DECK_ID: `DECK-<TASK_ID>`

### 2d. DEPENDENCY CHAIN
□ List which prior tasks must complete before this one
□ List which later tasks depend on this one
□ Note any outputs from prior tasks this Ant needs (file paths, decisions)
□ If prior task creates a file this task modifies: add explicit note

### 2e. OPERATOR MANUAL SCAN
□ Read the project's Operator Manual (`.neo/OPERATOR_MANUAL.md`)
□ Search for sections mentioning any target file path
□ Search for sections mentioning the task domain (auth, payments, UI, data, etc.)
□ Extract ONLY the warnings/alerts that apply to THIS task's target files
□ If no relevant alerts: record "No Operator Manual alerts for this task's target files."

### 2f. PRIOR WORK EXTRACTION
□ Query FILE_OWNERSHIP + MASTER_INDEX for each target file:
  - What was the last task that touched this file?
  - What Ant type did it? What changes were made?
  - Was the task APPROVED or REJECTED by Ghost?
□ Record 1-row summary per file:

| File | Last Task | Run | Ant Type | What Was Done | Outcome |
|------|-----------|-----|----------|---------------|---------|
| <path> | TASK-NNN | Run <N> | <emoji> <type> | <1-sentence> | <APPROVED/REJECTED> |

□ If no prior work: "No prior tasks touched these files — first work in this area."

### 2g. BUILD ANT MISSION BRIEF
> **The Ant already has its cards and protocol. You just give it the intel.** Don't re-teach the pipeline — the cards do that. Your job: point the Ant at the right targets.

□ Fill the TASK_PACKET's ANT MISSION BRIEF section:
  - **READ FIRST:** List exact files with line ranges + what to look for (be specific — "the `createSession()` export", not "understand the file")
  - **DISCOVERY QUESTION:** ONE question this task must answer before changing code
  - **ACTIVE PHEROMONES:** PH-IDs from step 2b with file:line and what they warn about
  - **VERIFY WITH:** Project build/test commands (from Operator Manual) + ONE task-specific check
  - **REMINDERS:** CODE_ONLY or data-ops backup needed

### 2h. WRITE TASK PACKET
□ Write completed task packet to `.neo/inbox/TASK_<TASK_ID>.md`
□ Use `templates/TASK_PACKET.md` format — fill ALL sections including:
  - HIVE CONTEXT from step 2b (file history, pheromones, scored lessons, rejection patterns)
  - CARD DECK from step 2c
  - Dependency notes from step 2d
  - OPERATOR MANUAL ALERTS from step 2e
  - PRIOR WORK ON TARGET FILES from step 2f
  - ANT MISSION BRIEF from step 2g (files, question, pheromones, verify commands)
□ Add to CONSTRAINTS: "depends_on: [<list>]" and "blocks: [<list>]"
□ Fill all `<placeholders>` with real data — the Ant's cards handle the protocol

## 3. BATCH OUTPUT

□ Present batch summary:

```
TASK BATCH <N>/<TOTAL> — <N> task packets written
═══════════════════════════════════════════════════

| # | Task ID | Ant Type | Objective | Files | Hive Signals |
|---|---------|----------|-----------|-------|--------------|
| 1 | TASK-NNN | <emoji> | <obj> | <N> | <PH count>, <L count> |
| 2 | TASK-NNN | <emoji> | <obj> | <N> | <signals> |
| ... | ... | ... | ... | ... | ... |

Files written:
  .neo/inbox/TASK_<ID>.md
  .neo/inbox/TASK_<ID>.md
  ...
```

## 4. BATCH GATE

```
🛑 END RESPONSE HERE. Write this as your LAST line:
⏸️ Gate: TASK BATCH <N>/<TOTAL> OK?
Do NOT proceed to next batch until operator approves.
```

□ If operator modifies a task: apply changes, re-present that task only
□ If operator removes a task: update sequence, adjust dependencies
□ If operator adds a task: validate against decomposition rules, add to next batch

## 5. AFTER FINAL BATCH — RUN PLAN

□ After all batches approved, produce RUN_PLAN:
□ Write `RUN_PLAN_<NNN>.md` to `.neo/` using `templates/RUN_PLAN.md` format
□ Update TODO with all tasks from the plan (ordered, with dependencies noted)

### RUN PLAN CONTENTS
□ IDEA SUMMARY (1-3 sentences)
□ DEPENDENCY MAP (ASCII diagram — full graph)
□ TASK SEQUENCE TABLE (complete, with all batch approvals noted)
□ SESSION BOUNDARIES (if multi-session)
□ HIVE INTELLIGENCE APPLIED (summary of what the hive taught us)
□ RISK ASSESSMENT (aggregated from all tasks)
□ CLOSE PLAN (what BECCA CLOSE should verify for this run)

## 6. FINAL GATE

```
🛑 END RESPONSE HERE. Write this as your LAST line:
⏸️ RUN PLAN OK? Activate first Ant? → I AM
Do NOT produce further output. Hand off to BECCA for Ant dispatch.
```

## STOP CONDITIONS THIS CARD
- Task has >5 target files after enrichment → STOP (S-41) → re-decompose
- Hive Mind query returns no data for target area → note gap, proceed (not a blocker)
- Lesson scoring finds no relevant lessons → note "No prior lessons for this area"
- Dependency chain creates circular reference → STOP (S-43) → refactor
- Batch size >5 tasks → split into smaller batch
