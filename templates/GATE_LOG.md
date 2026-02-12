# GATE LOG: <TASK_ID>

**Task:** <TASK_ID>
**Started:** <YYYY-MM-DD>
**Status:** IN_PROGRESS / COMPLETE / HALTED

---

## TOKEN TRAIL

| # | Gate | Token | Issued By | Timestamp | Notes |
|---|------|-------|-----------|-----------|-------|
| 1 | TASK ASSIGNED | 🔑 TASK ASSIGNED | Operator | <ISO> | Task packet created |
| 2 | FOOTPRINT | 🔑 FOOTPRINT APPROVED | Operator | <ISO> | |
| 3 | PATCH | 🔑 PATCH APPROVED | Operator | <ISO> | |
| 4 | VERIFY | 🔑 VERIFY APPROVED | Operator | <ISO> | |
| 5 | REPORT | 🔑 REPORT APPROVED | Operator | <ISO> | |
| 6 | GHOST | 🔑 GHOST APPROVED | Ghost/Operator | <ISO> | |
| 7 | INSPECTOR | 🔑 INSPECTOR PASS | Inspector/Operator | <ISO> | Optional |
| 8 | COMPLETE | 🔑 TASK COMPLETE | Operator | <ISO> | Pipeline ends |

---

## REJECTIONS (if any)

| # | Gate | Token | Reason | Resolution |
|---|------|-------|--------|------------|
| R-1 | <gate> | 🔑 REJECTED: <reason> | <details> | <how resolved> |

---

## NOTES

- <any additional context about gate decisions>

---

**Gate log complete:** YES / NO
**All gates passed:** YES / NO
