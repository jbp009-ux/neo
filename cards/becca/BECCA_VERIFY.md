# BECCA VERIFY CARD
**CARD_ID:** BECCA-VERIFY | **Phase:** VERIFY | **Role:** BECCA
**INPUTS:** All Ant reports + Ghost reviews + Inspector reports from this run, TODO file
> Read this card when all tasks are done and BECCA reactivates for final check.

## 1. TASK CLASSIFICATION
□ Read ALL reports from this run
□ Classify each task:
  - Builder: produced ANT_REPORT (code changes)
  - Debugger: produced TEST_REPORT (diagnosis only)
  - QA: produced QA_REPORT (verification only)

## 2. REGRESSION CHECK (builder tasks only)
□ For each builder Ant after the first:
  → Did it modify files a previous builder also modified?
  → If yes: verify previous Ant's fix/feature still works
  → Check test results from later Ants still pass for earlier fixes
□ Skip regression check for Debugger and QA tasks (no code changes)

## 3. COMPLETENESS CHECK
□ Builder tasks: ✅ across Ant + Ghost + Inspector?
□ Debugger tasks: ✅ across Debugger + Ghost?
□ QA tasks: ✅ across QA + Ghost?
□ Any unresolved ⚫ NUCLEAR findings?
□ Any ❌ REJECTED tasks never re-resolved?

## 4. DEBUGGER RESOLUTION CHECK (if any Debugger tasks)
□ For each Debugger task:
  → Fix task generated from TEST_REPORT?
  → Fix task passed full pipeline?
  → Reproduction steps no longer trigger bug?
□ If diagnosed but no fix dispatched: flag for operator

## 5. CONSISTENCY CHECK
□ Project still builds after all changes?
□ Tests still pass after last builder Ant's work?

## 6. VERIFY OUTPUT
```
BECCA VERIFY — Run <N>
  Tasks: <total>
    Builder: <count> ✅
    Debugger: <count> ✅
    QA: <count> ✅
  Regressions:          NONE / <list>
  Unresolved findings:  NONE / <list>
  Debugger resolutions: all fixed / <list>
  Final build:          PASS / FAIL
  Final tests:          PASS / FAIL / NOT RUN

  VERDICT: ✅ VERIFIED / ❌ REGRESSION / ❌ INCOMPLETE
```

## IF REGRESSION DETECTED
□ Present: what broke, which Ants conflicted, evidence
□ Dispatch fix Ant (🧰 Toolbox) → after fix pipeline completes, re-run VERIFY

## NEXT

```
🛑 END RESPONSE HERE. Write this as your LAST line:
⏸️ VERIFY complete. Loading ARCHIVE.
Do NOT skip ahead. Do NOT start CLOSE yet.
The operator says "continue" → you load BECCA_CLOSE_ARCHIVE card.
If ❌ REGRESSION → dispatch fix Ant, then re-verify before CLOSE.
```
