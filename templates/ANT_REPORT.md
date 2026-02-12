# ANT_REPORT: <TASK_ID>

NEO_STATE: REPORT
ROLE: Ant (Worker)
TASK_ID: <TASK_ID>
ANT_TYPE: <emoji> <type name>
DATE: <YYYY-MM-DD>

---

## 1. TASK SUMMARY

| Field | Value |
|-------|-------|
| Task ID | <TASK_ID> |
| Ant Type | <emoji> <type name> |
| Risk Level | 🔴 HIGH / 🟠 MEDIUM / 🟡 STANDARD / 🟢 LOW |
| Objective | <what was requested> |
| Status | COMPLETED / HALTED |
| Target Files | <file list> |

<1-2 sentence summary of what was done and why>

---

## 2. DISCOVERY FINDINGS

**Current state before changes:**

| Finding | File | Line | Details |
|---------|------|------|---------|
| <finding> | <path> | <line> | <details> |

**Root cause / analysis:**
<explanation of what was found>

### UNDERSTANDING PROOF (LAW 1)

| Check | Evidence |
|-------|----------|
| Read existing code? | YES — read <file>:<lines> |
| Understand data flow? | YES — <description of flow> |
| Checked Operator Manual? | YES — Sections 3-6 reviewed / N/A — no Operator Manual exists |
| Verified intent? | YES — <how current behavior was confirmed> |

### SNAPSHOT SUMMARY

1. **Root cause:** <one sentence — what is actually wrong>
2. **Affected files:** <comma-separated list>
3. **Proposed approach:** <one sentence — what we will do>
4. **Risk assessment:** <HIGH / MEDIUM / LOW + one sentence why>
5. **Estimated scope:** <files to change, approximate line count>

---

## 3. FOOTPRINT (Approved Approach)

**Approved changes:**

| File | Change Type | Risk | Rationale |
|------|-------------|------|-----------|
| <path> | MODIFY/CREATE/DELETE | HIGH/MED/LOW | <why> |

### DATA OPERATION CLASSIFICATION

| File | Operation | Semantics | Justification |
|------|-----------|-----------|---------------|
| <path> | CODE_ONLY / READ_ONLY / DATA_WRITE / DATA_DELETE / MIGRATION / SEED / CONFIG_WRITE | N/A / PATCH / PUT / DELETE | <why this operation + semantics> |

<!--
  Valid operations: CODE_ONLY, READ_ONLY, DATA_WRITE, DATA_DELETE, MIGRATION, SEED, CONFIG_WRITE
  Valid semantics: PATCH (default), PUT (requires justification), DELETE (requires confirmation)
  If ALL operations are CODE_ONLY or READ_ONLY: no BACKUP gate needed
  If ANY operation is DATA_WRITE/DELETE/MIGRATION/SEED/CONFIG_WRITE: BACKUP gate required
-->

**Rollback plan:**
1. Revert: `<file>`
2. Restore original code (see diffs below)
3. Verify: <how to confirm rollback>

---

## 3b. BACKUP PROOF (LAW 2) — CONDITIONAL

<!--
  Only required when FOOTPRINT contains DATA_WRITE, DATA_DELETE, MIGRATION, SEED, or CONFIG_WRITE.
  If all operations are CODE_ONLY or READ_ONLY, write: "No data operations — BACKUP gate not required."
  DELETE THIS COMMENT when filling out.
-->

| Collection | Backup Method | Verification | Location |
|------------|---------------|-------------|----------|
| <collection path> | <snapshot / export / copy> | <how backup was verified> | <backup file path or ID> |

**Backup timestamp:** <ISO datetime>
**Restore method:** <how to restore from backup>

---

## 4. PATCH (Files Changed)

### <filename>
`<path/to/file>:<line range>`

```diff
- <old code>
+ <new code>
```

**Reason:** <why this change>

*(Repeat for each file changed)*

---

## 5. VERIFICATION

| Check | Result | Evidence |
|-------|--------|----------|
| Tests pass | PASS/FAIL/N/A | <test output path or inline> |
| Build succeeds | PASS/FAIL/N/A | <build output> |
| Lint clean | PASS/FAIL/N/A | <lint output> |
| Type check | PASS/FAIL/N/A | <tsc output> |
| Success criteria met | YES/NO | <per-criterion below> |

### Success Criteria Check
| Criterion | PASS/FAIL | Evidence |
|-----------|-----------|----------|
| <criterion from task packet> | PASS/FAIL | <proof> |
| <criterion from task packet> | PASS/FAIL | <proof> |

---

## 6. EVIDENCE INDEX

| Claim | Evidence |
|-------|----------|
| Code changes | <diff paths or inline above> |
| Tests pass | <test output path> |
| Build succeeds | <build output path> |
| No regressions | <verification method> |
| Backup proof | <backup path — or N/A if CODE_ONLY> |

**All paths must be real. No placeholders.**

---

## 7. SELF-ASSESSMENT

| Criterion | Met? | Evidence |
|-----------|------|----------|
| Task requirements fulfilled | YES/NO | <evidence> |
| Tests pass | YES/NO/N/A | <test output> |
| No regressions | YES/NO | <verification method> |
| Evidence is verifiable | YES/NO | <all paths real?> |
| Stayed within scope | YES/NO | <scope check> |

### Confidence Level
| Aspect | Confidence |
|--------|------------|
| Task complete | HIGH / MEDIUM / LOW |
| No regressions | HIGH / MEDIUM / LOW |

### Unknowns / Concerns
- <anything skipped, unclear, or needing follow-up>

---

## 8. LESSONS FOR FUTURE ANTS

| Category | Lesson |
|----------|--------|
| **What worked well** | <discovery technique, tool, or approach that was effective> |
| **What was fragile or surprising** | <gotcha, unexpected behavior, or edge case encountered> |
| **How next Ant should approach** | <advice for an Ant working on the same files/area> |
| **Verification pattern** | <test technique or validation method that proved useful> |
| **Protocol tip** | <efficiency gain, shortcut, or process improvement> |

*(Fill in what applies. Write "N/A" for categories with nothing to report. Do NOT omit this section.)*

---

## 9. RISKS / UNKNOWNS

| Risk | Severity | Mitigation |
|------|----------|------------|
| <what could break> | HIGH/MED/LOW | <how to handle> |

### PHEROMONES EMITTED

| Severity | Category | Target | Message |
|----------|----------|--------|---------|
| <⚫/🔴/🟠/🟡/🟢> | <ISOLATION/SECURITY/VALIDATION/PERFORMANCE/etc.> | <file:line> | <description> |

*(If no pheromones: write "No pheromones emitted." — do NOT omit this section.)*

---

## 10. GATE LOG

| Gate | Token | Issued By | Timestamp |
|------|-------|-----------|-----------|
| FOOTPRINT | 🔑 FOOTPRINT APPROVED | Operator | <ISO> |
| BACKUP | 🔑 BACKUP APPROVED | Operator | <ISO> |
| PATCH | 🔑 PATCH APPROVED | Operator | <ISO> |
| VERIFY | 🔑 VERIFY APPROVED | Operator | <ISO> |
| REPORT | 🔑 REPORT APPROVED | Operator | <ISO> |

<!--
  BACKUP gate is CONDITIONAL — only present when data operations exist in FOOTPRINT.
  If all operations are CODE_ONLY or READ_ONLY, remove the BACKUP row.
-->

---

## 11. HIVE CONTEXT

| File | Previous Tasks | Active Pheromones | Hive Risk |
|------|---------------|-------------------|-----------|
| <path> | <TASK-NNN, TASK-NNN> | <PH-NNN or None> | <HIGH/MEDIUM/LOW — reason> |

**Hive Mind Briefing Summary:**
- Target files checked against: MASTER_INDEX, FILE_OWNERSHIP, PHEROMONE_REGISTRY
- High-traffic files (>5 tasks): <list or "None">
- NUCLEAR clearances obtained: <list or "N/A">
- First run (no hive data): <YES/NO>

*(If first run with no .neo/index/: write "First run — no hive data available." Do NOT omit this section.)*

---

## 12. HANDOFF

| Field | Value |
|-------|-------|
| Report written to | `.neo/outbox/ants/ANT_REPORT_<TASK_ID>.md` |
| Next step | Ghost Review |
| Ready for Ghost | YES/NO |

---

## 13. PROMPT FEEDBACK

| Category | Feedback |
|----------|----------|
| **Clarity issues** | <task packet or protocol wording that was ambiguous or confusing — quote the exact text> |
| **Missing rules** | <situation encountered where no guidance existed — what rule should be added?> |
| **False positives** | <protocol rule that triggered but wasn't relevant — which rule, why it didn't apply> |
| **Suggestions** | <process improvement, tool gap, or protocol enhancement idea> |

*(Fill in what applies. Write "N/A — no feedback this task." if nothing to report. Do NOT omit this section.)*

<!--
  PURPOSE: System self-improvement loop. BECCA aggregates during CLOSE.
  If 3+ Ants report the same issue → priority fix for protocol/templates.
  Ghost validates feedback is real (not filler).
  This section does NOT affect the task's PASS/FAIL verdict.
-->

---

## APPROVAL

🔑 REPORT APPROVED: TASK <TASK_ID> COMPLETE — READY FOR GHOST REVIEW
