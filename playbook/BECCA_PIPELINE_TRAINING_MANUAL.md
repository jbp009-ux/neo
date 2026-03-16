# NEO BECCA Pipeline — Human Training Manual

> **Version:** 1.0.0
> **Date:** 2026-03-02
> **Audience:** Human operators learning to run the NEO governance pipeline
> **Prerequisite:** Access to a governed project with `.neo/` directory initialized

---

## TABLE OF CONTENTS

1. [What Is NEO?](#1-what-is-neo)
2. [The 4 Roles](#2-the-4-roles)
3. [Your Role as Operator](#3-your-role-as-operator)
4. [The Complete Pipeline Flow](#4-the-complete-pipeline-flow)
5. [Phase 1: RECON — Starting a Run](#5-phase-1-recon--starting-a-run)
6. [Phase 2: SCOUT — Surveying the Work](#6-phase-2-scout--surveying-the-work)
7. [Phase 3: PLAN (Conditional)](#7-phase-3-plan-conditional)
8. [Phase 4: ANT — Executing Tasks](#8-phase-4-ant--executing-tasks)
9. [Phase 5: GHOST — Reviewing Work](#9-phase-5-ghost--reviewing-work)
10. [Phase 6: INSPECTOR — Auditing Compliance](#10-phase-6-inspector--auditing-compliance)
11. [Phase 7: VERIFY & CLOSE — Finishing a Run](#11-phase-7-verify--close--finishing-a-run)
12. [Gate Tokens — Your Approval Language](#12-gate-tokens--your-approval-language)
13. [Stop Conditions — When Everything Halts](#13-stop-conditions--when-everything-halts)
14. [The Card System (CDEX)](#14-the-card-system-cdex)
15. [The Hive Mind — Institutional Memory](#15-the-hive-mind--institutional-memory)
16. [Rejection & Escalation — What Happens When Things Fail](#16-rejection--escalation--what-happens-when-things-fail)
17. [NUCLEAR — The Hard Halt](#17-nuclear--the-hard-halt)
18. [Project Structure — Files You'll See](#18-project-structure--files-youll-see)
19. [Operator Commands — Quick Reference](#19-operator-commands--quick-reference)
20. [Full Run Walkthrough — Step by Step](#20-full-run-walkthrough--step-by-step)
21. [Common Scenarios & How to Handle Them](#21-common-scenarios--how-to-handle-them)
22. [Troubleshooting](#22-troubleshooting)
23. [Glossary](#23-glossary)

---

## 1. WHAT IS NEO?

NEO is a **manual-only AI governance pipeline** that ensures every code change to your SaaS product goes through structured approval, evidence capture, and quality verification.

**The core promise:** Nothing happens without your explicit approval. Every change is understood before it's made, backed up before it's touched, and verified after it's applied.

### Why Does NEO Exist?

When AI writes code for production SaaS systems serving thousands of users:
- A single bad change can break things for every customer
- AI can hallucinate evidence ("tests passed" when they didn't)
- Scope creep silently adds unrequested changes
- Security boundaries get crossed without anyone noticing

NEO prevents all of this through **structured gates** — checkpoints where YOU review and approve before anything moves forward.

### The Three Laws of Surgical Change

Every change in NEO follows three non-negotiable laws:

| Law | Rule | Why |
|-----|------|-----|
| **LAW 1** | Understand before touching | Prove you know what the code does, why it was written that way, and what could break |
| **LAW 2** | Backup data before changing it | Every data operation has a verified backup + restore path |
| **LAW 3** | Minimum effective change | Only change what's needed. No "while I'm here" improvements |

---

## 2. THE 4 ROLES

NEO uses four specialized AI roles. Each has strict boundaries — they cannot do each other's jobs.

| Role | Icon | Job | Can Write Code? | Can Review? | Can Audit? |
|------|------|-----|-----------------|-------------|------------|
| **BECCA** | 👑 | Orchestrator — starts runs, dispatches roles, tracks state, closes runs | **NO** | **NO** | **NO** |
| **ANT** | 🐜 | Worker — reads code, proposes changes, applies patches, runs tests | **YES** | **NO** | **NO** |
| **GHOST** | 👻 | Reviewer — validates evidence, catches lies, grades quality | **NO** | **YES** | **NO** |
| **INSPECTOR** | 🔍 | Auditor — audits compliance, drift, security violations | **NO** | **NO** | **YES** |

### Key Principle: Separation of Concerns

- BECCA **organizes** but never writes code or reviews
- Ant **executes** but never reviews its own work
- Ghost **reviews** but never fixes issues it finds
- Inspector **audits** but never proposes fixes

This separation prevents the AI from marking its own homework.

---

## 3. YOUR ROLE AS OPERATOR

You are the **human in the loop**. The pipeline does nothing without you.

### What You Do

1. **Start runs** — Say `BECCA ACTIVATE` to begin
2. **Activate roles** — Say `I AM` to move to the next phase
3. **Approve gates** — Issue gate tokens like `🔑 FOOTPRINT APPROVED` to unlock the next step
4. **Review outputs** — Read what each role produces before approving
5. **Handle stops** — When the pipeline halts, decide what to do
6. **Make escalation decisions** — When tasks fail repeatedly, choose the resolution path

### What You Don't Do

- You don't write code (Ant does that)
- You don't need to catch every bug (Ghost and Inspector do that)
- You don't track state manually (BECCA handles all bookkeeping)

### The Golden Rule

> **Read before you approve.** Every gate token you issue is your signature saying "I reviewed this and it's acceptable." Never issue tokens blindly.

---

## 4. THE COMPLETE PIPELINE FLOW

Here's the full lifecycle of a NEO run:

```
YOU: "BECCA ACTIVATE"
  │
  ▼
┌─────────────────────────────────────────────┐
│ PHASE 1: RECON                              │
│ BECCA reads state, checks health,           │
│ reports system vitals                        │
│                                             │
│ Output: RECON summary + health status       │
│ YOU SEE: ⏸️ Waiting for: I AM (Scout)       │
└──────────────────┬──────────────────────────┘
                   │ You say: "I AM"
                   ▼
┌─────────────────────────────────────────────┐
│ PHASE 2: SCOUT                              │
│ BECCA surveys codebase (read-only),         │
│ creates TODO with task list                 │
│                                             │
│ Output: TODO with tasks, Ant types, files   │
│ YOU SEE: ⏸️ Waiting for: I AM (Ant)         │
│   — OR —                                    │
│ ⏸️ Planning needed. Activate Planner? → I AM│
└──────────────────┬──────────────────────────┘
                   │ You say: "I AM"
                   ▼
┌─────────────────────────────────────────────┐
│ PHASE 3: PLAN (conditional — only if        │
│   tasks > 3, files > 3/task, or inbox docs) │
│ Planner decomposes into dependency map      │
│                                             │
│ Output: RUN_PLAN + enriched TASK_PACKETs    │
│ YOU SEE: ⏸️ RUN PLAN OK? → I AM             │
└──────────────────┬──────────────────────────┘
                   │ You say: "I AM"
                   ▼
┌─────────────────────────────────────────────┐
│ PHASE 4: ANT PIPELINE (per task)            │
│                                             │
│   CHECKPOINT → DISCOVERY → FOOTPRINT →      │
│   [BACKUP] → PATCH → VERIFY → REPORT       │
│                                             │
│ (Each step has its own gate — see Section 8)│
└──────────────────┬──────────────────────────┘
                   │ You say: "I AM"
                   ▼
┌─────────────────────────────────────────────┐
│ PHASE 5: GHOST REVIEW                       │
│ Reviews Ant's report for evidence,          │
│ completeness, honesty                       │
│                                             │
│ Output: GHOST REVIEW (8 sections)           │
│ Verdict: APPROVED / CHANGES REQUESTED /     │
│          REJECTED                           │
└──────────────────┬──────────────────────────┘
                   │ You say: "I AM"
                   ▼
┌─────────────────────────────────────────────┐
│ PHASE 6: INSPECTOR AUDIT                    │
│ Audits for compliance, drift, security      │
│                                             │
│ Output: INSPECTOR REPORT (7 sections)       │
│ Verdict: PASS / PASS WITH FINDINGS / FAIL   │
└──────────────────┬──────────────────────────┘
                   │
    ┌──────────────┴──────────────┐
    │ More tasks?                  │
    │ YES → back to Phase 4       │
    │ NO → continue to Phase 7    │
    └──────────────┬──────────────┘
                   ▼
┌─────────────────────────────────────────────┐
│ PHASE 7: VERIFY + CLOSE                     │
│                                             │
│ VERIFY → CLOSE_ARCHIVE → CLOSE_ANALYTICS → │
│ CLOSE_DEVTOOLS → CLOSE_GOVERNANCE           │
│                                             │
│ Output: 🔑 RUN COMPLETE                     │
└─────────────────────────────────────────────┘
```

**Key insight:** Every box above ends with a gate. You must approve before the next box begins. This is the **Response Boundary Protocol** — ONE gate per response, no exceptions.

---

## 5. PHASE 1: RECON — Starting a Run

### How to Start

Open your AI chat (Claude) in the governed project and type:

```
BECCA ACTIVATE
```

### What BECCA Does

BECCA reads the project's current state and reports:

1. **State Check** — Reads `.neo/STATE.md` for last run number, last task ID
2. **Index Health** — Counts entries across all 6 Hive Mind indexes
3. **Pheromone Triage** — Sorts active warnings by severity (NUCLEAR → HIGH → MEDIUM → LOW)
4. **Health Trend** — Compares metrics across last 3-5 runs (first-pass rate, deficiency density, pheromone debt)
5. **Improvement Check** — Did previous run's action items get addressed?
6. **Ungoverned Changes** — Were any commits made outside the pipeline?

### What You See

BECCA outputs a **RECON SUMMARY** with:

```
SYSTEM VITALS: 🟢 HEALTHY / 🟡 WATCH / 🟠 CONCERN / 🔴 CRITICAL

Run #: <next number>
Branch: run-<number>-<date>
Active Pheromones: <count> (N NUCLEAR, N HIGH, N MEDIUM, N LOW)
Ungoverned Changes: <count or NONE>
Prior Follow-Through: <percentage>
```

The response ends with:

```
⏸️ Waiting for: I AM (Scout)
```

### What You Do

1. **Read the RECON summary** — Are there any NUCLEAR pheromones? Ungoverned changes? Critical health status?
2. **If everything looks OK** → type `I AM` to activate Scout
3. **If there are concerns** → address them first (e.g., investigate ungoverned changes)

### Health Status Guide

| Status | Meaning | Action |
|--------|---------|--------|
| 🟢 HEALTHY | Metrics stable/improving, follow-through >80% | Proceed normally |
| 🟡 WATCH | 1 declining trend OR follow-through 50-80% | Proceed, but monitor |
| 🟠 CONCERN | 2+ declining OR follow-through <50% | Review before proceeding |
| 🔴 CRITICAL | Debt growing 3+ runs OR first-pass <50% for 2+ runs | Address root causes first |

---

## 6. PHASE 2: SCOUT — Surveying the Work

### How to Activate

After RECON completes, type:

```
I AM
```

### What BECCA Does

BECCA becomes the **Flying Scout Ant** 🚁 — a read-only researcher that:

1. Surveys the codebase to understand current state
2. Reads your request/requirements
3. Creates a **TODO** with sequential task IDs
4. Assigns an **Ant Type** to each task (the right specialist for the job)
5. Checks if planning is needed (tasks > 3, files > 3, or inbox documents exist)

### What You See

A TODO table like:

```
| ID       | Ant Type        | Objective                          | Files         |
|----------|----------------|------------------------------------|---------------|
| TASK-001 | 🛠️ Carpenter   | Add dark mode toggle to settings   | settings.tsx  |
| TASK-002 | 🎨 Color Expert | Update color palette for dark mode | theme.ts      |
| TASK-003 | 🧰 Toolbox     | Fix build warning in header        | header.tsx    |
```

The response ends with either:

```
⏸️ Waiting for: I AM (Ant)
```
— OR (if planning is needed) —
```
⏸️ Planning needed. Activate Planner? → I AM
```

### What You Do

1. **Review the TODO** — Are the tasks right? Right Ant types? Right file targets?
2. **Modify if needed** — Tell BECCA to add, remove, or change tasks before proceeding
3. **When satisfied** → type `I AM` to start the first task (or activate Planner if prompted)

### Ant Types You'll See

| Type | Icon | Specialty | Risk Level |
|------|------|-----------|------------|
| Carpenter | 🛠️ | Building features | Standard |
| Toolbox | 🧰 | Maintenance & fixes | Standard |
| Fire Ant | 🔥 | Payment systems | **HIGH** |
| Soldier | 🛡️ | Auth & security | Medium |
| Harvester | 📊 | Data operations | Standard |
| Scout | 🚁 | Research (read-only) | Low |
| Leafcutter | 🌿 | Documentation | Low |
| Color Expert | 🎨 | Styling & design | Low |
| Figma | 🖼️ | Design implementation | Standard |
| Debugger | 🐛 | Root cause diagnosis | Standard |
| QA | 🧪 | Quality assurance | Standard |
| Board/Planner | 👔 | Strategic decomposition | Low |
| Sentinel | 🛡️ | DevTools verification (Chief) | Standard |
| Perf | ⚡ | Performance verification | Standard |
| Network | 🌐 | Network verification | Standard |

**Higher risk = more scrutiny at every gate.** Fire Ant and Soldier Ant tasks require extra attention from you during review.

---

## 7. PHASE 3: PLAN (Conditional)

This phase only activates when:
- More than 3 tasks in the TODO
- Any task targets more than 3 files
- Documents exist in `.neo/inbox/ideas/`

### What Happens

The **Planner Ant** 👔 decomposes work into a dependency-mapped sequence:

1. **SKELETON PASS** — High-level task ordering with dependencies
   - Gate: `⏸️ PLAN SKELETON OK?`
2. **DETAIL PASS** — Per-batch enrichment with specific task packets
   - Gate per batch: `⏸️ TASK BATCH <N> OK?`
3. **Final Plan** — Complete RUN_PLAN
   - Gate: `⏸️ RUN PLAN OK? Activate first Ant? → I AM`

### What You Review

- **Task ordering** — Do dependencies make sense? (e.g., data model before UI)
- **Task scope** — Is each task ≤5 target files?
- **Batch grouping** — Are related tasks grouped logically?

---

## 8. PHASE 4: ANT — Executing Tasks

This is where code actually gets written. Each task goes through **7 sequential steps**, each with its own gate.

### Step 1: CHECKPOINT

**What happens:** Ant creates a git safety checkpoint before touching anything.

**What you see:**
```
CHECKPOINT PROOF:
  Branch: run-<N>-task-<NNN>
  Commit: <hash>
  Files: <count> staged
```

**Gate prompt:** `⏸️ Proceeding to DISCOVERY`

**What you check:** Branch was created? You're on the right project?

---

### Step 2: DISCOVERY

**What happens:** Ant investigates the codebase to understand current state.

**What you see:**
- **ONE QUESTION** — A single focused question about the codebase, answered with evidence
- **HIVE EVIDENCE PROOF** — Table showing what each of the 7 indexes said about the target files
- **UNDERSTANDING PROOF** — 4 checks: current behavior, design intent, hidden constraints, blast radius
- **SNAPSHOT SUMMARY** — Root cause, affected files, proposed approach, risk, estimated scope
- **BUDGET LEDGER** — How many files read (max 5), lines shown (max 200), greps run (max 10)

**Gate prompt:** `⏸️ Gate: 🔑 DISCOVERY OK?`

**What you check:**
- Does the Ant understand what it's about to change?
- Is the one question relevant and well-answered?
- Are there any NUCLEAR pheromones on target files?
- Is the budget within limits?

**Your response:** `🔑 DISCOVERY APPROVED`

> **WARNING:** The token must be EXACT. "Looks good" or "approved" won't work. Use the exact 🔑-prefixed token.

---

### Step 3: FOOTPRINT

**What happens:** Ant proposes exactly what it will change — file by file, operation by operation.

**What you see:**
- **FOOTPRINT TABLE** — Every file, operation type (CREATE/EDIT/DELETE), write semantics, justification
- **DATA OP CLASSIFICATION** — CODE_ONLY / DATA_WRITE / MIGRATION / SEED / DELETE
- **FEATURE IMPACT** — Which user-facing features are touched, impact level (NONE/REDUCED/RELOCATED/REMOVAL)
- **CRITICAL SURFACES** — Any high-risk files flagged with ⚠️
- **RISK ASSESSMENT** — What could go wrong
- **PHEROMONES** — New warnings emitted for risks discovered

**Gate prompt:** `⏸️ Gate: 🔑 FOOTPRINT APPROVED OK?`

**What you check:**
- Are only the necessary files being touched? (No scope creep)
- Is the operation type correct? (EDIT not DELETE, PATCH not PUT)
- If critical surfaces are flagged, do they need override tokens?
- Does the feature impact look right?

**Your response:** `🔑 FOOTPRINT APPROVED`

**If critical surfaces need override:**
```
🔑 CRITICAL SURFACE OVERRIDE: auth/middleware.ts
🔑 FOOTPRINT APPROVED
```

---

### Step 4: BACKUP (Conditional)

**Only appears if data operations were classified in FOOTPRINT** (DATA_WRITE, MIGRATION, DELETE).

**What you see:**
- Backup timestamp, location, scope
- Restore method (exact commands)
- Restore test proof (actually tested, not just claimed)

**Gate prompt:** `⏸️ Gate: 🔑 BACKUP APPROVED?`

**What you check:**
- Was the backup actually created (not just claimed)?
- Was restore actually tested (not just planned)?
- Does the scope cover everything being changed?

**Your response:** `🔑 BACKUP APPROVED`

---

### Step 5: PATCH

**What happens:** Ant applies the approved changes — exactly as described in FOOTPRINT.

**What you see:**
- **Exact diffs** — Before/after for every changed file
- **TRUTHY DIFFS checklist** (7/7 must pass):
  1. Diff is real (file exists, line numbers match)
  2. Diff is complete (no "..." truncation)
  3. Diff is minimal (task-relevant only)
  4. No phantom imports
  5. No orphan exports
  6. No silent removals
  7. No scope creep
- **Deviation report** — Any changes that differ from FOOTPRINT (should be none)

**Gate prompt:** `⏸️ Gate: 🔑 PATCH APPROVED OK?`

**What you check:**
- Do the diffs match what was approved in FOOTPRINT?
- Are all 7 Truthy Diffs checks passing?
- Were there any deviations? (If yes, why?)
- Does the code look correct?

**Your response:** `🔑 PATCH APPROVED`

---

### Step 6: VERIFY

**What happens:** Ant runs tests, build, lint, and type-checks.

**What you see:**
- **Test results** — Actual command output (not claimed results)
- **Build output** — Pass/fail with evidence
- **CI/CD STATUS TABLE** — Command, expected, actual, match?
- **FEATURE INVENTORY** — File/export counts before vs after (must not decrease without override)
- **Regression check** — Did the change break anything?

**Gate prompt:** `⏸️ Gate: 🔑 VERIFY APPROVED OK?`

**What you check:**
- Do all tests pass?
- Does the build succeed?
- Is the feature inventory stable? (No unexpected decreases)
- Is there actual command output, not just "tests passed"?

**Your response:** `🔑 VERIFY APPROVED`

---

### Step 7: REPORT

**What happens:** Ant writes a structured 13-section report documenting everything.

**What you see:**
A comprehensive report with:
1. Task summary
2. Discovery findings
3. Footprint (what was changed)
4. Backup proof (if applicable)
5. Patch diffs
6. Verify results
7. Evidence links
8. Lessons learned
9. Pheromones emitted
10. Rollback plan
11. Hive context used
12. Self-assessment (honest quality score)
13. Prompt feedback (suggestions for improving NEO)
14. **CARD_RECEIPT** — Proof of which protocol cards were followed

**Gate prompt:** `⏸️ Waiting for: I AM (Ghost)`

**What you check:**
- All 13 sections present?
- CARD_RECEIPT present?
- Self-assessment looks honest? (Not inflated scores)

**Your response:** `I AM` (activates Ghost review)

---

## 9. PHASE 5: GHOST — Reviewing Work

### What Ghost Does

Ghost is the **truth verifier**. It reads the Ant's report and checks if everything is real.

Ghost performs **23 validation checks** including:

- All 13 report sections present?
- Definition of Done criteria met with evidence?
- All file paths real (not placeholder)?
- All claims backed by actual evidence?
- Hive Mind properly consulted (7 indexes with evidence)?
- SaaS safety checks completed?
- Surgical protocol followed (3 Laws)?
- CARD_RECEIPT present and valid?
- Budget within limits?
- Truthy Diffs all passing?

### Evidence Scoring

Ghost scores evidence quality 0-100%:
- **≥ 70%** → PASS
- **50-69%** → WARNING, may request changes
- **< 50%** → **AUTO REJECT** (evidence insufficient)

### Optional: Evidence Re-Execution

Ghost may ask you to re-run some of the Ant's claimed commands to verify they're real:
- **MATCH** → Evidence verified
- **SKIP** → Unverified (informational)
- **MISMATCH** → Evidence fabricated → **AUTO REJECT** (0% score)

### Verdicts

| Verdict | Meaning | Next Step |
|---------|---------|-----------|
| 🔑 GHOST APPROVED | Work is solid | → Inspector |
| 🔑 GHOST APPROVED WITH NOTES | Work is acceptable, minor issues noted | → Inspector |
| 🔑 GHOST CHANGES REQUESTED | Issues need fixing | → Back to Ant |
| 🔑 GHOST REJECTED | Significant problems | → Back to Ant |

### Auto-Reject Triggers (Immediate Rejection, No Judgment Call)

- Evidence score < 50%
- Evidence re-execution mismatch (Ant lied)
- NUCLEAR condition detected
- Any violation V-01 through V-13
- Missing CARD_RECEIPT (S-38)
- Missing CORE card without waiver (S-39)
- Missing LESSONS_INDEX in Hive proof

### What You Do

After Ghost outputs its review:
```
⏸️ Waiting for: I AM
```

1. **Read the Ghost review** — Especially the findings and verdict
2. **If APPROVED** → type `I AM` to activate Inspector
3. **If REJECTED/CHANGES REQUESTED** → type `I AM` to send back to Ant with the deficiency list

---

## 10. PHASE 6: INSPECTOR — Auditing Compliance

### What Inspector Does

Inspector audits for **standards compliance**, not code quality (that's Ghost's job).

### Inspection Types

The default is COMPLIANCE, but Inspector can run specialized audits:

| Type | Focus |
|------|-------|
| **COMPLIANCE** | Evidence completeness, report format, gate compliance |
| **DRIFT** | Did work drift from approved FOOTPRINT? Scope creep? |
| **QUALITY** | Code quality, test coverage, documentation |
| **NUCLEAR** | Tenant isolation, credential exposure, security boundaries |
| **PHEROMONE** | All risks properly marked with pheromones? |
| **HIVE** | Index consistency (9-point check) |
| **SURGICAL** | 3 Laws followed? (10-point check) |
| **SAAS_SAFETY** | Tenant isolation, secrets, data classification (12-point check) |

### Verdicts

| Verdict | Meaning | Next Step |
|---------|---------|-----------|
| 🔑 INSPECTOR PASS | Fully compliant | → Next task or VERIFY |
| 🔑 INSPECTOR PASS WITH FINDINGS | Compliant, issues noted | → Next task or VERIFY |
| 🔑 INSPECTOR FAIL | Non-compliant | → Back to Ant |

### What You Do

After Inspector outputs its report:
```
⏸️ Waiting for: I AM
```

1. **Read the Inspector report** — Especially any findings
2. **If PASS + more tasks remain** → type `I AM` to start next Ant task
3. **If PASS + all tasks done** → type `I AM` to activate BECCA VERIFY
4. **If FAIL** → type `I AM` to send back to Ant

---

## 11. PHASE 7: VERIFY & CLOSE — Finishing a Run

### VERIFY

Once all tasks have passed Ant + Ghost + Inspector, BECCA runs final verification:

- **Regression check** — Did any later task break an earlier task's work?
- **Completeness check** — All tasks show ✅ across all three stages?
- **Consistency check** — Does the project still build and pass tests?

**Verdicts:**
- ✅ VERIFIED → Proceed to CLOSE
- ❌ REGRESSION → Fix required (dispatch fix Ant)
- ❌ INCOMPLETE → Unresolved findings

### CLOSE (4 Cards)

CLOSE is **mandatory** — it runs automatically after VERIFY. Each card produces output and gates:

#### Card 1: ARCHIVE
- Archives the TODO
- Updates STATE.md (run counter, last task ID)
- Updates RUN_INDEX.md (run metadata)
- Updates all 6 Hive Mind indexes

Gate: `⏸️ ARCHIVE complete. Loading ANALYTICS.`

#### Card 2: ANALYTICS
- Computes run metrics (first-pass rate, deficiency density, pheromone debt)
- Detects band-aid patterns (chronic issues being patched, not solved)
- Runs PIPELINE EVAL (19 governance checks, Grade A/B/C/D)
- Checks if Operator Manual needs updating
- Aggregates prompt feedback from all Ant reports

Gate: `⏸️ ANALYTICS complete. Loading DEVTOOLS.`

#### Card 3: DEVTOOLS (Conditional)
- Checks if browser verification is needed based on what changed
- If triggered: dispatches Sentinel Ant for DevTools verification
- May dispatch specialists (Perf Ant, Network Ant) as needed

Gate: `⏸️ DEVTOOLS complete. Loading GOVERNANCE.`

#### Card 4: GOVERNANCE
- GPS Integrity Audit (were all cards followed correctly?)
- Rotating Deep Scan (1 of 8 system areas per run)
- Git merge (rebase onto main)
- Sign off

**Final output:** `🔑 RUN COMPLETE`

### What You Do During CLOSE

For each CLOSE card, type `continue` (or `I AM`) when prompted to proceed to the next card. Review the metrics and findings as they appear.

---

## 12. GATE TOKENS — Your Approval Language

Gate tokens are **exact strings** that you type to approve pipeline transitions. They must be **verbatim** — no paraphrasing.

### Standard Gate Tokens

| Token | When to Use |
|-------|-------------|
| `🔑 DISCOVERY APPROVED` | After reviewing Ant's discovery findings |
| `🔑 FOOTPRINT APPROVED` | After reviewing Ant's proposed changes |
| `🔑 BACKUP APPROVED` | After reviewing backup proof (data ops only) |
| `🔑 PATCH APPROVED` | After reviewing applied changes |
| `🔑 VERIFY APPROVED` | After reviewing test/build results |

### Override Tokens

| Token | When to Use |
|-------|-------------|
| `🔑 CRITICAL SURFACE OVERRIDE: <file>` | Allow editing a high-risk file |
| `🔑 FEATURE REMOVAL OVERRIDE: <feature>` | Allow deleting a protected feature |
| `🔑 PRODUCTION CONFIRMED` | Confirm destructive operation on production |
| `🔑 NUCLEAR RESOLVED: <action>` | Clear a NUCLEAR halt (very serious) |
| `🔑 DISCOVERY EXPANSION APPROVED` | Allow Ant to exceed evidence budget |
| `🔑 CROSS-PROJECT READ: <path>` | Allow reading files from another project |

### Activation Commands

| Command | When to Use |
|---------|-------------|
| `BECCA ACTIVATE` | Start a new run |
| `I AM` | Activate the next role in the pipeline |

### What Counts as INVALID

These will **not** work as approvals:

- "looks good" ❌
- "approved" ❌
- "ok" ❌
- "yes" ❌
- "LGTM" ❌
- "go ahead" ❌
- Any token without the 🔑 prefix ❌
- Any paraphrased version of a token ❌

If you use an invalid token, the pipeline will STOP and ask you for the exact token. This is a safety feature (V-12: Token Normalization violation).

---

## 13. STOP CONDITIONS — When Everything Halts

Stop conditions (S-01 through S-45) are automatic halts triggered when something goes wrong. **STOP means STOP** — no work continues until resolved.

### Most Common Stops You'll Encounter

| Stop | Trigger | What You Do |
|------|---------|-------------|
| **S-07** | Cross-tenant query detected | **NUCLEAR** — Issue `🔑 NUCLEAR RESOLVED: <action>` only after confirming safety |
| **S-08** | Tenant isolation breach | **NUCLEAR** — Same as above |
| **S-12** | Hardcoded secrets found | **NUCLEAR** — Ensure secrets are removed, then resolve |
| **S-14** | Evidence budget exceeded | Issue `🔑 DISCOVERY EXPANSION APPROVED` if justified |
| **S-25** | File path outside project lock | Verify Ant is working in the right project |
| **S-29** | Feature count decreased | Issue `🔑 FEATURE REMOVAL OVERRIDE: <feature>` if intentional |
| **S-35** | Missing TARGET_ENVIRONMENT | Ant must declare which environment it's targeting |
| **S-36** | Production destructive without confirm | Issue `🔑 PRODUCTION CONFIRMED` if you really intend production changes |

### How to Clear a STOP

Standard STOPs: Issue `🔑 CONTINUE` or the specific gate token needed.

NUCLEAR STOPs: Issue `🔑 NUCLEAR RESOLVED: <action>` (only after genuine resolution).

### The STOP MEANS STOP Doctrine

> "Acknowledge and continue" is a **violation** (V-06). You cannot say "I see the warning but let's keep going." You must actually resolve the issue.

---

## 14. THE CARD SYSTEM (CDEX)

### What Are Cards?

Protocol cards are **phase-specific instruction sheets** (50-160 lines each) that replace loading entire role files (1,000-2,000 lines). Each card contains only what the AI needs at that exact phase.

### Why Cards Matter to You

Cards create **predictable structure**. When you see Ant in the DISCOVERY phase, you know exactly what outputs to expect because the DISCOVERY card specifies them. This makes your review easier and more consistent.

### Card Deck

Each run gets a **CARD DECK** (ID: `CD-<RUN_NUMBER>`) listing all cards that should be executed. Every agent output includes a **CARD_RECEIPT** proving which cards were followed.

### What to Watch For

- **Missing CARD_RECEIPT** → Ghost will AUTO REJECT (S-38)
- **CORE card skipped without waiver** → NUCLEAR, AUTO REJECT (S-39)
- **Card waiver** — If a card was legitimately skipped (e.g., no backup needed for code-only changes), it should have a formal CARD_WAIVER with reason and risk assessment

---

## 15. THE HIVE MIND — Institutional Memory

The Hive Mind is NEO's **institutional memory** — it accumulates knowledge across runs so the pipeline gets smarter over time.

### The 6 Local Indexes

| Index | What It Tracks | Why It Matters |
|-------|---------------|----------------|
| **MASTER_INDEX** | Every completed task (ID, files, outcome) | Shows project history at a glance |
| **FILE_OWNERSHIP** | Last Ant to touch each file + when + outcome | Prevents blind changes to unfamiliar code |
| **PHEROMONE_REGISTRY** | Active warnings by severity | Alerts future Ants to known risks |
| **LESSONS_INDEX** | What worked, what didn't (scored) | Prevents repeating past mistakes |
| **REJECTION_INDEX** | All Ghost/Inspector rejections | Shows recurring quality issues |
| **FINDINGS_INDEX** | Aggregated finding types with counts | Spots systemic problems (3+ = SIGNAL, 5+ = PRIORITY) |

### The Global Index

**HIVEMIND_GLOBAL** — Cross-project patterns shared between all NEO-governed projects. When a lesson learned in Sonny applies to RIZEND, it goes here.

### What This Means for You

- **During RECON:** BECCA shows you pheromone health, lesson trends, and rejection patterns. Use this to understand your project's trajectory.
- **During DISCOVERY:** Ant must prove it checked all 7 indexes. If an index warned about a target file, the Ant must acknowledge and address it.
- **During CLOSE:** BECCA updates all indexes with the run's outcomes, keeping the memory current.

---

## 16. REJECTION & ESCALATION — What Happens When Things Fail

### Normal Rejection Flow

```
Ant submits report
  → Ghost REJECTS (evidence insufficient)
  → You say "I AM" → Ant re-activates with deficiency list
  → Ant fixes issues, re-submits
  → Ghost reviews again
```

This can happen twice (Loop 1 and Loop 2).

### Strike 3 Escalation

On the **3rd rejection** of the same task:

```
Ghost REJECTS for the 3rd time
  → STRIKE 3 triggered
  → BECCA reactivates
  → BECCA reads ALL Ghost/Inspector reviews for this task
  → BECCA presents 3 options:
```

| Option | When to Choose | What Happens |
|--------|---------------|--------------|
| **🐛 DEBUGGER** | Root cause is unclear | Debugger Ant investigates the underlying problem |
| **SPLIT** | Task is too large/complex | Task broken into smaller, more manageable pieces |
| **RE-ASSIGN** | Wrong Ant type for the job | Different specialist Ant takes over |

### Higher Escalation (Rare)

If a Debugger fix also fails, or a SPLIT still produces rejections:

| Level | Trigger | Options |
|-------|---------|---------|
| L1 | 1st-2nd rejection | Ant retries |
| L2 | 3rd rejection (Strike 3) | DEBUGGER / SPLIT / RE-ASSIGN |
| L3 | 2nd Debugger or SPLIT fails | Repeat L2 options or HALT |
| L4 | Continued failure | **HALT** — Operator chooses: (A) Manual resolution, (B) Abort task, (C) Abort run, (D) Prompt Architect review |

---

## 17. NUCLEAR — The Hard Halt

### What Triggers NUCLEAR

NUCLEAR (⚫) is the highest severity — **above critical**. It triggers on:

- **Cross-tenant data access** — One customer's data accessible to another
- **Tenant isolation breach** — Security boundary between tenants violated
- **Credential exposure** — Secrets, API keys, passwords in code
- **Security boundary bypass** — Auth or permission checks circumvented
- **Data deletion without safeguard** — User data deleted without backup/confirmation
- **Production environment contamination** — Test data or operations hitting production

### What Happens

1. **ALL WORK STOPS IMMEDIATELY** — Not just the current task, everything
2. Ant emits ⚫ NUCLEAR pheromone
3. A **NUCLEAR INCIDENT REPORT** is presented to you with:
   - What triggered it
   - Which files/operations are affected
   - Blast radius (how many users/features impacted)
   - Immediate risk assessment
   - Recommended action
4. **Nothing moves forward** until you resolve it

### How to Resolve

After investigating and confirming the issue is handled:

```
🔑 NUCLEAR RESOLVED: <specific action taken>
```

Example:
```
🔑 NUCLEAR RESOLVED: Removed hardcoded API key from config.ts, rotated key in Firebase console
```

### What You Cannot Do

- Issue `🔑 CONTINUE` to bypass NUCLEAR (V-13 violation)
- Acknowledge it and keep working (V-06 violation)
- Ignore it and move to the next task (V-01 violation)

> **NUCLEAR has no workaround.** It must be genuinely resolved. This protects your users.

---

## 18. PROJECT STRUCTURE — Files You'll See

### Your Project's `.neo/` Directory

```
your-project/
└── .neo/
    ├── STATE.md                 ← Run counter, last task ID, status
    ├── RUN_INDEX.md             ← History of all completed runs
    ├── TODO_<PROJECT>.md        ← Current run's task list (or most recent)
    │
    ├── roles/                   ← The 4 role protocols
    ├── shared/                  ← 9 shared modules
    ├── templates/               ← Report templates
    ├── cards/                   ← Protocol cards (CDEX)
    ├── prompts/                 ← Specialized role prompts
    ├── injections/              ← Safety modules (paste mid-session)
    ├── scripts/                 ← Deployment scripts
    │
    ├── inbox/                   ← Task input
    │   └── ideas/               ← Your feature ideas (Planner reads these)
    │
    ├── outbox/                  ← Task output
    │   ├── ant/                 ← Ant reports
    │   ├── ghost/               ← Ghost reviews
    │   └── inspector/           ← Inspector reports
    │
    ├── audit/                   ← Evidence files
    │   ├── screenshots/
    │   ├── test-output/
    │   └── backups/
    │
    ├── archive/                 ← Completed run TODOs
    │   ├── TODO_<PROJECT>_1.md
    │   ├── TODO_<PROJECT>_2.md
    │   └── ...
    │
    ├── runtime/                 ← Active session state
    │
    └── index/                   ← Hive Mind indexes
        ├── MASTER_INDEX.md
        ├── FILE_OWNERSHIP.md
        ├── PHEROMONE_REGISTRY/
        │   ├── NUCLEAR.md
        │   ├── HIGH.md
        │   ├── MEDIUM.md
        │   ├── LOW.md
        │   └── INFO.md
        ├── LESSONS_INDEX/
        │   ├── general.md
        │   └── <domain>.md
        ├── REJECTION_INDEX.md
        └── FINDINGS_INDEX.md
```

### Key Files to Know

| File | Purpose | Who Writes It |
|------|---------|---------------|
| `STATE.md` | Run counter + status | BECCA |
| `RUN_INDEX.md` | Run history with metrics | BECCA |
| `TODO_<PROJECT>.md` | Current task list | BECCA (creates), all roles (update) |
| `outbox/ant/*.md` | Ant task reports | Ant |
| `outbox/ghost/*.md` | Ghost review reports | Ghost |
| `outbox/inspector/*.md` | Inspector audit reports | Inspector |
| `inbox/ideas/*.md` | Your feature ideas | You (the operator) |

---

## 19. OPERATOR COMMANDS — QUICK REFERENCE

### Starting & Activating

| Command | What It Does |
|---------|--------------|
| `BECCA ACTIVATE` | Start a new run (triggers RECON) |
| `I AM` | Activate the next role in the pipeline |

### Gate Approval Tokens

| Token | Approves |
|-------|----------|
| `🔑 DISCOVERY APPROVED` | Ant's investigation findings |
| `🔑 FOOTPRINT APPROVED` | Ant's proposed change plan |
| `🔑 BACKUP APPROVED` | Ant's backup proof (data ops only) |
| `🔑 PATCH APPROVED` | Ant's applied changes |
| `🔑 VERIFY APPROVED` | Ant's test/build results |

### Override Tokens

| Token | Overrides |
|-------|-----------|
| `🔑 CRITICAL SURFACE OVERRIDE: <file>` | Edit protection on a high-risk file |
| `🔑 FEATURE REMOVAL OVERRIDE: <feature>` | Protection against feature deletion |
| `🔑 PRODUCTION CONFIRMED` | Safety gate for production operations |
| `🔑 NUCLEAR RESOLVED: <action>` | NUCLEAR hard halt |
| `🔑 DISCOVERY EXPANSION APPROVED` | Evidence budget limits |
| `🔑 CROSS-PROJECT READ: <path>` | Project lock (read-only cross-project) |

### Pipeline Control

| Command | What It Does |
|---------|--------------|
| `🔑 CONTINUE` | Resume after a non-NUCLEAR STOP |
| `SKIP INSPECTOR` | Skip Inspector for a task (you accept the risk) |
| `SKIP GHOST` | Skip Ghost review (rare — you become the reviewer) |
| `PAUSE` | Halt current role, resume later |
| `ABORT <TASK_ID>` | Cancel a specific task |
| `ABORT ALL` | Cancel the entire run |

---

## 20. FULL RUN WALKTHROUGH — Step by Step

Here's exactly what a complete 2-task run looks like, with every operator interaction:

### Run Start

```
YOU:     BECCA ACTIVATE
```

```
BECCA:   [RECON SUMMARY]
         Run #5, Branch: run-5-2026-03-02
         System Vitals: 🟢 HEALTHY
         Active Pheromones: 2 (0 NUCLEAR, 1 HIGH, 1 MEDIUM)
         Ungoverned Changes: NONE
         Prior Follow-Through: 85%

         ⏸️ Waiting for: I AM (Scout)
```

```
YOU:     I AM
```

### Scout Phase

```
BECCA:   [SCOUT SURVEY]
         TODO:
         | TASK-014 | 🛠️ Carpenter | Add logout button to navbar    | navbar.tsx |
         | TASK-015 | 🧰 Toolbox   | Fix date format in user profile | profile.tsx |

         ⏸️ Waiting for: I AM (Ant)
```

```
YOU:     I AM
```

### Task 1: Ant Pipeline

```
ANT:     [CHECKPOINT]
         Branch: run-5-task-014
         ⏸️ Proceeding to DISCOVERY
```

```
ANT:     [DISCOVERY]
         ONE QUESTION: Where is the current navbar auth state managed?
         ANSWER: navbar.tsx:42 uses useAuth() from auth-context.tsx:15
         HIVE PROOF: [7-row table with index findings]
         UNDERSTANDING PROOF: [4 checks all passing]
         BUDGET: 3/5 files, 87/200 lines, 4/10 greps

         ⏸️ Gate: 🔑 DISCOVERY OK?
```

```
YOU:     🔑 DISCOVERY APPROVED
```

```
ANT:     [FOOTPRINT]
         | File | Op | Semantics | Justification |
         | navbar.tsx | EDIT | PATCH | Add logout button next to user menu |
         DATA OPS: CODE_ONLY
         FEATURE IMPACT: navbar → 🟡 REDUCED (button added, existing features unchanged)

         ⏸️ Gate: 🔑 FOOTPRINT APPROVED OK?
```

```
YOU:     🔑 FOOTPRINT APPROVED
```

```
ANT:     [PATCH]
         --- navbar.tsx (before)
         +++ navbar.tsx (after)
         @@ -42,6 +42,12 @@
           <UserMenu />
         + <LogoutButton onClick={handleLogout} />

         TRUTHY DIFFS: 7/7 ✅

         ⏸️ Gate: 🔑 PATCH APPROVED OK?
```

```
YOU:     🔑 PATCH APPROVED
```

```
ANT:     [VERIFY]
         $ npm test -- --run          → 47/47 PASS ✅
         $ npm run build              → SUCCESS ✅
         $ npm run lint               → 0 errors ✅
         FEATURE INVENTORY: 12 files before → 12 files after (stable)

         ⏸️ Gate: 🔑 VERIFY APPROVED OK?
```

```
YOU:     🔑 VERIFY APPROVED
```

```
ANT:     [REPORT — 13 sections]
         CARD_RECEIPT: CD-5, cards executed: CORE-001, ANT-CHECKPOINT...ANT-REPORT
         HORSEMEN SELF-CHECK: H1 ✅ H2 ✅ H3 ✅ H4 ✅ H5 ✅

         ⏸️ Waiting for: I AM (Ghost)
```

```
YOU:     I AM
```

### Task 1: Ghost Review

```
GHOST:   [REVIEW — 8 sections]
         Evidence Score: 92%
         Compliance: ALL PASS
         Findings: 0 BLOCKER, 0 HIGH, 1 MEDIUM (logout doesn't clear local storage)

         VERDICT: 🔑 GHOST APPROVED WITH NOTES

         ⏸️ Waiting for: I AM
```

```
YOU:     I AM
```

### Task 1: Inspector Audit

```
INSPECTOR: [COMPLIANCE AUDIT — 7 sections]
           Findings: 0 BLOCKER, 0 HIGH, 0 MEDIUM
           VERDICT: 🔑 INSPECTOR PASS

           Next task? → I AM
```

```
YOU:     I AM
```

### Task 2: Same Pipeline

*(TASK-015 goes through the same CHECKPOINT → DISCOVERY → FOOTPRINT → PATCH → VERIFY → REPORT → GHOST → INSPECTOR cycle)*

```
INSPECTOR: All tasks complete. Activate BECCA for final verification? → I AM
```

```
YOU:     I AM
```

### VERIFY + CLOSE

```
BECCA:   [VERIFY]
         Regression check: ✅ No regressions
         Completeness: ✅ 2/2 tasks passed all stages
         Build/Tests: ✅ All passing

         ⏸️ VERIFY complete. Loading ARCHIVE.
```

```
YOU:     continue
```

```
BECCA:   [CLOSE_ARCHIVE]
         TODO archived → .neo/archive/TODO_SONNY_5.md
         STATE.md updated: Run #5 COMPLETE, TASK-015
         RUN_INDEX: entry appended
         HIVE: 6 indexes updated

         ⏸️ ARCHIVE complete. Loading ANALYTICS.
```

```
YOU:     continue
```

```
BECCA:   [CLOSE_ANALYTICS]
         First-pass rate: 100% (2/2)
         PIPELINE EVAL: 19/19 PASS → Grade A
         Band-aids: 0 detected
         Prompt Feedback: No priority issues

         ⏸️ ANALYTICS complete. Loading DEVTOOLS.
```

```
YOU:     continue
```

```
BECCA:   [CLOSE_DEVTOOLS]
         Trigger assessment: navbar.tsx changed → menu boundary trigger
         Dispatching Sentinel...
         [DevTools verification results]

         ⏸️ DEVTOOLS complete. Loading GOVERNANCE.
```

```
YOU:     continue
```

```
BECCA:   [CLOSE_GOVERNANCE]
         GPS Quick Check: 8/8 YES
         Deep Scan: Area 3 (BECCA cards) — no issues
         Merge: ✅ run-5-2026-03-02 → main

         🔑 RUN COMPLETE
```

**Run is finished. Project is ready for the next run.**

---

## 21. COMMON SCENARIOS & HOW TO HANDLE THEM

### Scenario 1: Ghost Rejects the Ant's Work

```
GHOST: VERDICT: 🔑 GHOST REJECTED
       Deficiencies:
       1. Evidence score 42% — multiple claims without proof
       2. Missing LESSONS_INDEX check in Hive proof
```

**What you do:**
```
YOU: I AM
```
Ant reactivates with the deficiency list and must fix both issues before re-submitting.

---

### Scenario 2: NUCLEAR Triggered During Discovery

```
ANT: 🛑 STOP — S-12: Hardcoded API key found in config/firebase.ts:23
     ⚫ NUCLEAR — Credential exposure

     NUCLEAR INCIDENT REPORT:
     Trigger: Hardcoded Firebase API key
     File: config/firebase.ts:23
     Blast Radius: All users (key gives access to production database)
     Risk: HIGH — key is committed to git history
```

**What you do:**
1. Go to your Firebase console and rotate the API key
2. Ensure the key is in `.env` (not hardcoded)
3. Consider cleaning git history
4. Then:
```
YOU: 🔑 NUCLEAR RESOLVED: Rotated Firebase API key, moved to .env, updated .gitignore
```

---

### Scenario 3: Ant Exceeds Evidence Budget

```
ANT: 🛑 STOP — S-14: Evidence budget exceeded
     FILES READ: 5/5 (limit reached)
     Need to read 2 more files to complete discovery
```

**What you do:**
If the additional reads are justified:
```
YOU: 🔑 DISCOVERY EXPANSION APPROVED
```

---

### Scenario 4: Feature Count Decreased

```
ANT: 🛑 STOP — S-29: Feature count decreased
     FEATURE INVENTORY:
     Before: 15 exports in auth/
     After: 13 exports in auth/
     Missing: validateSession, refreshToken
```

**What you do:**
- If the removal was intentional:
```
YOU: 🔑 FEATURE REMOVAL OVERRIDE: validateSession
🔑 FEATURE REMOVAL OVERRIDE: refreshToken
```
- If the removal was accidental → investigate before proceeding

---

### Scenario 5: Strike 3 — Task Keeps Failing

```
GHOST: This task has been rejected 3 times. STRIKE 3.
       Escalating to BECCA.

BECCA: Strike 3 Analysis:
       - Rejection pattern: Same evidence issues each time
       - Ant type: 🛠️ Carpenter (building)
       - Domain: Complex auth flow

       Options:
       A. 🐛 DEBUGGER — Investigate root cause
       B. SPLIT — Break into smaller tasks
       C. RE-ASSIGN — Try different Ant type (🛡️ Soldier for auth)
```

**What you do:** Choose the option that fits:
```
YOU: C — RE-ASSIGN to Soldier Ant
```

---

### Scenario 6: You Want to Skip Inspector

Sometimes for simple tasks (docs update, style change), you may want to skip the Inspector audit:

```
YOU: SKIP INSPECTOR
```

Note: This means **you** accept responsibility for compliance. Use sparingly.

---

### Scenario 7: Session Crashes Mid-Run

If your chat session crashes or times out:

1. Start a new session in the same project
2. Type `BECCA ACTIVATE`
3. BECCA reads STATE.md and detects the incomplete run
4. BECCA reads TASK_CARD_GPS_LINKING.md for crash recovery
5. BECCA resumes from the last recorded checkpoint

The card system and state files make this recovery possible.

---

### Scenario 8: You Want to Add Feature Ideas for Later

Place markdown files in `.neo/inbox/ideas/`:

```
.neo/inbox/ideas/dark-mode.md
.neo/inbox/ideas/mobile-responsive-tables.md
```

The Planner Ant reads these during the PLAN phase and incorporates them into the task sequence.

---

## 22. TROUBLESHOOTING

### "BECCA isn't following the gates"

If BECCA produces multiple gates in one response (skipping the pause points):

1. **Paste the injection:** Copy-paste the contents of `.neo/injections/GATE_ENFORCEMENT.md` into the chat
2. This reinforces the Response Boundary Protocol
3. BECCA should resume one-gate-per-response behavior

### "Ant says it checked the Hive Mind but the proof looks generic"

Ghost should catch this with the "Prove Not Vibe" check. If Ghost misses it:

1. Tell Ghost: "Re-check Section 7 — Hive Mind compliance. The proof table has generic entries without real file paths."
2. Ghost will re-evaluate and likely reject

### "The AI keeps calling itself Claude instead of BECCA"

This is an identity drift issue. Paste `.neo/injections/GATE_ENFORCEMENT.md` into the chat. The CLAUDE.md file declares the AI as BECCA, and the injection reinforces this.

### "I accidentally approved something I shouldn't have"

Gate tokens are single-use and forward-moving. You cannot "un-approve" a gate. However:
- Ghost and Inspector will catch issues in their reviews
- If something serious was approved, use `ABORT <TASK_ID>` to cancel the task
- The git checkpoint from Step 1 lets you roll back all changes

### "The pipeline seems stuck"

Check what the last prompt says:
- `⏸️ Waiting for: I AM` → You need to type `I AM`
- `⏸️ Gate: 🔑 <TOKEN>` → You need to issue the specific token
- `🛑 STOP` → There's a blocking issue to resolve

### "I don't understand a finding"

Ask the role to explain:
```
YOU: Explain finding F-003 in more detail
```

The role should provide context without fixing the issue (Ghost/Inspector don't fix, they explain).

---

## 23. GLOSSARY

| Term | Definition |
|------|-----------|
| **BECCA** | The orchestrator role — manages runs, dispatches roles, tracks state |
| **Ant** | The worker role — reads code, proposes changes, applies patches |
| **Ghost** | The reviewer role — validates evidence, catches fabrication |
| **Inspector** | The auditor role — checks compliance, drift, security |
| **Gate** | A checkpoint requiring your explicit approval to proceed |
| **Gate Token** | The exact string you type to approve a gate (e.g., `🔑 FOOTPRINT APPROVED`) |
| **RECON** | BECCA's initial survey phase at the start of each run |
| **SCOUT** | BECCA's codebase survey that creates the task TODO |
| **TODO** | The task list for a run — single source of truth for all roles |
| **FOOTPRINT** | Ant's proposed change plan — file by file, operation by operation |
| **PATCH** | The actual code changes applied by Ant |
| **VERIFY** | Ant's testing/validation phase after applying changes |
| **Pheromone** | A warning emitted by any role about a risk or issue |
| **NUCLEAR** | The highest severity — a hard halt for security/data safety violations |
| **Hive Mind** | 7 indexes that accumulate institutional knowledge across runs |
| **CARD_RECEIPT** | Proof that an agent followed its assigned protocol cards |
| **CDEX** | Card-Deck Execution — the card-based protocol system |
| **Policy Pack** | Versioned snapshot of all active protocol rules (PP-YYYY-MM-DD) |
| **Truthy Diffs** | 7-point checklist verifying code changes are real and complete |
| **Strike 3** | 3rd rejection of the same task — triggers escalation |
| **Band-aid** | A chronic issue being patched repeatedly without solving root cause |
| **Five Horsemen** | 5 anti-patterns: Hallucination, Privilege Creep, Scope Drift, Scope Contraction, Silent Failure |
| **Run** | One complete cycle: RECON → tasks → CLOSE |
| **Run Index** | History of all completed runs with metrics |
| **State** | The project's current run counter and status |
| **Project Lock** | All work in a run is locked to one project directory |
| **Critical Surface** | A high-risk file requiring special override token to edit |
| **Evidence Budget** | Discovery limits: ≤5 files, ≤200 lines, ≤10 greps |
| **Violation** | A protocol breach (V-01 through V-13) — auto-reject by Ghost |
| **Response Boundary** | Rule: ONE gate per response. The AI must stop and wait at each gate. |

---

## QUICK START CHECKLIST

For your first run:

- [ ] Ensure `.neo/` directory exists in your project (run `neo-init.ps1` if not)
- [ ] Open your AI chat in the project directory
- [ ] Type `BECCA ACTIVATE`
- [ ] Read the RECON summary carefully
- [ ] Type `I AM` to start Scout
- [ ] Review the TODO — are the tasks right?
- [ ] Type `I AM` to start the first Ant
- [ ] For each Ant gate, **read the output** then issue the exact token
- [ ] After each Ant report, type `I AM` for Ghost review
- [ ] After Ghost, type `I AM` for Inspector audit
- [ ] Repeat for all tasks
- [ ] Let BECCA CLOSE run through all 4 cards
- [ ] Celebrate when you see `🔑 RUN COMPLETE` 🎉

---

> **Remember:** The pipeline exists to protect your users. Every gate you approve is a promise that the change is safe, understood, and verified. Take your time. Read the evidence. Trust the process.

---

*NEO Pipeline Governance Framework — Built for SaaS at Scale*
*Manual Version 1.0.0 — 2026-03-02*
