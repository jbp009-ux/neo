# INSPECTOR REPORT: <TASK_ID>

NEO_STATE: INSPECT
ROLE: Inspector (Auditor)
TARGET: <inspection target>
INSPECTION_ID: INS-<TASK_ID>
INSPECTION_TYPE: DRIFT / COMPLIANCE / QUALITY / NUCLEAR / PHEROMONE
DATE: <YYYY-MM-DD>

---

## 1. INSPECTION SUMMARY

| Field | Value |
|-------|-------|
| Target | <file/report/codebase area> |
| Type | <DRIFT / COMPLIANCE / QUALITY / NUCLEAR / PHEROMONE> |
| Standards Checked | <list of standards references> |
| Total Findings | <count> |

---

## 2. FINDINGS TABLE

| ID | Severity | Category | Location | Description |
|----|----------|----------|----------|-------------|
| INS-001 | ⚫NUCLEAR/BLOCKER/HIGH/MED/LOW/INFO | DRIFT/COMPLIANCE/QUALITY/NUCLEAR/PHEROMONE | <file:line> | <description> |
| INS-002 | ... | ... | ... | ... |

---

## 3. FINDING DETAILS

### INS-001: <title>
- **Severity:** <level>
- **Category:** <DRIFT / COMPLIANCE / QUALITY>
- **Location:** <file:line>
- **Standard violated:** <which standard or rule>
- **Evidence:** <proof of the finding>
- **Recommendation:** <specific suggestion — NOT a fix>

*(Repeat for each finding)*

---

## 4. SEVERITY SUMMARY

| Severity | Count |
|----------|-------|
| ⚫ NUCLEAR | <n> |
| BLOCKER | <n> |
| HIGH | <n> |
| MEDIUM | <n> |
| LOW | <n> |
| INFO | <n> |
| **TOTAL** | **<n>** |

---

## 5. VERDICT

**Verdict:** <PASS / PASS WITH FINDINGS / FAIL>

| Condition | Result |
|-----------|--------|
| BLOCKER findings | <n> (must be 0 for PASS) |
| HIGH findings | <n> |
| Overall assessment | <summary> |

---

## 6. RECOMMENDATIONS

1. <recommendation 1>
2. <recommendation 2>
3. <recommendation 3>

**Note:** These are recommendations only. The operator decides which to implement.

---

## APPROVAL

🔑 <INSPECTOR PASS / INSPECTOR PASS WITH FINDINGS / INSPECTOR FAIL: <blocker count> blockers>
