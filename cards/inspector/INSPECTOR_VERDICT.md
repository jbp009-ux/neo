# INSPECTOR VERDICT CARD
**CARD_ID:** INSPECTOR-VERDICT | **Phase:** VERDICT | **Role:** Inspector
**INPUTS:** Completed INSPECTOR-AUDIT findings, severity assessments, category classifications
> Read this card after completing the audit. Follow every □ item.

## 1. SEVERITY LEVELS

| Severity | Meaning | Effect |
|----------|---------|--------|
| ⚫ NUCLEAR | Tenant/credential/security breach | HALT — operator must resolve |
| BLOCKER | Cannot proceed without fix | Task blocked |
| HIGH | Significant issue | Must fix before completion |
| MEDIUM | Notable concern | Should fix, can defer |
| LOW | Minor issue | Optional fix |
| INFO | Observation | No action required |

## 2. VERDICT CATEGORIES

| Verdict | Token | When |
|---------|-------|------|
| PASS | `🔑 INSPECTOR PASS` | No BLOCKER+ findings |
| PASS WITH FINDINGS | `🔑 INSPECTOR PASS` + findings list | Findings exist but none BLOCKER+ |
| FAIL | `🔑 INSPECTOR FAIL: <reason>` | Any BLOCKER+ finding |

## 3. INSPECTOR_REPORT OUTPUT (7 sections)
□ Write to `.neo/outbox/inspector/INSPECTOR_REPORT_<TASK_ID>.md`

| # | Section | Content |
|---|---------|---------|
| 1 | AUDIT SUMMARY | Task ID, inspection types run, overall verdict |
| 2 | DRIFT FINDINGS | Scope, pattern, state deviations |
| 3 | COMPLIANCE FINDINGS | Evidence, format, gate, tool compliance |
| 4 | QUALITY FINDINGS | Code quality, tests, documentation |
| 5 | NUCLEAR & PHEROMONE FINDINGS | NUCLEAR checks, pheromone validation |
| 6 | HIVE & SURGICAL FINDINGS | Index consistency, surgical protocol |
| 7 | VERDICT | Verdict token, finding summary table, recommendations |

## 4. FINDING SUMMARY TABLE
□ Include in verdict:
  | ID | Severity | Category | Description |
  |-----|----------|----------|-------------|
  | INS-001 | HIGH | DRIFT | ... |

## 5. TODO UPDATE
□ If PASS: mark task stage as "Inspector: PASS" in TODO
□ If FAIL: mark task stage as "Inspector: FAIL — <reason>" in TODO

## NEXT

```
🛑 END RESPONSE HERE. Write this as your LAST line:
⏸️ Inspection complete. Verdict: {PASS / PASS WITH FINDINGS / FAIL}.
Present full report + verdict to operator.
WAIT for operator acknowledgment.
If PASS → Operator issues 🔑 TASK COMPLETE
If FAIL → Operator decides: fix, re-review, or escalate
```
