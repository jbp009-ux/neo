# TEST_REPORT: <TASK_ID>

NEO_STATE: REPORT
ROLE: Ant (Debugger)
TASK_ID: <TASK_ID>
ANT_TYPE: 🐛 Debugger Ant
DATE: <YYYY-MM-DD>

---

## 1. TASK SUMMARY

| Field | Value |
|-------|-------|
| Task ID | <TASK_ID> |
| Ant Type | 🐛 Debugger Ant |
| Risk Level | 🟡 STANDARD |
| Objective | <what needs to be diagnosed> |
| Status | DIAGNOSED / HALTED |
| Target Files | <file list> |

<1-2 sentence summary of the diagnosis>

---

## 2. HYPOTHESIS

**Initial hypothesis:**
<What do you think is wrong, based on the task description and initial reading?>

**Hypothesis formed from:**
- <evidence 1 — file:line>
- <evidence 2 — file:line>

---

## 3. TEST PLAN

| # | Test | Purpose | Expected Result |
|---|------|---------|-----------------|
| 1 | <test description> | <what it validates> | <expected outcome> |
| 2 | <test description> | <what it validates> | <expected outcome> |

---

## 4. RESULTS

| # | Test | Result | Evidence |
|---|------|--------|----------|
| 1 | <test description> | PASS / FAIL / INCONCLUSIVE | <output or path> |
| 2 | <test description> | PASS / FAIL / INCONCLUSIVE | <output or path> |

### Detailed Output

```
<actual test output, error messages, stack traces>
```

---

## 5. DIAGNOSIS

**Root cause:** <one sentence — what is actually wrong>

**Detailed analysis:**
<explain the root cause with evidence from the test results>

**Confidence level:** HIGH / MEDIUM / LOW

**If MEDIUM or LOW confidence:**
- <what additional investigation is needed>
- <what couldn't be determined and why>

---

## 6. RECOMMENDED ANT TYPE FOR FIX

| Field | Value |
|-------|-------|
| Recommended Ant Type | <emoji> <type name> |
| Why this type | <rationale> |
| Estimated fix scope | <files to change, approx line count> |
| Fix priority | HIGH / MEDIUM / LOW |

**Recommended approach for the fixing Ant:**
1. <step 1>
2. <step 2>
3. <step 3>

---

## 7. EVIDENCE INDEX

| Claim | Evidence |
|-------|----------|
| Root cause identified | <file:line + explanation> |
| Tests run | <test output path or inline> |
| Diagnosis supported | <evidence chain> |

**All paths must be real. No placeholders.**

---

## 8. PHEROMONES EMITTED

| Severity | Category | Target | Message |
|----------|----------|--------|---------|
| <⚫/🔴/🟠/🟡/🟢> | <category> | <file:line> | <description> |

*(If no pheromones: write "No pheromones emitted." — do NOT omit this section.)*

---

## 9. HANDOFF

| Field | Value |
|-------|-------|
| Report written to | .neo/outbox/ants/TEST_REPORT_<TASK_ID>.md |
| Next step | Hand off to <recommended Ant type> |
| Ready for handoff | YES / NO |

**The Debugger Ant has completed its diagnosis. It does NOT fix the issue.**

---

## APPROVAL

🔑 REPORT APPROVED: TASK <TASK_ID> DIAGNOSED — READY FOR HANDOFF TO <ANT_TYPE>
