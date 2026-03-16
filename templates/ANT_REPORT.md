# ANT_REPORT: <TASK_ID>

NEO_STATE: REPORT
ROLE: Ant (Worker)
TASK_ID: <TASK_ID>
ANT_TYPE: <emoji> <type name>
DATE: <YYYY-MM-DD>
DEPENDS_ON: <TASK-NNN, TASK-NNN — or NONE>
PRESERVES: <TASK-NNN, TASK-NNN — prior tasks on same files whose work must survive>

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

## 1b. DISCOVERY STRATEGY

🎯 **ONE QUESTION:** <the single question this DISCOVERY must answer>
📂 **FIRST FILE:** <the one file most likely to answer the question>
🔍 **SEARCH PLAN:** <max 3 grep/glob patterns to execute>
⏱️ **BUDGET:** <expected resource usage — e.g., "3 of 5 files, 5 of 10 greps">

<!--
  MANDATORY: State your question BEFORE reading any code.
  If you need two questions, you don't understand the task yet.
  Ghost will REJECT reports missing this section.
-->

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

### BUDGET LEDGER

| Resource | Budget | Used | Remaining | Status |
|----------|--------|------|-----------|--------|
| Files read | 5 | <N> | <N> | ✅/⚠️/🛑 |
| Lines shown | 200 | <N> | <N> | ✅/⚠️/🛑 |
| Greps run | 10 | <N> | <N> | ✅/⚠️/🛑 |

<!--
  Status: ✅ under 70% | ⚠️ 70-99% | 🛑 at limit (requires expansion token)
  Ghost will spot-check these numbers against your actual citations.
-->

**Discovery Strategy answered:** YES/NO
**Original question:** <from Section 1b>
**Answer:** <one-sentence answer with evidence reference>

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

### TRUTHY DIFFS

| # | Check | Result | Evidence |
|---|-------|--------|----------|
| 1 | FOOTPRINT match | ✅/❌ | Every diff corresponds to a file in FOOTPRINT |
| 2 | No unauthorized files | ✅/❌ | No files modified that aren't in FOOTPRINT |
| 3 | No ghost files | ✅/❌ | All created files serve a purpose (no stray artifacts) |
| 4 | Diffs match stated changes | ✅/❌ | Changes are not more, not less than approved |
| 5 | No commented-out code | ✅/❌ | Unless FOOTPRINT specified |
| 6 | No TODO/FIXME/HACK | ✅/❌ | Unless FOOTPRINT specified |
| 7 | Imports/exports intact | ✅/❌ | No broken references from changes |

**TRUTHY DIFFS: <N>/7 ✅**

<!--
  ALL 7 must be ✅. If ANY check fails → STOP and resolve before continuing.
  Ghost will cross-check #1 and #2 independently.
-->

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

### Pre-Submit Self-Review (5 constitutional checks)

> Answer ALL 5 before submitting to Ghost. If ANY answer is NO, fix it first or explain why.

| # | Question | Answer | Evidence |
|---|----------|--------|----------|
| 1 | Did I read the HIVE CONTEXT section and act on injected lessons? | YES/NO | <which lessons acknowledged, how they influenced approach> |
| 2 | Are ALL evidence paths real files I can point to, not placeholders? | YES/NO | <list paths or "verified all N paths exist"> |
| 3 | Did I stay within the FOOTPRINT — no files changed outside approved scope? | YES/NO | <git diff file list matches FOOTPRINT table> |
| 4 | Would Ghost find a real diff if they checked my claims? | YES/NO | <diff verified against actual file contents> |
| 5 | Did I check for the Five Horsemen in my own work? | YES/NO | <H1-H5 scan result — which horsemen checked> |

<!--
  PURPOSE: Constitutional AI-style self-correction before Ghost review.
  Ants who catch their own mistakes BEFORE Ghost save time and improve first-pass rate.
  Ghost will verify these answers — dishonest self-assessment triggers HIGH finding and possible rejection.
  This section is MANDATORY. Do NOT skip or fill with "YES" without evidence.
-->

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

## 11. HIVE EVIDENCE (MANDATORY — prove not vibe)

### 11a. INDEX CHECK PROOF

Did you read each index? **YES/NO with evidence. "I checked" is not proof — cite what you found.**

| Index | Read? | Evidence |
|-------|-------|----------|
| MASTER_INDEX | YES/NO | Found <N> prior tasks on target files: <TASK-NNN (what it did), TASK-NNN (what it did)> / "0 entries for target files" |
| FILE_OWNERSHIP | YES/NO | <file> last touched by <TASK-NNN> on <date> / "No entries for target files" / "Index not yet created" |
| PHEROMONE_REGISTRY | YES/NO | Found: <PH-NNN (severity, message)> / "No active pheromones on target files" |
| LESSONS_INDEX | YES/NO | Found: <L-NNN (category, lesson)> / "No prior lessons on target files" / "Index not yet created" |
| REJECTION_INDEX | YES/NO | Found: <REJ-NNN (category, stage)> / "No prior rejections for this type" / "Index not yet created" |
| FINDINGS_INDEX | YES/NO | Found: <RECURRING finding (count)> / "No recurring findings" / "Index not yet created" |
| HIVEMIND_GLOBAL | YES/NO | Found: <GP-NNN (cross-project pattern)> / "No relevant cross-project patterns" |

<!--
  ALL SEVEN must be YES. If an index doesn't exist yet (first run), write:
  "YES — checked, index does not exist yet (first run)."
  Ghost will REJECT reports with NO in any row.
-->

### 11b. PRIOR TASK CROSS-REFERENCE

| Target File | Prior Tasks Found | What They Did | Still Working? |
|-------------|-------------------|---------------|----------------|
| <path> | <TASK-NNN, TASK-NNN> | <brief: what each task changed in this file> | YES — verified / UNKNOWN — could not verify |
| <path> | None | — | — |

### 11c. PRIOR WORK PRESERVED (ATTESTATION)

<!--
  Name every prior task whose work touches your target files.
  For each one, state whether their changes survive your patch.
  Colony OS proved this prevents Ants from walking over each other's work.
  If no prior tasks exist on your files, write "No prior tasks — clean slate."
-->

| Prior Task | Their Change | Preserved? | Evidence |
|------------|--------------|------------|----------|
| <TASK-NNN> | <what they changed in the file> | YES — untouched / YES — extended / NO — overwritten (justified: <why>) | <diff line or "no overlap"> |

**Attestation:** I have verified that all prior task work on my target files survives this patch, or I have justified why overwriting was necessary.

### 11d. HIVE SUMMARY

- Target files checked against: MASTER_INDEX, FILE_OWNERSHIP, PHEROMONE_REGISTRY, LESSONS_INDEX, HIVEMIND_GLOBAL
- Prior tasks found on target files: <count> (<TASK-NNN list>)
- Prior work preserved: <ALL / PARTIAL — justified / N/A — no prior tasks>
- High-traffic files (>5 tasks): <list or "None">
- NUCLEAR clearances obtained: <list or "N/A">
- Pre-Build Search: <patterns used> → <files found / "Nothing — building new">
- First run (no hive data): <YES/NO>

*(This section is MANDATORY. Ghost will REJECT reports that skip index checks or omit prior work attestation. "Prove not vibe.")*

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

## 14. CARD RECEIPT (CDEX — MANDATORY)

| Field | Value |
|-------|-------|
| Deck ID | CD-<RUN_NUMBER> |
| Policy Pack | PP-<YYYY-MM-DD> |
| Cards Executed | <CARD-CORE-001, CARD-CORE-003, CARD-CORE-004, CARD-CORE-005, CARD-TASK-NNN> |
| Cards Skipped | <CARD-CORE-002 (WAIVER: all CODE_ONLY)> or NONE |
| Blockers | NONE |

### Card Outputs

| Card ID | Output | Acceptance Met? |
|---------|--------|----------------|
| CARD-CORE-001 | Policy loaded: <modules>, pheromones: <list or none> | YES/NO |
| CARD-CORE-003 | Scope: <N files>, operation types: <list> | YES/NO |
| CARD-CORE-004 | Evidence plan: <N criteria mapped> | YES/NO |
| CARD-CORE-005 | Tests: PASS, Build: PASS, Truthy Diffs: 7/7 | YES/NO |

### Card Waivers (if any)

| Card ID | Reason | Risk | Mitigation |
|---------|--------|------|------------|
| <CARD-CORE-002> | All operations CODE_ONLY — no data ops | LOW | Data Op table shows CODE_ONLY for all files |

<!--
  MANDATORY: Missing CARD_RECEIPT = OUTPUT_INVALID: CARD_COMPLIANCE_FAILED.
  Ghost will REJECT reports without this section.
  Every executed card must show acceptance criteria met.
  Every skipped card must have a waiver with reason + risk + mitigation.
  "If it isn't on a card, it didn't happen."
  "If it didn't produce a receipt, it isn't accepted."
-->

---

## 15. REGRESSION LOCK

| Field | Value |
|-------|-------|
| Task Type | FIX / FEATURE / REFACTOR / DOCS / OTHER |
| Regression Lock Required? | YES (fix task) / NO (not a fix) |
| Regression Test | _(test name or path — e.g., `tests/auth/login-timeout.spec.ts`)_ |
| Lock Type | NEW_TEST / UPDATED_TEST / REGRESSION_CHECK_ARTIFACT / N/A |
| Proof | _(paste test output or link to artifact)_ |

<!--
  MANDATORY FOR FIX TASKS.
  If this task fixes a bug, behavioral issue, or regression:
    → You MUST add or update a test that catches this exact issue if it returns.
    → Ghost will REJECT fix tasks without regression lock proof.

  Lock Types:
    NEW_TEST — wrote a new test specifically for this regression
    UPDATED_TEST — extended an existing test to cover this case
    REGRESSION_CHECK_ARTIFACT — non-test proof (e.g., lint rule, type guard, CI check)
    N/A — not a fix task (feature/refactor/docs) — provide brief justification

  The goal: "This bug can never come back silently."
-->

---

## APPROVAL

🔑 REPORT APPROVED: TASK <TASK_ID> COMPLETE — READY FOR GHOST REVIEW
