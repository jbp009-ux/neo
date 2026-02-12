# NEO-OUTPUTS v1.8.0
## Output Contracts — Locked Formats Per Role

**Purpose:** Required output structure for every NEO role and state, including hive mind index contracts, surgical protocol evidence, knowledge transfer, system feedback, and specialized Ant outputs
**Scope:** Loaded by ALL NEO roles (Ant, Ghost, Inspector)

---

## 0) Project File Paths

All output paths are relative to the project's `.neo/` directory.

```
<PROJECT_ROOT>/.neo/
├── inbox/TASK_<TASK_ID>.md                        ← Task packets (input)
├── outbox/
│   ├── ants/ANT_REPORT_<TASK_ID>.md               ← Ant reports
│   ├── ghost/GHOST_REVIEW_<TASK_ID>.md            ← Ghost reviews
│   └── inspector/INSPECTOR_REPORT_<TASK_ID>.md    ← Inspector reports
├── index/
│   ├── MASTER_INDEX_NNN.md                        ← Task registry (500/shard)
│   ├── FILE_OWNERSHIP_<dir>.md                    ← Per-file task history
│   └── PHEROMONE_<SEVERITY>.md                    ← Active warnings by severity
├── audit/
│   ├── evidence/<TASK_ID>_test_output.txt         ← Evidence artifacts
│   ├── evidence/<TASK_ID>_backup_proof.txt        ← Backup verification proof
│   ├── gate-logs/GATE_LOG_<TASK_ID>.md            ← Gate logs (archived)
│   └── reviews/                                    ← Archived reviews
├── runtime/GATE_LOG_<TASK_ID>.md                  ← Active gate logs
└── OPERATOR_MANUAL_<PROJECT>.md                   ← Project-specific danger zones & safe ops
```

**When deployed to a project (e.g., Sonny):**
`d:\projects\sonny\.neo\outbox\ants\ANT_REPORT_TASK-001.md`

---

## 1) Universal Output Skeleton

Every role output MUST include this minimum structure:

```markdown
NEO_STATE: <STATE_NAME>
ROLE: <Ant / Ghost / Inspector>
TARGET: <task_id or inspection target>

## ACTIONS TAKEN
- <bullet>

## OUTPUTS CREATED
- <path>

## EVIDENCE
- <path or command output>

## NEXT
- <what happens next>

## APPROVAL
🔑 <token>
```

---

## 2) Ant Report (ANT_REPORT)

**Path:** `.neo/outbox/ants/ANT_REPORT_<TASK_ID>.md`

**Full template:** See `templates/ANT_REPORT.md`

### Required Sections (ALL mandatory)

| # | Section | Purpose |
|---|---------|---------|
| — | Header (metadata) | State, role, task ID, **Ant Type**, date *(unnumbered block)* |
| 1 | Task Summary | What was requested vs delivered (**includes Ant Type + Risk Level**) |
| 2 | Discovery Findings | Current state analysis (**includes Understanding Proof — LAW 1**) |
| 3 | Footprint (Proposed Changes) | Approved approach (**includes Data Op Classification table**) |
| 3b | **Backup Proof** | **Backup evidence if data ops present (conditional — LAW 2)** |
| 4 | Patch (Files Changed) | Actual diffs |
| 5 | Verification | Test/build results |
| 6 | Evidence Index | All proof linked |
| 7 | Self-Assessment | Honest evaluation |
| 8 | **Lessons for Future Ants** | **Knowledge transfer — what worked, gotchas, advice for next Ant** |
| 9 | Risks / Unknowns | Outstanding concerns |
| 10 | Gate Log | Full token trail (**includes BACKUP gate if applicable**) |
| 11 | **Hive Context** | **Previous tasks, active pheromones, traffic assessment per file** |
| 12 | Handoff | Next step + approval token |
| 13 | **Prompt Feedback** | **System feedback — clarity issues, missing rules, false positives, suggestions** |

---

## 3) Ghost Review (GHOST_REVIEW)

**Path:** `.neo/outbox/ghost/GHOST_REVIEW_<TASK_ID>.md`

**Full template:** See `templates/GHOST_REVIEW.md`

### Required Sections

| # | Section | Purpose |
|---|---------|---------|
| 1 | Header (metadata) | State, role, review target |
| 2 | Review Summary | Overview (**includes Ant Type + Risk Level**) |
| 3 | Report Completeness Check | Section-by-section validation |
| 4 | Definition of Done Check | Each criterion PASS/FAIL |
| 4b | **Ant Type Validation** | **Type match, risk-specific requirements** |
| 5 | Evidence Validation | Path reality, score |
| 5b | **Hive Mind Compliance** | **Section 11 present, claims verified, NUCLEAR acknowledged** |
| 5c | **Surgical Protocol Compliance** | **Understanding proof, backup proof, data op classification, write semantics** |
| 6 | Findings | Issues discovered |
| 7 | Verdict | APPROVED / REJECTED with rationale |

---

## 4) Inspector Report (INSPECTOR_REPORT)

**Path:** `.neo/outbox/inspector/INSPECTOR_REPORT_<TASK_ID>.md`

**Full template:** See `templates/INSPECTOR_REPORT.md`

### Required Sections

| # | Section | Purpose |
|---|---------|---------|
| 1 | Header (metadata) | State, role, inspection type |
| 2 | Inspection Summary | Target and scope |
| 3 | Findings Table | All findings with severity |
| 4 | Finding Details | Per-finding breakdown |
| 5 | Severity Summary | Counts by severity |
| 6 | Verdict | PASS / FAIL |
| 7 | Recommendations | Specific suggestions |

---

## 5) Task Packet (input to Ant)

**Path:** `.neo/inbox/TASK_<TASK_ID>.md`

**Full template:** See `templates/TASK_PACKET.md`

### Required Fields

| Field | Required | Description |
|-------|----------|-------------|
| task_id | YES | Unique task identifier |
| ant_type | YES | One of 12 Ant Types (determines risk level and gate behavior) |
| objective | YES | What needs to be done |
| target_files | YES | Files to work on |
| success_criteria | YES | How to know it's done |
| constraints | Optional | Limits on the approach |
| definition_of_done | YES | Criteria for Ghost to check |

---

## 6) Gate Log

**Path:** `.neo/audit/gate-logs/GATE_LOG_<TASK_ID>.md`

**Full template:** See `templates/GATE_LOG.md`

### Required Fields

| Column | Description |
|--------|-------------|
| Gate | Which gate (FOOTPRINT, BACKUP, PATCH, etc.) |
| Token | The exact approval token issued |
| Issued By | Who issued the token |
| Timestamp | When it was issued |

**Note:** The BACKUP gate is **conditional** — only present when the task includes data operations (DATA_WRITE, DATA_DELETE, MIGRATION, SEED, CONFIG_WRITE). See `NEO-SURGICAL.md` Section 4.

---

## 7) Debugger Test Report (TEST_REPORT)

**Path:** `.neo/outbox/ants/TEST_REPORT_<TASK_ID>.md`

**Full template:** See `templates/TEST_REPORT.md`

**Used by:** 🐛 Debugger Ant ONLY. This is NOT an ANT_REPORT — it's a diagnostic output.

### Required Sections

| # | Section | Purpose |
|---|---------|---------|
| 1 | Header (metadata) | State, role, task ID, Ant Type (always 🐛 Debugger), date |
| 2 | Hypothesis | What the Debugger thinks is wrong |
| 3 | Test Plan | What tests were run to validate hypothesis |
| 4 | Results | Test output, evidence of behavior |
| 5 | Diagnosis | Root cause analysis based on evidence |
| 6 | Recommended Ant Type | Which Ant type should fix this (e.g., 🔥 Fire Ant for auth fix) |
| 7 | Evidence Index | All proof linked |
| 8 | Handoff | Next step — always "Hand off to <recommended Ant type>" |

**The Debugger Ant NEVER fixes code. It produces a TEST_REPORT and hands off.**

---

## 7b) Snapshot Summary (End of DISCOVERY)

Every Ant MUST produce a **5-line snapshot summary** at the end of DISCOVERY state, before requesting gate approval.

### Snapshot Summary Format

```markdown
## SNAPSHOT SUMMARY

1. **Root cause:** <one sentence — what is actually wrong>
2. **Affected files:** <comma-separated list of files>
3. **Proposed approach:** <one sentence — what we will do>
4. **Risk assessment:** <HIGH / MEDIUM / LOW + one sentence why>
5. **Estimated scope:** <number of files to change, approximate line count>
```

**Purpose:** Prevents DISCOVERY bloat. Forces the Ant to crystallize findings into actionable summary before requesting FOOTPRINT approval.

---

## 7c) Pheromone Output Format

Pheromones MUST appear in the Ant Report's "Risks / Unknowns" section using this exact format:

```markdown
## PHEROMONES EMITTED

| Severity | Category | Target | Message |
|----------|----------|--------|---------|
| ⚫ NUCLEAR | ISOLATION | src/api/query.ts:42 | Cross-tenant query without filter |
| 🔴 HIGH | SECURITY | src/auth/login.ts:15 | Fallback password in auth flow |
| 🟠 MEDIUM | VALIDATION | src/forms/order.ts:88 | No sanitization on user input |
```

**If no pheromones: write `No pheromones emitted.` — do NOT omit the section.**

---

## 7d) Surgical Protocol Outputs

### Understanding Proof (in DISCOVERY findings — Section 3)

```markdown
## UNDERSTANDING PROOF (LAW 1)

| Check | Evidence |
|-------|----------|
| Read existing code? | YES — read <file>:<lines> |
| Understand data flow? | YES — <description of flow> |
| Checked Operator Manual? | YES — Sections 3-6 reviewed |
| Verified intent? | YES — <how current behavior was confirmed> |
```

### Data Operation Classification (in FOOTPRINT — Section 4)

```markdown
## DATA OPERATION CLASSIFICATION

| File | Operation | Semantics | Justification |
|------|-----------|-----------|---------------|
| <file> | DATA_WRITE | PATCH (merge) | Adding field to existing document |
| <file> | CODE_ONLY | N/A | Logic change only — no data touched |
```

**Valid operations:** `CODE_ONLY`, `READ_ONLY`, `DATA_WRITE`, `DATA_DELETE`, `MIGRATION`, `SEED`, `CONFIG_WRITE`
**Valid semantics:** `PATCH` (default), `PUT` (requires justification), `DELETE` (requires confirmation)

### Backup Proof (in Section 4b — conditional)

```markdown
## BACKUP PROOF (LAW 2)

| Collection | Backup Method | Verification | Location |
|------------|---------------|-------------|----------|
| <collection> | <method used> | <how verified> | <backup path or ID> |
```

**Only required when FOOTPRINT contains:** `DATA_WRITE`, `DATA_DELETE`, `MIGRATION`, `SEED`, or `CONFIG_WRITE`

---

## 7e) Lessons for Future Ants (Section 8 of Ant Report)

Every Ant MUST produce a **LESSONS FOR FUTURE ANTS** section documenting knowledge transfer for Ants that will work on the same files/area in the future.

### Lessons Output Format

```markdown
## 8. LESSONS FOR FUTURE ANTS

| Category | Lesson |
|----------|--------|
| **What worked well** | Tracing data flow through hooks identified root cause quickly |
| **What was fragile or surprising** | Phase ID format inconsistency between hooks |
| **How next Ant should approach** | Check phase ID format mismatch first |
| **Verification pattern** | Run emulator with --debug flag to see Firestore writes |
| **Protocol tip** | Read the middleware chain before touching any endpoint |
```

**5 categories — fill in what applies, write "N/A" for categories with nothing to report.**

| Category | What to Write |
|----------|---------------|
| **What worked well** | Discovery technique, tool, or approach that was effective |
| **What was fragile or surprising** | Gotcha, unexpected behavior, edge case, or brittle code |
| **How next Ant should approach** | Advice for an Ant working on the same files or area |
| **Verification pattern** | Test technique or validation method that proved useful |
| **Protocol tip** | Efficiency gain, shortcut, or process improvement |

**Purpose:** At scale (10,000 ANTs), an Ant checks FILE_OWNERSHIP to find previous tasks on target files, then reads those reports' Section 8 to absorb lessons before starting work. This prevents re-learning the same gotchas.

**If nothing to report for all 5 categories:** Write a single row: `| **General** | Straightforward task — no notable lessons. |` — do NOT omit the section.

---

## 7f) Prompt Feedback (Section 13 of Ant Report)

Every Ant MUST produce a **PROMPT FEEDBACK** section reporting on the NEO system itself — protocol gaps, confusing instructions, things that should be improved.

### Prompt Feedback Output Format

```markdown
## 13. PROMPT FEEDBACK

| Category | Feedback |
|----------|----------|
| **Clarity issues** | Task packet said "harden payment functions" but didn't specify SaaS vs legacy mode handling |
| **Missing rules** | No guidance for when target file has both CODE_ONLY and DATA_WRITE operations in same task |
| **False positives** | N/A |
| **Suggestions** | Add a pre-flight checklist for payment-related tasks — too easy to miss edge cases |
```

**4 categories — fill in what applies, write "N/A" for categories with nothing to report.**

| Category | What to Write |
|----------|---------------|
| **Clarity issues** | Task packet or protocol wording that was ambiguous — quote exact text |
| **Missing rules** | Situation where no guidance existed — what rule should be added? |
| **False positives** | Protocol rule that triggered but wasn't relevant — which rule, why |
| **Suggestions** | Process improvement, tool gap, or protocol enhancement idea |

**Purpose:** System self-improvement loop. BECCA aggregates all Prompt Feedback during CLOSE. If 3+ Ants independently report the same issue, it becomes a priority fix for protocol/templates. This is how NEO gets smarter over time.

**If nothing to report:** Write `N/A — no feedback this task.` — do NOT omit the section.

**Important:** Prompt Feedback does NOT affect the task's PASS/FAIL verdict. An Ant with legitimate complaints about the protocol still passes if the work is good. Ghost validates the feedback is real (not filler) but does not reject over feedback content.

---

## 7g) Color Expert Output Requirements

**Used by:** 🎨 Color Expert Ant ONLY. These outputs supplement the standard ANT_REPORT sections.

### Lab Proof Pack (in DISCOVERY — from LAB state)

```markdown
## LAB PROOF PACK

| Check | Result |
|-------|--------|
| Validation surface checked | YES — <validation surface name> |
| Modes tested | Light + Dark (screenshots attached) |
| Golden pages scanned | <list of routes checked> |

### Issues Found

| # | Element | Mode | Current Ratio | Required | Source |
|---|---------|------|---------------|----------|--------|
| 1 | <what user sees> | <light/dark> | <fg on bg = ratio:1> | >= 4.5:1 | <file:line> |
```

### Prescription (in FOOTPRINT — one per change)

```markdown
## PRESCRIPTION

ELEMENT:     <what user sees>
MODE:        <light/dark/both>
SOURCE:      <which file/variable wins in computed styles>
PRECEDENCE:  <file:line that currently wins>
CURRENT:     <fg> on <bg> = <ratio>:1
TARGET:      <new fg/bg> = <ratio>:1
CHANGE:      <variable/property> old -> new
WHY:         <readability + hierarchy intent>
BLAST RADIUS: <what else will change>
ROLLBACK:    git reset --hard HEAD~1 + file backup restore
```

### CSS Precedence Proof (in FOOTPRINT — one per change)

```markdown
## PRECEDENCE PROOF

Element: <CSS selector>
Mode: <light/dark>
Computed Style Panel shows:
  <property>: <value>  <- from <file>:<line>
  (struck-through: <value> from <other-file>:<line>)
Winner: <file>:<line>
```

### Color Fix Applied (in PATCH — one per change)

```markdown
## COLOR FIX APPLIED

Files touched:
- <file>

Change:
- <old> -> <new>

Proof:
- Validation surface: Both modes validated
- Screenshots: Light + Dark
- Contrast: <before ratio> -> <after ratio>
- CSS Precedence: Verified via DevTools computed styles
- Visual/a11y tests: PASS/FAIL
- Build: PASS/FAIL

Rollback:
- Git: git reset --hard HEAD~1
- File backup: <backup path>
```

### Color Expert Pheromone (in Section 9 — Risks)

```markdown
PHEROMONE: THEME_COLORS
SEVERITY: <MEDIUM for theme files / HIGH for main theme file>
TARGET: <file>
WARNING: Theme tokens affect entire app. Verified all modes + contrast + build + tests.
CHECKPOINT: <branch/commit + backup folder path>
```

**Max 3 changes per run.** If the Color Expert has more issues to fix, they go into pheromones as follow-up work for the next run.

---

## 8) Rejection Triggers

If ANY of these are missing, output MUST be `🔑 REJECTED`:

| Missing Element | Rejection Message |
|-----------------|-------------------|
| NEO_STATE line | `🔑 REJECTED: Missing state declaration` |
| ANT_TYPE in report header | `🔑 REJECTED: Missing Ant Type classification` |
| EVIDENCE section | `🔑 REJECTED: No evidence provided` |
| Verifiable paths | `🔑 REJECTED: Evidence paths not verifiable` |
| APPROVAL token | `🔑 REJECTED: Missing approval token` |
| NEXT section | `🔑 REJECTED: No next action specified` |
| Risk-specific requirements (HIGH/MED) | `🔑 REJECTED: Missing risk-level requirements` |
| Snapshot Summary at end of DISCOVERY | `🔑 REJECTED: Missing snapshot summary` |
| PHEROMONES section (even if empty) | `🔑 REJECTED: Missing pheromone section` |
| ⚫ NUCLEAR pheromone when warranted | `🔑 REJECTED: NUCLEAR condition detected but not flagged` |
| Critical surface edit without override | `🔑 REJECTED: Critical surface edited without OVERRIDE token` |
| LESSONS FOR FUTURE ANTS section missing (Section 8) | `🔑 REJECTED: Missing lessons section — knowledge transfer required` |
| HIVE CONTEXT section missing (Section 11) | `🔑 REJECTED: Missing hive mind context — Section 11 required` |
| PROMPT FEEDBACK section missing (Section 13) | `🔑 REJECTED: Missing prompt feedback — system improvement loop required` |
| Understanding Proof missing in DISCOVERY | `🔑 REJECTED: Missing understanding proof — LAW 1 requires evidence of comprehension` |
| Data Op Classification missing in FOOTPRINT | `🔑 REJECTED: Missing data operation classification — required for all tasks` |
| BACKUP proof missing when data ops present | `🔑 REJECTED: Data operations present but no backup proof — LAW 2 violation` |
| BACKUP APPROVED token missing when required | `🔑 REJECTED: BACKUP gate skipped — V-09 violation` |
| Write semantics not declared for data ops | `🔑 REJECTED: Missing write semantics (PATCH/PUT/DELETE) — LAW 3 requires explicit declaration` |

---

## Quick Reference

```
┌─────────────────────────────────────────────────────────────────────────────┐
│  NEO-OUTPUTS v1.8.0 — QUICK REFERENCE                                      │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  EVERY OUTPUT MUST HAVE:                                                    │
│  • NEO_STATE header                                                         │
│  • ANT_TYPE (report header)                                                 │
│  • EVIDENCE section (verifiable paths)                                      │
│  • PHEROMONES section (even if "none emitted")                              │
│  • APPROVAL token (🔑)                                                      │
│  • NEXT section                                                             │
│                                                                             │
│  OUTPUT FILES (all under <PROJECT>/.neo/):                                  │
│  • Ant Report → .neo/outbox/ants/ANT_REPORT_<TASK_ID>.md                  │
│  • Test Report → .neo/outbox/ants/TEST_REPORT_<TASK_ID>.md (Debugger)     │
│  • Ghost Review → .neo/outbox/ghost/GHOST_REVIEW_<TASK_ID>.md             │
│  • Inspector Report → .neo/outbox/inspector/INSPECTOR_REPORT_<TASK_ID>.md │
│  • Task Packet → .neo/inbox/TASK_<TASK_ID>.md                             │
│  • Gate Log → .neo/audit/gate-logs/GATE_LOG_<TASK_ID>.md                  │
│  • Operator Manual → .neo/OPERATOR_MANUAL_<PROJECT>.md                    │
│                                                                             │
│  SNAPSHOT SUMMARY: Required at end of DISCOVERY (5 lines)                   │
│  PHEROMONES: Required in every report (Section 7c format)                   │
│  ⚫ NUCLEAR: Missing = auto REJECT                                          │
│                                                                             │
│  SURGICAL PROTOCOL (Section 7d):                                            │
│  • Understanding Proof → DISCOVERY (Section 2) — LAW 1                     │
│  • Data Op Classification → FOOTPRINT (Section 3) — always required        │
│  • Backup Proof → Section 3b — conditional (data ops only) — LAW 2         │
│  • BACKUP gate in Gate Log → Section 10 — conditional                      │
│  • Ghost Section 5c → Surgical Protocol Compliance check                   │
│                                                                             │
│  LESSONS (Section 8): Required in every report — knowledge transfer        │
│  • What worked, gotchas, advice, verification patterns, protocol tips      │
│  • Missing = REJECTED                                                       │
│                                                                             │
│  PROMPT FEEDBACK (Section 13): Required in every report — system feedback  │
│  • Clarity issues, missing rules, false positives, suggestions             │
│  • Does NOT affect PASS/FAIL — Ghost validates but doesn't reject on content│
│  • BECCA aggregates: 3+ Ants same issue = priority fix                     │
│  • Missing section = REJECTED                                               │
│                                                                             │
│  COLOR EXPERT (Section 7g): Specialized outputs for 🎨 Color Expert Ant   │
│  • Lab Proof Pack, Prescription, CSS Precedence Proof                     │
│  • Color Fix Applied, THEME_COLORS pheromone                              │
│  • Max 3 changes per run                                                   │
│                                                                             │
│  MISSING FIELDS = REJECTED                                                  │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Changelog

### [1.8.0] 2026-02-11
- NEW Section 7g: Color Expert Output Requirements — specialized formats for 🎨 Color Expert Ant
- Lab Proof Pack format (validation surface, modes, golden pages, issues)
- Prescription format (element, mode, source, precedence, ratios, change, blast radius, rollback)
- CSS Precedence Proof format (computed styles evidence)
- Color Fix Applied format (files, change, proof, rollback)
- THEME_COLORS pheromone format (MEDIUM for theme files, HIGH for main theme)
- Max 3 changes per run enforced in output contract
- Quick Reference updated with Color Expert section
- ALL additions are MANUAL ONLY — no automation

### [1.7.0] 2026-02-10
- NEW Section 13: PROMPT FEEDBACK — system self-improvement loop from Colony OS
- 4 feedback categories: clarity issues, missing rules, false positives, suggestions
- Section 7f: Prompt Feedback output format specification with examples
- Ant Report gains Section 13 (no renumbering — appended after Handoff)
- Rejection trigger: missing PROMPT FEEDBACK section = auto REJECT
- Prompt Feedback does NOT affect task PASS/FAIL verdict
- BECCA aggregates: 3+ Ants same issue = priority protocol fix
- Quick Reference: PROMPT FEEDBACK requirement added
- ALL additions are MANUAL ONLY — no automation

### [1.6.0] 2026-02-10
- NEW Section 8: LESSONS FOR FUTURE ANTS — knowledge transfer from Colony OS
- 5 lesson categories: what worked, fragile/surprising, approach advice, verification pattern, protocol tip
- Section 7e: Lessons output format specification with examples
- Ant Report renumbered: Risks=9 (was 8), Gate Log=10 (was 9), Hive Context=11 (was 10), Handoff=12 (was 11)
- Ghost Review reference updated: "Section 11 present" (was Section 10)
- Rejection trigger: missing LESSONS section = auto REJECT
- Rejection trigger: HIVE CONTEXT now Section 11 (was 10)
- Quick Reference: Gate Log reference updated to Section 10, LESSONS requirement added
- ALL additions are MANUAL ONLY — no automation

### [1.5.0] 2026-02-10
- Section numbering alignment: Ant Report now uses Header (unnumbered) + Sections 1–11
- Previously: Header was Section 1, sections ran 1–12. Now matches template numbering.
- All section references updated: Hive Context = Section 10 (was 11), Handoff = Section 11 (was 12)
- Rejection trigger updated: "Section 10 required" (was Section 11)
- Ghost Review reference updated: "Section 10 present" (was Section 11)
- Quick Reference updated with aligned section numbers
- NO functional changes — numbering alignment only

### [1.4.0] 2026-02-10
- Surgical Protocol outputs: Section 7d (Understanding Proof, Data Op Classification, Backup Proof formats)
- Ant Report Section 3: Understanding Proof added to Discovery Findings purpose
- Ant Report Section 4: Data Op Classification table added to Footprint purpose
- Ant Report Section 4b: NEW — Backup Proof (conditional, LAW 2)
- Ant Report Section 10: BACKUP gate noted in Gate Log
- Ghost Review Section 5c: NEW — Surgical Protocol Compliance
- Gate Log: BACKUP gate documented as conditional entry
- File tree: backup_proof.txt evidence path + OPERATOR_MANUAL added
- 5 new rejection triggers: understanding proof, data op classification, backup proof, BACKUP token, write semantics
- Quick Reference updated with surgical protocol summary
- ALL additions are MANUAL ONLY — no automation

### [1.3.0] 2026-02-10
- Ant Report Section 10: HIVE CONTEXT added (previous tasks, pheromones, traffic per file)
- Ant Report renumbered: Handoff is now Section 11 (was 10)
- Ghost Review Section 5b: Hive Mind Compliance added
- Project file paths: .neo/index/ directory added
- New rejection trigger: missing HIVE CONTEXT section
- Index output files documented in file path tree
- Updated Quick Reference version
- ALL additions are MANUAL ONLY — no automation

### [1.2.0] 2026-02-09
- Section 7: Debugger Test Report (TEST_REPORT) — diagnostic output for 🐛 Debugger Ant
- Section 7b: Snapshot Summary — required 5-line summary at end of DISCOVERY
- Section 7c: Pheromone Output Format — structured warning markers in reports
- New rejection triggers: missing snapshot summary, missing pheromone section, untagged NUCLEAR, critical surface without override
- Updated Quick Reference with new output types and requirements
- ALL additions are MANUAL ONLY — no automation

### [1.1.0] 2026-02-09
- Added Ant Type as required field in Task Packet and Ant Report header
- Ghost Review gains Section 4b: Ant Type Validation (type match + risk requirements)
- New rejection triggers: missing ANT_TYPE, missing risk-level requirements
- Updated all section tables with Ant Type references

### [1.0.0] 2026-02-09
- Initial release
- Adapted from IAMBecca IAMBECCA-OUTPUTS.md v1.5.0
- Universal output skeleton
- 5 output types: Ant Report, Ghost Review, Inspector Report, Task Packet, Gate Log
- Rejection triggers for missing fields
