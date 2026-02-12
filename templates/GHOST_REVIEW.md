# GHOST REVIEW: <TASK_ID>

NEO_STATE: REVIEW
ROLE: Ghost (Reviewer)
TARGET: <TASK_ID>
REVIEW_ID: GR-<TASK_ID>
DATE: <YYYY-MM-DD>

---

## 1. REVIEW HEADER

| Field | Value |
|-------|-------|
| Task ID | <TASK_ID> |
| Ant Type | <emoji> <type name> |
| Risk Level | 🔴 HIGH / 🟠 MEDIUM / 🟡 STANDARD / 🟢 LOW |
| Ant Report | `.neo/outbox/ants/ANT_REPORT_<TASK_ID>.md` |
| Task Packet | `.neo/inbox/TASK_<TASK_ID>.md` |
| Definition of Done | <source — packet / operator / inline> |

**Overview:** <1-2 sentence summary of what the Ant did and what this review covers>

---

## 2. REPORT COMPLETENESS

| # | Section | Present? | Quality | Notes |
|---|---------|----------|---------|-------|
| 1 | Task Summary | ✅/❌ | GOOD/FAIR/POOR | <notes> |
| 2 | Discovery Findings | ✅/❌ | GOOD/FAIR/POOR | <notes> |
| 2a | Understanding Proof (LAW 1) | ✅/❌ | GOOD/FAIR/POOR | <4-check table present?> |
| 2b | Snapshot Summary | ✅/❌ | GOOD/FAIR/POOR | <5 fields filled?> |
| 3 | Footprint | ✅/❌ | GOOD/FAIR/POOR | <notes> |
| 3a | Data Op Classification | ✅/❌ | GOOD/FAIR/POOR | <every file classified?> |
| 3b | Backup Proof (conditional) | ✅/❌/N/A | GOOD/FAIR/POOR | <required if data ops — see note> |
| 4 | Patch (Diffs) | ✅/❌ | GOOD/FAIR/POOR | <notes> |
| 5 | Verification | ✅/❌ | GOOD/FAIR/POOR | <notes> |
| 6 | Evidence Index | ✅/❌ | GOOD/FAIR/POOR | <notes> |
| 7 | Self-Assessment | ✅/❌ | GOOD/FAIR/POOR | <notes> |
| 8 | Lessons for Future Ants | ✅/❌ | GOOD/FAIR/POOR | <5 categories present?> |
| 9 | Risks / Pheromones | ✅/❌ | GOOD/FAIR/POOR | <notes> |
| 10 | Gate Log | ✅/❌ | GOOD/FAIR/POOR | <notes> |
| 11 | Hive Context | ✅/❌ | GOOD/FAIR/POOR | <notes> |
| 12 | Handoff | ✅/❌ | GOOD/FAIR/POOR | <notes> |
| 13 | Prompt Feedback | ✅/❌ | GOOD/FAIR/POOR | <4 categories present?> |

**Main sections present:** <N>/13
**Sub-sections present:** <N>/4 *(2a, 2b, 3a, 3b — note 3b is conditional)*

<!--
  Section 3b (Backup Proof) is N/A when ALL operations in Data Op Classification are CODE_ONLY or READ_ONLY.
  Required when ANY operation is DATA_WRITE, DATA_DELETE, MIGRATION, SEED, or CONFIG_WRITE.
-->

### Understanding Proof sub-check (LAW 1):
| Check | Present? |
|-------|----------|
| Read existing code? | ✅/❌ |
| Understand data flow? | ✅/❌ |
| Checked Operator Manual? | ✅/❌/N/A |
| Verified intent? | ✅/❌ |

### Snapshot Summary sub-check:
| Field | Present? |
|-------|----------|
| Root cause | ✅/❌ |
| Affected files | ✅/❌ |
| Proposed approach | ✅/❌ |
| Risk assessment | ✅/❌ |
| Estimated scope | ✅/❌ |

### Data Op Classification sub-check:
| Check | Result |
|-------|--------|
| Every file has an operation type | ✅/❌ |
| Every file has a semantics value | ✅/❌ |
| PUT/DELETE operations have justification | ✅/❌/N/A |
| BACKUP gate triggered (if data ops present) | ✅/❌/N/A |

### Lessons sub-check (Section 8):
| Check | Result |
|-------|--------|
| Lessons section present | ✅/❌ |
| At least one substantive lesson (not all N/A) | ✅/⚠️ |
| Lessons are specific (not generic boilerplate) | ✅/⚠️ |
| Gotchas/surprises documented if encountered | ✅/❌/N/A |

<!--
  ⚠️ = acceptable but low quality — note in findings as INFO
  ❌ = missing section = AUTO REJECT
  All-N/A is acceptable for trivial tasks but should be rare — flag if pattern emerges
-->

### Prompt Feedback sub-check (Section 13):
| Check | Result |
|-------|--------|
| Prompt Feedback section present | ✅/❌ |
| Feedback is real (not copy-paste filler) | ✅/⚠️ |
| Clarity issues quote specific text (if reported) | ✅/❌/N/A |
| Suggestions are actionable (not vague) | ✅/⚠️/N/A |

<!--
  ⚠️ = low quality feedback — note as INFO finding, does NOT affect verdict
  ❌ = missing section = AUTO REJECT (section must exist, even if all N/A)
  Ghost does NOT reject based on feedback CONTENT — only on section PRESENCE
  Feedback about the protocol is encouraged, not penalized
-->

---

## 3. DEFINITION OF DONE

| # | Criterion | Status | Evidence Reference |
|---|-----------|--------|-------------------|
| 1 | <criterion 1> | PASS/FAIL | <evidence from Ant report> |
| 2 | <criterion 2> | PASS/FAIL | <evidence from Ant report> |
| 3 | <criterion 3> | PASS/FAIL | <evidence from Ant report> |

**DoD met:** <N>/<total> criteria passed

---

## 4. EVIDENCE VALIDATION

| # | Check | Result | Details |
|---|-------|--------|---------|
| 1 | All evidence paths real | ✅/❌ | <list any fake paths> |
| 2 | No placeholder paths | ✅/❌ | <list any found> |
| 3 | No generic text | ✅/❌ | <list any found> |
| 4 | All claims have proof | ✅/❌ | <list unproven claims> |
| 5 | Diffs match actual files | ✅/❌ | <verification method> |
| 6 | Test output is real | ✅/❌ | <verification method> |

**Evidence score:** <N>%

<!--
  Score thresholds:
  ≥ 90% = STRONG — all evidence is solid
  70-89% = ADEQUATE — passes, minor gaps
  50-69% = WEAK — needs improvement, borderline
  < 50% = AUTO REJECT — too many evidence gaps
-->

---

## 5. COMPLIANCE CHECK

### Ant Type Validation

| Check | Result | Details |
|-------|--------|---------|
| Ant Type present in report header | ✅/❌ | <ANT_TYPE line present?> |
| Ant Type matches task packet | ✅/❌ | <packet type vs report type> |
| Risk level matches type | ✅/❌ | <correct risk for this type?> |

**Risk-specific requirements:**

| If Risk Level | Required | Present? |
|---------------|----------|----------|
| 🔴 HIGH | Security/payment impact assessment in FOOTPRINT | ✅/❌ |
| 🔴 HIGH | Domain-specific tests in VERIFY | ✅/❌ |
| 🟠 MEDIUM | Validation edge-case testing in VERIFY | ✅/❌ |
| 🟡 STANDARD | Standard verification (no extras) | ✅/❌ |
| 🟢 LOW | Standard verification (no extras) | ✅/❌ |

*(Only fill in rows matching the task's risk level)*

### Critical Surface Verification

| Critical File | Override Token? | Details |
|---------------|----------------|---------|
| <file> | ✅/❌/N/A | <🔑 CRITICAL SURFACE OVERRIDE present?> |

*(N/A if no critical surfaces touched)*

### Gate Log Verification

| Gate | Token Present? | Operator Issued? |
|------|----------------|------------------|
| 🔑 FOOTPRINT APPROVED | ✅/❌ | ✅/❌ |
| 🔑 BACKUP APPROVED | ✅/❌/N/A | ✅/❌/N/A |
| 🔑 PATCH APPROVED | ✅/❌ | ✅/❌ |
| 🔑 VERIFY APPROVED | ✅/❌ | ✅/❌ |
| 🔑 REPORT APPROVED | ✅/❌ | ✅/❌ |

<!--
  BACKUP gate is CONDITIONAL — only present when data operations exist in FOOTPRINT.
  If all operations are CODE_ONLY or READ_ONLY, mark BACKUP row as N/A.
-->

---

### 5b. Hive Mind Compliance

| Check | Result | Details |
|-------|--------|---------|
| Ant performed Hive Mind Check (Section 11 present) | ✅/❌ | <HIVE CONTEXT section found?> |
| Hive context matches actual indexes | ✅/❌ | <Ghost spot-checked 2 claims?> |
| NUCLEAR pheromones acknowledged | ✅/❌/N/A | <if active on target files> |
| High-traffic files flagged | ✅/❌/N/A | <>5 previous tasks?> |
| First-run noted (if applicable) | ✅/❌/N/A | <.neo/index/ doesn't exist?> |

---

### 5c. Surgical Protocol Compliance

| Check | Result | Details |
|-------|--------|---------|
| Understanding Proof present (LAW 1) | ✅/❌ | <4-check table in Discovery section?> |
| All 4 proof fields filled with real evidence | ✅/❌ | <no placeholders or generic text?> |
| Data Op Classification present | ✅/❌ | <every modified file classified?> |
| Operation types valid | ✅/❌ | <CODE_ONLY/READ_ONLY/DATA_WRITE/DATA_DELETE/MIGRATION/SEED/CONFIG_WRITE?> |
| Semantics valid | ✅/❌ | <PATCH/PUT/DELETE — PUT/DELETE have justification?> |
| Backup Proof present (if data ops) | ✅/❌/N/A | <LAW 2 — required when data ops exist> |
| Backup verified before changes | ✅/❌/N/A | <backup timestamp + restore method documented?> |

**Anti-Assumption Spot Check:**

| Rule | Description | Violated? | Details |
|------|-------------|-----------|---------|
| A-01 | No changes to code not read in THIS session | ✅ CLEAN / ❌ VIOLATED | <evidence> |
| A-02 | No "should work" / "probably fine" language | ✅ CLEAN / ❌ VIOLATED | <evidence> |
| A-03 | No assuming file exists without checking | ✅ CLEAN / ❌ VIOLATED | <evidence> |
| A-05 | No bulk operations without full enumeration | ✅ CLEAN / ❌ VIOLATED | <evidence> |
| A-07 | Operator Manual consulted (if exists) | ✅ CLEAN / ❌ VIOLATED / N/A | <evidence> |

<!--
  Full anti-assumption rules (A-01 through A-08) are in NEO-HIVE.md.
  Ghost spot-checks the 5 most commonly violated rules above.
  If ANY rule is VIOLATED → finding category = COMPLIANCE, severity = MEDIUM+.
-->

**Surgical Protocol status:** PASS / FAIL — *FAIL if Understanding Proof missing, data ops unclassified, or backup missing when required*

---

## 6. NUCLEAR & PHEROMONE AUDIT

### ⚫ NUCLEAR Check

| Condition | Detected? | Details |
|-----------|-----------|---------|
| Cross-tenant data access | ✅ NONE / ❌ FOUND | <details> |
| Tenant isolation breach | ✅ NONE / ❌ FOUND | <details> |
| Credential exposure | ✅ NONE / ❌ FOUND | <details> |
| Security boundary bypass | ✅ NONE / ❌ FOUND | <details> |
| Data deletion without safeguards | ✅ NONE / ❌ FOUND | <details> |

**NUCLEAR status:** ✅ CLEAR / ❌ NUCLEAR CONDITION DETECTED → AUTO REJECT

### Pheromone Validation

| Check | Result | Details |
|-------|--------|---------|
| Pheromone section present in report | ✅/❌ | <section found?> |
| All risks have matching pheromones | ✅/❌ | <unmatched risks?> |
| Pheromone severity matches risk | ✅/❌ | <mismatches?> |
| ⚫ NUCLEAR pheromones correct | ✅/❌/N/A | <tenant/credential issues properly flagged?> |
| No suppressed pheromones | ✅/❌ | <hidden risks?> |

### Violation Scan

| ID | Violation | Detected? | Details |
|----|-----------|-----------|---------|
| V-01 | Gate skipping | ✅ NONE / ❌ FOUND | <details> |
| V-02 | Budget continue without expansion | ✅ NONE / ❌ FOUND | <details> |
| V-03 | Read-only exception claim | ✅ NONE / ❌ FOUND | <details> |
| V-04 | Self-issued token | ✅ NONE / ❌ FOUND | <details> |
| V-05 | Multi-gate single message | ✅ NONE / ❌ FOUND | <details> |
| V-06 | Acknowledge+continue past STOP | ✅ NONE / ❌ FOUND | <details> |
| V-07 | Token without 🔑 prefix | ✅ NONE / ❌ FOUND | <details> |
| V-08 | Critical surface without override | ✅ NONE / ❌ FOUND | <details> |
| V-09 | Data operations without backup proof | ✅ NONE / ❌ FOUND | <details> |

**Violations detected:** <count> — *any violation = AUTO REJECT*

---

## 7. FINDINGS

| ID | Severity | Category | Finding | Location |
|----|----------|----------|---------|----------|
| F-001 | HIGH/MED/LOW/INFO | EVIDENCE/COMPLIANCE/QUALITY/NUCLEAR/SURGICAL | <finding> | <where> |

### Finding Details

#### F-001: <title>
- **Severity:** <level>
- **Category:** <EVIDENCE / COMPLIANCE / QUALITY / NUCLEAR / SURGICAL>
- **Location:** <file:line>
- **Description:** <what the issue is>
- **Evidence:** <proof>

*(Repeat for each finding)*

**Finding summary:**
| Severity | Count |
|----------|-------|
| ⚫ NUCLEAR | <n> |
| HIGH | <n> |
| MEDIUM | <n> |
| LOW | <n> |
| INFO | <n> |
| **TOTAL** | **<n>** |

---

## 8. VERDICT & HANDOFF

**Verdict:** <APPROVED / APPROVED WITH NOTES / CHANGES REQUESTED / REJECTED>

**Rationale:** <why this verdict, referencing specific section results above>

**Score card:**
| Section | Result |
|---------|--------|
| 2. Report Completeness | <N>/13 main + <N>/4 sub |
| 3. DoD | <N>/<total> criteria |
| 4. Evidence | <N>% score |
| 5. Compliance | PASS/FAIL |
| 5b. Hive Mind | PASS/FAIL/N/A |
| 5c. Surgical Protocol | PASS/FAIL |
| 6. Nuclear & Pheromone | CLEAR/FLAGGED |

**If REJECTED — Deficiency List:**
1. <deficiency 1 — reference section + finding ID>
2. <deficiency 2>

**Handoff:**
- If APPROVED: → Activate Inspector? → I AM
- If APPROVED WITH NOTES: → Activate Inspector? → I AM *(operator should note: <notes>)*
- If CHANGES REQUESTED: → Send back to Ant? → I AM
- If REJECTED: → Send back to Ant? → I AM

---

## APPROVAL

🔑 <GHOST APPROVED / GHOST APPROVED WITH NOTES: <notes> / GHOST CHANGES REQUESTED: <list> / GHOST REJECTED: <reason>>
