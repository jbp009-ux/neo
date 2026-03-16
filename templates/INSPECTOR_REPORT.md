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

## 7. CARD RECEIPT (CDEX — MANDATORY)

> "If it didn't produce a receipt, it isn't accepted."

| Field | Value |
|-------|-------|
| deck_id | DECK-<TASK_ID> |
| policy_pack | PP-<YYYY-MM-DD> |
| cards_executed | <count> |
| cards_skipped | <count> |
| blockers | <count or NONE> |

### Card Outputs

| Card ID | Card Title | Status | Output Artifact |
|---------|-----------|--------|-----------------|
| CORE-001 | Load Policy Pack | EXECUTED/SKIPPED | <artifact or N/A> |
| CORE-003 | Scope Lock | EXECUTED/SKIPPED | <artifact or N/A> |
| CORE-004 | Evidence Capture Plan | EXECUTED/SKIPPED | <artifact or N/A> |
| CORE-005 | Post-Change Verification | EXECUTED/SKIPPED | <artifact or N/A> |
| TASK-INS-001 | INSPECTOR_AUDIT | EXECUTED | <this report> |
| TASK-INS-002 | INSPECTOR_VERDICT | EXECUTED | <Section 5 above> |

### Card Waivers (if any)

| Card ID | Reason | Risk | Mitigation | Approver |
|---------|--------|------|------------|----------|
| <card_id> | <reason> | <risk level> | <mitigation> | <operator/BECCA> |

*(If no waivers: "No cards were waived.")*

<!--
  Ghost will REJECT Inspector reports without this section.
  Every executed card must show acceptance criteria met.
  "If it isn't on a card, it didn't happen."
  "If it didn't produce a receipt, it isn't accepted."
-->

---

## APPROVAL

🔑 <INSPECTOR PASS / INSPECTOR PASS WITH FINDINGS / INSPECTOR FAIL: <blocker count> blockers>
