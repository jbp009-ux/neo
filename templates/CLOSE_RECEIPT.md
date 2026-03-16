# CLOSE RECEIPT — RUN {{RUN_NUMBER}}

**Date:** {{YYYY-MM-DD}}
**Project:** {{PROJECT_NAME}}
**Close Card:** CLOSE_ARCHIVE (1 of 4)
**Close Type:** ARCHIVE_ONLY / FULL (ARCHIVE + ANALYTICS + DEVTOOLS + GOVERNANCE)

---

## ARCHIVE PROOFS

| Check | Status | Evidence |
|-------|--------|----------|
| TODO marked COMPLETE | YES / NO | `.neo/archive/TODO_{{PROJECT}}_{{N}}.md` |
| STATE.md updated | YES / NO | Last Run: {{N}}, Status: COMPLETE |
| RUN_INDEX appended | YES / NO | Entry #{{N}} added |
| HIVE INDEX writes | DONE / PARTIAL / SKIPPED | +{{N}} MASTER, +{{N}} FILES, +{{N}} PHEROMONES, +{{N}} LESSONS, +{{N}} REJECTIONS, +{{N}} FINDINGS |

## ADOPTION SCOREBOARD

| Metric | This Run | Trend |
|--------|----------|-------|
| Tasks completed | {{N}} | — |
| First-pass rate (Ghost approved 1st try) | {{N}}% | ↑/↓/— |
| CARD_RECEIPT in all Ant reports | YES / NO | — |
| Ghost Hard Gate checks enforced | YES / NO | — |
| Lessons extracted | {{N}} | — |
| Lessons reinforced (Success/Failure updated) | {{N}} of {{N}} | — |
| Pheromones emitted / resolved | +{{N}} / -{{N}} | — |
| Regression locks provided | {{N}} of {{N}} fix tasks | — |
| PIPELINE_EVAL score | {{SCORE}}% Grade {{GRADE}} | ↑/↓/— |

## CLOSE DEPTH

| Card | Completed? | Notes |
|------|-----------|-------|
| CLOSE_ARCHIVE | YES | _(this receipt proves it)_ |
| CLOSE_ANALYTICS | YES / SKIPPED | _(session limit / operator skip)_ |
| CLOSE_DEVTOOLS | YES / SKIPPED / N/A | _(no trigger / session limit)_ |
| CLOSE_GOVERNANCE | YES / SKIPPED | _(session limit / operator skip)_ |

## RUN STATE

```
This run is: {{CLOSED / INCOMPLETE}}
```

> **Binary rule:** A run with a CLOSE_RECEIPT is **CLOSED**. A run without one is **INCOMPLETE**. No third state.
> Even ARCHIVE_ONLY with partial HIVE writes produces a receipt — proving CLOSE *ran*.
> The receipt itself is the proof. Its existence in `.neo/outbox/close/` is the signal.

---

**Output path:** `.neo/outbox/close/CLOSE_RECEIPT_RUN_{{N}}.md`
