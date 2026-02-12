# TODO: <PROJECT>

**Project:** <project name>
**Created:** <YYYY-MM-DD>
**Run:** <NNN>
**Starting Task ID:** TASK-<NNN>
**Status:** IN PROGRESS
**Created by:** 👑 BECCA (via 🚁 Scout)

🔒 **PROJECT LOCK:** <PROJECT> — `<absolute path to project root>`
All work in this TODO is locked to the above path. Files outside this root are V-10 violations.

---

## TASKS

<!--
  Tasks are created by the 🚁 Scout during BECCA's SCOUT state.
  Task IDs are sequential and NEVER reset across runs.
  Each task goes through: Ant → Ghost → Inspector.
  Use "I AM" to activate each role transition.
-->

### 1. <emoji> <Ant Type> — <TASK_ID>: <objective>

**Target files:** <file1>, <file2>
**Scope boundary:** <file1>, <file2> *(Ant MUST NOT touch files outside this list without operator approval)*
**Success criteria:** <what "done" looks like>
**Loops:** 0

| Stage | Status | Artifact | Verdict | Date |
|-------|--------|----------|---------|------|
| 🐜 Ant | ⬜ | — | — | — |
| 👻 Ghost | ⬜ | — | — | — |
| 🔍 Inspector | ⬜ | — | — | — |

---

### 2. <emoji> <Ant Type> — <TASK_ID>: <objective>

**Target files:** <file1>, <file2>
**Scope boundary:** <file1>, <file2> *(Ant MUST NOT touch files outside this list without operator approval)*
**Success criteria:** <what "done" looks like>
**Loops:** 0

| Stage | Status | Artifact | Verdict | Date |
|-------|--------|----------|---------|------|
| 🐜 Ant | ⬜ | — | — | — |
| 👻 Ghost | ⬜ | — | — | — |
| 🔍 Inspector | ⬜ | — | — | — |

---

### 3. <emoji> <Ant Type> — <TASK_ID>: <objective>

**Target files:** <file1>, <file2>
**Scope boundary:** <file1>, <file2> *(Ant MUST NOT touch files outside this list without operator approval)*
**Success criteria:** <what "done" looks like>
**Loops:** 0

| Stage | Status | Artifact | Verdict | Date |
|-------|--------|----------|---------|------|
| 🐜 Ant | ⬜ | — | — | — |
| 👻 Ghost | ⬜ | — | — | — |
| 🔍 Inspector | ⬜ | — | — | — |

---

<!--
  Add more tasks as needed. Copy the block above.
  Delete unused task blocks before starting.
-->

## ACTIVATION LOG

| # | Trigger | Role Activated | Task | Timestamp |
|---|---------|----------------|------|-----------|
| 0 | deep dive | 👑 BECCA (RECON) | — | <timestamp> |
| 1 | I AM | 🚁 Scout | — | <timestamp> |
| 2 | I AM | 🐜 Ant (<type>) | TASK-<N> | <timestamp> |

<!--
  BECCA and Scout are logged first.
  Then each "I AM" through the pipeline gets logged.
  Example full log:
  | 0 | deep dive | 👑 BECCA (RECON) | — | 2026-02-09 09:00 |
  | 1 | I AM | 🚁 Scout | — | 2026-02-09 09:05 |
  | 2 | I AM | 🐜 Ant (🔥 Fire) | TASK-004 | 2026-02-09 09:20 |
  | 3 | I AM | 👻 Ghost | TASK-004 | 2026-02-09 10:00 |
  | 4 | I AM | 🔍 Inspector | TASK-004 | 2026-02-09 10:30 |
  | 5 | I AM | 🐜 Ant (🛠️ Carpenter) | TASK-005 | 2026-02-09 10:45 |
  | ... | ... | ... | ... | ... |
  | N | I AM | 👑 BECCA (VERIFY) | — | 2026-02-09 16:00 |
-->

---

## NOTES

<!--
  Rejection reasons, operator decisions, cross-session notes.
  Each role can add notes here when rejecting or flagging issues.

  Example:
  - **Ghost REJECTED TASK-004 (loop 1):** Missing test output in VERIFY section.
  - **Inspector FAIL TASK-005 (loop 1):** NUCLEAR finding — cross-tenant query without filter.
  - **Operator:** Skipped Inspector for TASK-006 (low risk, docs-only change).
  - **BECCA VERIFY:** No regressions detected across all tasks.
-->

---

## STATUS LEGEND

| Icon | Meaning |
|------|---------|
| ⬜ | QUEUED — not started |
| 🔄 | IN PROGRESS — role is working |
| ✅ | DONE — stage passed |
| ❌ | REJECTED / FAILED — needs redo |
| ⏸️ | PAUSED — operator halted |

## PIPELINE REMINDER

```
👑 BECCA (RECON) → 🚁 Scout (TODO) → 🐜 Ant → 👻 Ghost → 🔍 Inspector → next task → ... → 👑 BECCA (VERIFY + CLOSE)
```

Everything starts and ends with BECCA. When all tasks show ✅ → say **"I AM"** to activate BECCA for final verification.

🔒 **Reminder:** All work is locked to the PROJECT LOCK root. Ants create a CHECKPOINT before every task. Files outside scope boundary require operator approval.
