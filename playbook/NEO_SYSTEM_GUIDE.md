# HOW NEO BUILDS AND MAINTAINS A SAAS SYSTEM
## End-to-End Guide — From First Activation to Production-Ready Product

**Version:** 1.0.0
**Last Updated:** 2026-02-12
**For:** The human operator — understanding the full pipeline

---

## The Big Picture

NEO is a 4-role AI governance pipeline that lets you safely build, fix, and maintain SaaS applications using AI agents. The key word is **safely** — every action requires your approval, every change produces evidence, and every piece of work gets reviewed twice before it's considered done.

**The 4 Roles:**

```
BECCA (Orchestrator) ── Plans the work, tracks everything, closes the run
     │
     ├── ANT (Worker) ── Reads code, proposes changes, applies patches, runs tests
     │
     ├── GHOST (Reviewer) ── Validates the Ant's evidence, catches lies, grades quality
     │
     └── INSPECTOR (Auditor) ── Audits for compliance, drift, security violations
```

**You** sit at every gate. Nothing happens without your "yes."

---

## Part 1: Before Anything Starts — The Framework

### What Lives Where

```
d:\projects\neo\                          ← The NEO framework (this repo)
├── roles/
│   ├── NEO-BECCA.md                     ← Orchestrator protocol (v1.8.0)
│   ├── NEO-ANT.md                       ← Worker protocol (v1.10.0)
│   ├── NEO-GHOST.md                     ← Reviewer protocol (v1.9.0)
│   └── NEO-INSPECTOR.md                ← Auditor protocol (v1.5.0)
├── shared/                              ← Modules loaded by every role
│   ├── NEO-ACTIVATION.md               ← "I AM" protocol & TODO coordination
│   ├── NEO-GATES.md                    ← State machine & approval tokens
│   ├── NEO-EVIDENCE.md                 ← Evidence requirements
│   ├── NEO-OUTPUTS.md                  ← Output formats
│   ├── NEO-TOOLS.md                    ← Tool permissions per role
│   ├── NEO-HIVE.md                     ← Hive Mind indexes & write contracts
│   ├── NEO-SURGICAL.md                 ← 3 Laws of Surgical Change
│   └── NEO-HIVEMIND-GLOBAL.md          ← Cross-project shared knowledge
├── templates/                           ← 14 templates for all artifacts
│   ├── ANT_REPORT.md
│   ├── GHOST_REVIEW.md
│   ├── INSPECTOR_REPORT.md
│   ├── PROJECT_TODO.md
│   ├── OPERATOR_MANUAL.md
│   └── ... (9 more)
└── playbook/                            ← Your training materials (this folder)
```

### What Lives in Each Project

When NEO touches a project, it creates a `.neo/` directory:

```
d:\projects\sonny\.neo\                   ← Sonny's NEO workspace
├── STATE.md                             ← Run counter, last task ID
├── RUN_INDEX.md                         ← History of every run
├── TODO_SONNY.md                        ← Current active TODO
├── CRITICAL_SURFACES.md                 ← High-risk files list
├── OPERATOR_MANUAL_SONNY.md             ← Project knowledge base
├── manual/                              ← Appendices (loaded on demand)
│   ├── SCHEMA.md                        ← Collections & security rules
│   ├── FUNCTIONS.md                     ← All cloud functions
│   ├── MIDDLEWARE.md                    ← Auth chain & permissions
│   ├── FRONTEND.md                     ← Routes, hooks, contexts
│   ├── SERVICES.md                     ← External integrations
│   ├── ENVIRONMENT.md                  ← Env vars & deploy config
│   └── TESTS.md                        ← Test inventory & coverage
├── outbox/
│   ├── ants/                            ← Ant reports (permanent record)
│   ├── ghost/                           ← Ghost reviews (permanent record)
│   └── inspector/                       ← Inspector reports (permanent record)
├── index/                               ← Hive Mind (permanent indexes)
│   ├── MASTER_INDEX_001.md              ← Every task ever completed
│   ├── FILE_OWNERSHIP_*.md              ← Which tasks touched which files
│   ├── PHEROMONE_NUCLEAR.md             ← Active danger warnings
│   ├── PHEROMONE_HIGH.md
│   ├── PHEROMONE_MEDIUM.md
│   ├── PHEROMONE_LOW.md
│   └── PHEROMONE_INFO.md
├── archive/                             ← Completed TODOs
│   ├── TODO_SONNY_001.md
│   ├── TODO_SONNY_002.md
│   └── ...
└── audit/
    ├── evidence/                        ← Test output, build logs
    └── gate-logs/                       ← Record of every approval you gave
```

---

## Part 2: Starting a Run — BECCA RECON

### You Say the Magic Words

```
YOU: "BECCA ACTIVATE" or "Deep dive into Sonny"
```

BECCA wakes up and runs RECON — a multi-step intelligence-gathering phase.

### What BECCA Does During RECON

```
Step 1  ── Identify the target project and its .neo/ directory
Step 2  ── Check if .neo/ exists
            → First time? Create the whole directory structure (INIT)
            → Already exists? Continue
Step 3  ── Read STATE.md (run counter, last task ID)
Step 3b ── Read RUN_INDEX.md (history of past runs)
            → "Runs 1-5 did X, Y, Z. Run 3 had a deferred finding."
Step 3c ── INDEX HEALTH CHECK
            → Count tasks in MASTER_INDEX
            → Count active pheromones by severity
            → Flag stale pheromones (active > 30 days)
            → Flag orphaned entries
Step 3d ── Read OPERATOR_MANUAL (project knowledge base)
            → Danger zones, safe patterns, known gotchas
Step 3e ── MANUAL DRIFT CHECK
            → If 5+ runs since last audit → auto-queue drift inspection
Step 3f ── Read GLOBAL HIVEMIND (cross-project knowledge)
            → Patterns from other projects that apply here
Step 4  ── Check for unfinished TODO
            → Complete? Archive it automatically
            → Incomplete? Ask you: resume, archive, or abort
Step 5  ── Determine next task ID (global, never resets)
Step 6  ── Determine next run number
Step 7  ── Present RECON summary + declare PROJECT LOCK
```

### What You See

```
┌────────────────────────────────────────────────┐
│  RECON COMPLETE — SONNY                         │
├────────────────────────────────────────────────┤
│  Project path:  d:\projects\sonny\              │
│  Previous runs: 5                               │
│  Last task ID:  TASK-020                        │
│  Next task ID:  TASK-021                        │
│  Next run:      6                               │
│  Prior TODO:    archived                        │
│  Run history:   5 entries                       │
│  Hive index:    20 tasks, 8 pheromones          │
│  Operator Manual: found (v2.0.0)                │
│  Manual drift:  not due (2 runs since last)     │
│  Global hivemind: 7 pheromones, 7 anti-patterns │
│  .neo/ status:  ready                           │
│                                                  │
│  PROJECT LOCK: SONNY                             │
│  Locked root: d:\projects\sonny\                 │
│  All work MUST stay within this path.            │
└────────────────────────────────────────────────┘

Previous runs summary:
 • Run 004 (2026-02-10): Security hardening — 78 fixes, 857 tests
 • Run 005 (2026-02-11): Bulletproofing — 3 gap fixes, cross-project hivemind

Ready to dispatch Scout.
Activate Scout? → I AM
```

### PROJECT LOCK — Why It Matters

Once BECCA declares PROJECT LOCK, **every role** in this run is confined to that one project directory. No Ant can read or write files outside `d:\projects\sonny\`. This prevents cross-project contamination.

- Cross-project **READ** requires an explicit exception token
- Cross-project **WRITE** is **NEVER** allowed
- Violation = automatic Ghost rejection + Inspector compliance failure

---

## Part 3: The Scout Survey

### You Say "I AM" — Scout Activates

The Scout is a special Ant type (Flying Scout Ant) that **reads but never writes code**. Its job is to survey the codebase and create the task list.

### What the Scout Does

```
1. Read the codebase (within evidence budget)
2. Identify bugs, issues, improvements, features needed
3. Classify each as an Ant Type:
   🔥 Fire Ant (security)     💵 Financial Ant (payments)
   🛡️ Soldier Ant (validation) 🛠️ Carpenter Ant (building)
   🧰 Toolbox Ant (maintenance) 📊 Harvester Ant (data)
   📈 Analyst Ant (analytics)  🚁 Flying Scout (research)
   🌿 Leafcutter (docs)        👔 Board Ant (planning)
   🤝 Advisor Ant (reviews)    📞 Support Ant (support)
   🐛 Debugger Ant (diagnostics) 🎨 Color Expert (styling)
4. Prioritize by risk and impact
5. Create TODO_<PROJECT>.md with sequential task IDs
6. If no Operator Manual exists → create one from template
```

### What You See

```
Scout complete. TODO created.

TODO: .neo/TODO_SONNY.md
Run: 6
Tasks: 4

| # | Ant Type           | Task ID  | Objective                          |
|---|--------------------|----------|------------------------------------|
| 1 | 🔥 Fire Ant        | TASK-021 | Fix auth token refresh race condition |
| 2 | 🛠️ Carpenter Ant   | TASK-022 | Add KDS order status websocket     |
| 3 | 🧰 Toolbox Ant     | TASK-023 | Fix menu publish cache invalidation |
| 4 | 🌿 Leafcutter      | TASK-024 | Update manual with new KDS endpoint |

First task: TASK-021 — 🔥 Fire Ant
Activate Ant? → I AM
```

### You Approve the TODO

Review the tasks. Are they the right priorities? Are the Ant Types correct? If yes, say "I AM" to start the first Ant.

---

## Part 4: The Ant Pipeline — Where Code Gets Written

Every task follows the same 7-state pipeline. This is the heart of NEO.

### State 0: CHECKPOINT (Before Any Work)

```
Before the Ant reads a single line of code:

1. Verify PROJECT LOCK path matches TODO
2. Create git safety net:
   → git stash (if uncommitted changes)
   → Record current HEAD hash
   → Record branch name and timestamp
3. Present CHECKPOINT PROOF to you:

   ⛑️ CHECKPOINT PROOF
   | Field     | Value                    |
   |-----------|--------------------------|
   | Project   | SONNY                    |
   | Root      | d:\projects\sonny\       |
   | Branch    | feature/auth-fix         |
   | Commit    | a1b2c3d                  |
   | Stash     | NO                       |
   | Timestamp | 2026-02-12T10:30:00Z     |
   | Rollback  | git checkout a1b2c3d     |

No checkpoint = No work. NON-NEGOTIABLE.
```

### State 1: DISCOVERY (Understanding the Problem)

The Ant reads and investigates — but does NOT change anything yet.

```
Step -1  ── PROJECT LOCK CHECK
             Verify every file path is within locked root

Step 0   ── HIVE MIND CHECK (before reading code)
             a. Search MASTER_INDEX for previous tasks on target files
             b. Read FILE_OWNERSHIP for each target file's history
             c. Check PHEROMONE_REGISTRY for active warnings
             d. Read GLOBAL HIVEMIND for cross-project patterns
             e. Present HIVE MIND BRIEFING:

             HIVE MIND BRIEFING — TASK-021
             ┌─────────────────────────────────────────────┐
             │ Previous tasks on target files:              │
             │  • TASK-008: Fixed auth middleware (Run 3)   │
             │  • TASK-015: Added rate limiting (Run 4)     │
             │ Active pheromones:                           │
             │  • PH-012: 🟠 MEDIUM — Auth token caching   │
             │ Cross-project:                               │
             │  • GP-003: Firebase JWT caching behavior     │
             │ Traffic: MEDIUM (2 previous tasks)           │
             └─────────────────────────────────────────────┘

             ⚫ NUCLEAR STOP: If target file has NUCLEAR pheromone
             → FULL STOP. Present details. You decide.

Step 1-5 ── Code Analysis (within evidence budget)
             → Read target files (max 5 files, 200 lines, 10 greps)
             → Understand current behavior
             → Identify exact issue location
             → Document evidence of current state

Step 6   ── UNDERSTANDING PROOF (LAW 1 — The 3 Laws of Surgical Change)
             a. Current behavior — what does the system DO now?
             b. Design intent — WHY was it designed this way?
             c. Hidden constraints — what is intentionally hidden?
             d. Blast radius — what breaks at scale if wrong?

             If ANY check cannot be evidenced → STOP.
             "Looks wrong" ≠ "is wrong." Investigate first.

Step 7   ── Check Operator Manual
             → Known intentional patterns
             → Danger zones
             → Safe operation patterns

Step 8   ── SNAPSHOT SUMMARY (mandatory)
             1. Root cause: Token refresh fires before expiry check completes
             2. Affected files: src/hooks/useAuth.ts, src/middleware/auth.ts
             3. Proposed approach: Add mutex lock around refresh cycle
             4. Risk assessment: 🔴 HIGH — auth flow, security impact
             5. Estimated scope: 2 files, ~15 lines changed
```

**STOP.** You see the findings. You acknowledge before proceeding.

### State 2: FOOTPRINT (Proposing the Changes)

The Ant proposes exactly what it will change — still hasn't changed anything.

```
Step 1   ── Propose the smallest effective change (LAW 3 — Minimum Effective Change)
Step 2   ── List ALL files that will be modified
Step 3   ── DATA OPERATION CLASSIFICATION (for each file):

             | File               | Change Type | Data Op   | Backup? | Write Semantic |
             |--------------------|-------------|-----------|---------|----------------|
             | src/hooks/useAuth.ts | MODIFY     | CODE_ONLY | NO      | PATCH          |
             | src/middleware/auth.ts | MODIFY   | CODE_ONLY | NO      | PATCH          |

Step 4   ── Flag CRITICAL SURFACES (high-risk files)
Step 5   ── Risk assessment
Step 6   ── Rollback plan
Step 7   ── Security impact assessment (because 🔴 HIGH risk Fire Ant)
Step 8   ── Emit pheromones for any new risks found
```

**STOP.** You see the proposal. You respond with one of:
- `FOOTPRINT APPROVED` → proceed
- `FOOTPRINT APPROVED WITH CHANGES: ...` → adjust, then proceed
- `REJECTED: ...` → go back, revise

### State 3: BACKUP (Conditional — Data Operations Only)

**Only triggered** when files are classified as DATA_WRITE, DATA_DELETE, MIGRATION, SEED, or CONFIG_WRITE. Code-only tasks skip this.

```
When triggered:
1. Create backup of affected data
2. Present BACKUP PROOF:
   | Field          | Value                              |
   |----------------|-------------------------------------|
   | Timestamp      | 2026-02-12T11:00:00Z               |
   | Location       | .neo/audit/evidence/TASK-021_backup |
   | Scope          | menuItems collection (142 docs)     |
   | Restore method | firestore-import from backup path   |
   | Restore verified | YES — test restore on emulator    |
   | Size           | 142 documents, 48KB                 |

STOP. You approve the backup before any changes.
```

### State 4: PATCH (Applying the Changes)

Now the Ant makes the actual code changes.

```
1. Apply changes exactly as approved in FOOTPRINT
2. Show exact diffs:

   ### src/hooks/useAuth.ts
   `src/hooks/useAuth.ts:42-58`

   ```diff
   - const refreshToken = async () => {
   -   const token = await getIdToken(user);
   -   setAuthToken(token);
   + const refreshToken = async () => {
   +   if (isRefreshing.current) return;
   +   isRefreshing.current = true;
   +   try {
   +     const token = await getIdToken(user);
   +     setAuthToken(token);
   +   } finally {
   +     isRefreshing.current = false;
   +   }
   ```

3. Summary of changes
4. Any deviations from FOOTPRINT (with justification)
```

**STOP.** You see the actual code changes. You approve or reject.

### State 5: VERIFY (Testing the Changes)

```
1. Run tests:        npm test → 896 passing, 0 failing
2. Run build:        npm run build → success
3. Run lint:         npm run lint → 0 errors
4. Run type-check:   npx tsc --noEmit → success
5. Check regressions: no new failures
6. Verify success criteria:
   ✅ Token refresh no longer fires twice
   ✅ Mutex prevents concurrent refresh calls
   ✅ All 896 existing tests still pass
7. 🔴 HIGH risk domain tests:
   ✅ Auth flow test: login → refresh → logout
   ✅ Token expiry simulation: no race condition
```

**STOP.** You see all test results. You approve or reject.

### State 6: REPORT (Documenting the Work)

The Ant writes a structured 13-section report:

```
Section 1:  TASK SUMMARY — what was done, one paragraph
Section 2:  DISCOVERY — what was found, evidence
Section 3:  FOOTPRINT — approved change plan
Section 4:  PATCH — exact diffs applied
Section 5:  VERIFY — test/build/lint results
Section 6:  EVIDENCE — all proof files linked
Section 7:  SELF-ASSESSMENT — honest quality score
Section 8:  LESSONS FOR FUTURE ANTS — what worked, gotchas, advice
Section 9:  PHEROMONES EMITTED — risk markers for the hive
Section 10: GATE LOG — record of every approval token
Section 11: HIVE CONTEXT — what the hive mind said about these files
Section 12: HANDOFF — ready for Ghost
Section 13: PROMPT FEEDBACK — suggestions for improving NEO itself
```

Report saved to `.neo/outbox/ants/ANT_REPORT_TASK-021.md`

**STOP.** You review the report. You approve or reject.

---

## Part 5: Ghost Review — The Evidence Check

### You Say "I AM" — Ghost Activates

The Ghost is the **quality gatekeeper**. It reads the Ant's report and validates that everything is real.

### The 8-Section Review

```
Section 1: REVIEW HEADER
           Task ID, Ant type, risk level, paths, overview

Section 2: REPORT COMPLETENESS
           All 13 Ant report sections present?
           Snapshot summary has all 5 fields?

Section 3: DEFINITION OF DONE
           Each success criterion → PASS/FAIL with evidence reference

Section 4: EVIDENCE VALIDATION
           → Are all file paths real (not placeholders)?
           → Do all claims have corresponding proof?
           → Are diffs accurate (match actual file contents)?
           → Is test output real (not fabricated)?
           → Evidence score: 92% (< 50% = AUTO REJECT)

Section 4b: EVIDENCE RE-EXECUTION (conditional)
            Ghost asks YOU to re-run the Ant's test commands:

            "🔁 EVIDENCE RE-EXECUTION REQUEST:
             Command: npm test
             Ant claimed: 896 passing, 0 failing
             Please re-run. Does output match? (Y/N/S)"

            → MISMATCH = score drops to 0% = AUTO REJECT
            → SKIP = UNVERIFIED (info severity, not blocking)
            → MATCH = verified, confidence boost

Section 5: COMPLIANCE CHECK
           → Ant Type matches task packet
           → Critical surfaces had OVERRIDE tokens
           → All gates have approval tokens in gate log
           → Surgical Protocol compliance:
             LAW 1: Understanding Proof? ✅
             LAW 2: Backup (if needed)?  N/A (code-only)
             LAW 3: Min delta + PATCH?   ✅

Section 6: NUCLEAR & PHEROMONE AUDIT
           → No NUCLEAR conditions detected ✅
           → All risks have matching pheromones ✅
           → No violations (V-01 through V-09) ✅

Section 7: FINDINGS
           All findings cataloged with severity + summary table

Section 8: VERDICT & HANDOFF
           APPROVED / REJECTED + rationale + score card
```

### Ghost Verdicts

| Verdict | What Happens Next |
|---------|-------------------|
| APPROVED | Ready for Inspector → "Activate Inspector? → I AM" |
| APPROVED WITH NOTES | Ready, but you should note the caveats |
| CHANGES REQUESTED | Back to Ant for fixes → "Send back to Ant? → I AM" |
| REJECTED | Back to Ant, critical issues → "Send back to Ant? → I AM" |

### Auto-Reject Triggers (Ghost Catches These Automatically)

- Evidence score below 50%
- Evidence re-execution mismatch (Ant lied about test results)
- NUCLEAR condition detected (security/tenant breach)
- Any violation V-01 through V-09
- Missing required sections (Lessons, Hive Context, Prompt Feedback)
- Data operations without backup
- Assumption-based changes without investigation

---

## Part 6: Inspector Audit — The Compliance Check

### You Say "I AM" — Inspector Activates

The Inspector is the **final checkpoint**. It audits for standards compliance, not quality (Ghost does quality).

### 8 Inspection Types

| Type | What It Checks |
|------|---------------|
| **COMPLIANCE** | Evidence completeness, report format, gate compliance (default) |
| **DRIFT** | Did work drift from approved FOOTPRINT? Scope creep? |
| **QUALITY** | Code quality, test coverage, documentation |
| **NUCLEAR** | Tenant isolation, credential exposure, security boundaries |
| **PHEROMONE** | All risks properly marked? No suppressed warnings? |
| **HIVE** | Index consistency (8-point audit) |
| **SURGICAL** | 3 Laws followed? (10-point audit) |
| **MANUAL_DRIFT** | Has Operator Manual fallen out of date? |

### Inspector Verdicts

| Verdict | What Happens |
|---------|-------------|
| **PASS** | Task is complete. Next task or BECCA CLOSE. |
| **PASS WITH FINDINGS** | Complete, but issues noted for awareness |
| **FAIL** | Back to Ant → "Send back to Ant? → I AM" |

### The Loop-Back

If Ghost or Inspector rejects:
```
REJECTED → Ant re-activates with deficiency list
         → Ant fixes the specific issues
         → Ant goes through pipeline again
         → Ghost re-reviews
         → Inspector re-audits
         → If 3 loops: "⚠️ Task has looped 3 times. Operator review recommended."
```

---

## Part 7: After All Tasks — BECCA CLOSE

### BECCA Returns for Final Verification

When the last task passes Inspector, you say "I AM" to bring BECCA back.

### VERIFY Phase

```
1. Read ALL Ant reports from this run
2. REGRESSION CHECK:
   → Did any later Ant break a previous Ant's work?
   → Did later Ants modify files that earlier Ants also modified?
   → If regression found → dispatch fix Ant
3. COMPLETENESS CHECK:
   → All tasks ✅ across all three stages?
   → Any unresolved NUCLEAR findings?
4. CONSISTENCY CHECK:
   → Project still builds?
   → Tests still pass?
```

### CLOSE Phase (10 Steps)

```
Step 1   ── Mark TODO: ✅ COMPLETE
Step 2   ── Add completion timestamp
Step 3   ── Archive TODO → .neo/archive/TODO_SONNY_006.md
Step 4   ── Update STATE.md (last run, last task ID)
Step 5   ── Update RUN_INDEX.md (summary of this run)
Step 6   ── Update HIVE INDEXES:
             → MASTER_INDEX: one line per task
             → FILE_OWNERSHIP: which tasks touched which files
             → PHEROMONE_REGISTRY: new warnings, resolved warnings
Step 7   ── OPERATOR MANUAL UPDATE CHECK:
             → Scan all Ant reports for "feature signals"
             → New functions? New endpoints? New schemas? New env vars?
             → If signals found → dispatch 🌿 Leafcutter Ant to update the manual
             → Leafcutter → Ghost review → then continue
Step 8   ── CROSS-PROJECT HIVEMIND UPDATE:
             → Any patterns that apply to OTHER projects?
             → Framework bugs? Auth patterns? Deployment gotchas?
             → Append to shared/NEO-HIVEMIND-GLOBAL.md
Step 9   ── PROMPT FEEDBACK AGGREGATION:
             → Read Section 13 from all Ant reports
             → 3+ Ants report same issue → PRIORITY FIX
             → Present summary to you
Step 10  ── Sign off: "RUN COMPLETE"
```

### What You See at the End

```
BECCA — Run 6 VERIFIED and CLOSED.

Verification: ✅ No regressions. All tasks consistent.
TODO archived: .neo/archive/TODO_SONNY_006.md
Run index updated: .neo/RUN_INDEX.md
Tasks completed: 4
Task ID range: TASK-021 to TASK-024
Prompt feedback: 2 items collected, 0 priority fixes

All artifacts remain in .neo/outbox/.
Project ready for next run.

🔑 RUN COMPLETE
```

---

## Part 8: The Safety Systems

### The 3 Laws of Surgical Change

Every Ant follows these. They're the core safety philosophy.

**LAW 1: Understand Before Touching**
- Ant must PROVE it understands: current behavior, design intent, hidden constraints, blast radius
- No assumptions. "Looks wrong" is not evidence.
- If the Ant can't evidence all 4 checks → FULL STOP

**LAW 2: Protect Data**
- Any operation that writes, deletes, or migrates data requires:
  - Backup proof (timestamp, location, restore method)
  - Your explicit BACKUP APPROVED token
- If backup can't be created → NO PATCH

**LAW 3: Minimum Effective Change**
- Smallest possible change to achieve the objective
- PATCH (merge) by default — never PUT (replace) unless justified
- No "while I'm here" improvements
- No scope creep

### The Pheromone System — Colony Memory of Danger

Pheromones are risk markers that **persist across runs**. They're the colony's memory.

```
⚫ NUCLEAR  — Catastrophic risk. Data loss / security breach.
             BLOCKS all work on affected files until resolved.

🔴 HIGH     — Significant risk. Extra review at every gate.

🟠 MEDIUM   — Moderate concern. Monitor across runs.

🟡 LOW      — Minor risk. Fix when convenient.

🟢 INFO     — Observation. No action needed.
```

**How they flow:**
```
Ant finds risk → Emits pheromone in report
  → BECCA indexes it in PHEROMONE_REGISTRY during CLOSE
    → Next run's Ant checks the registry during DISCOVERY
      → If NUCLEAR → FULL STOP before any code reading
        → You decide: proceed or abort
```

### The Hive Mind — Permanent Institutional Memory

Three index files track everything that's ever happened:

| Index | What It Tracks | Why It Matters |
|-------|---------------|----------------|
| **MASTER_INDEX** | One line per completed task | Know what was done and when |
| **FILE_OWNERSHIP** | Which tasks touched which files | Know a file's full history |
| **PHEROMONE_REGISTRY** | Active risk warnings by severity | Know what's dangerous right now |

Plus the **Global Hivemind** — lessons that apply across ALL projects.

**Only BECCA writes to indexes.** Single writer prevents corruption.

### Evidence Budget (Anti-Drowning)

Ants can't read unlimited code. Hard limits prevent context overflow:

```
Max 5 files read  |  Max 200 lines shown  |  Max 10 greps

If insufficient → STOP → ask for DISCOVERY EXPANSION APPROVED
```

### Project Lock

One project per run. No cross-contamination.

```
BECCA declares lock → ALL roles are confined to that directory
Cross-project READ → requires explicit exception token
Cross-project WRITE → NEVER allowed
Violation → automatic Ghost rejection + Inspector failure
```

### 28 STOP Conditions

The Ant has 28 explicit triggers that cause an immediate STOP:
- Missing inputs (S-01 to S-05)
- Test/build failures (S-06, S-15)
- Security concerns (S-07 to S-09)
- Critical surfaces (S-10)
- Evidence budget (S-11)
- NUCLEAR pheromones (S-18)
- Assumption-based changes (S-19 to S-22)
- Backup violations (S-23, S-24)
- Project lock violations (S-25 to S-28)

**STOP means STOP.** Only an explicit approval token clears it.

---

## Part 9: Building a SaaS System with NEO — The Lifecycle

Here's how NEO was used to build and harden two real SaaS products:

### Phase 1: Initial Build

```
Run 1: Foundation
├── 🛠️ Carpenter Ant: Set up Next.js project structure
├── 🛠️ Carpenter Ant: Create Firestore collections and rules
├── 🔥 Fire Ant: Implement auth flow (Firebase Auth + JWT claims)
├── 💵 Financial Ant: Integrate Stripe subscriptions
└── 🌿 Leafcutter: Create first Operator Manual

Run 2: Core Features
├── 🛠️ Carpenter Ant: Build dashboard UI
├── 📊 Harvester Ant: Create data fetching hooks
├── 🛡️ Soldier Ant: Add input validation (Zod schemas)
└── 🌿 Leafcutter: Update manual with new schemas
```

**What accumulates:** After each run, the Hive Mind grows. FILE_OWNERSHIP shows which files were touched. MASTER_INDEX records every task. Pheromones warn about risky areas.

### Phase 2: Feature Expansion

```
Run 3: New Capabilities
├── 🛠️ Carpenter Ant: Add AI chat feature (Gemini/Anthropic)
├── 🛠️ Carpenter Ant: Build real-time KDS display
├── 📊 Harvester Ant: Add analytics dashboard
└── 🌿 Leafcutter: Update manual (auto-triggered by BECCA)
```

**Cross-project learning:** If Sonny discovers that Firebase JWT caching causes stale claims, BECCA writes it to the Global Hivemind. Next time RIZEND's Ant touches auth, it reads that warning.

### Phase 3: Security Hardening

```
Run 4: OPERATION HOTLINE (Sonny's actual security run)
├── 🔥 Fire Ant: Fix 12 auth vulnerabilities
├── 🔥 Fire Ant: Harden Firestore security rules
├── 🛡️ Soldier Ant: Add rate limiting and input sanitization
├── 🔥 Fire Ant: Implement PROFIT SHIELD (cost guardrails)
├── ... (20 tasks total, 78 fixes, 857 tests)
└── 🌿 Leafcutter: Update manual with all new security measures
```

**After this run:** 857 tests, zero critical/high findings remaining. 66 medium/low/info tracked in pheromone registry for future runs.

### Phase 4: Ongoing Maintenance

```
Run 5+: Maintenance & Evolution
├── 🧰 Toolbox Ant: Fix production bugs
├── 🐛 Debugger Ant: Diagnose intermittent failures
├── 🎨 Color Expert Ant: Fix dark mode contrast issues
├── 📈 Analyst Ant: Add usage tracking
└── Operator Manual stays current via Leafcutter auto-dispatch
```

**Manual Drift Detection:** Every 5 runs, Inspector audits the Operator Manual against the codebase. If the manual says 94 functions but there are now 102, a Leafcutter is dispatched to update it.

### The Accumulating Advantage

Each run makes the next one better:

```
Run 1:  No history. Ant works blind.
Run 2:  Hive Mind has 3 tasks, 2 pheromones. Ant knows file history.
Run 5:  Hive Mind has 20 tasks. Ant sees patterns. Ghost catches more.
Run 10: Hive Mind has 50+ tasks. System knows every file's full story.
Run 20: The project has a complete institutional memory.
         Every file has provenance. Every risk is documented.
         New developers (human or AI) can understand the entire history.
```

---

## Part 10: Real Examples — Sonny and RIZEND

### Sonny (AI Pizza SaaS)

| Metric | Value |
|--------|-------|
| Completed NEO Runs | 5 |
| Total Tasks | 20 |
| Cloud Functions | 94 |
| Firestore Collections | 63+ |
| Tests | 896 |
| Security Rules | 738 lines |
| Nuclear Lock | Menu data (PH-MENU-001) — no agent writes without approval |

**Key NEO Decisions:**
- Dual tenant architecture (legacy + SaaS paths) — Ant must check BOTH
- PROFIT SHIELD — cost guardrails for SMS/LLM/TTS
- Menu data is NUCLEAR locked — no automated writes
- Operator Manual: core (375 lines) + 7 appendices (1,190 lines)

### RIZEND (AI Fitness Coaching)

| Metric | Value |
|--------|-------|
| Completed NEO Runs | 3 |
| Total Tasks | 13 |
| Cloud Functions | 155+ |
| Firestore Collections | 80+ |
| Security Rules | 1,440 lines |
| Shared Contracts | 1,626 lines (types + guards) |

**Key NEO Decisions:**
- Flat `businessId` tenant model — every document must have it
- Custom JWT claims for zero-read security rules
- Cross-coach sharing has 5-check guard gate
- Operator Manual: core (339 lines) + 5 appendices

### Cross-Project Patterns (Global Hivemind)

Patterns discovered in one project protect the other:

```
GP-001: ⚫ NUCLEAR — Collection group queries without tenant filter
GP-002: 🔴 HIGH   — Firebase custom claims JWT caching
GP-003: 🔴 HIGH   — Stripe webhook signature verification
GP-004: 🟠 MEDIUM — setDoc() without {merge: true}
GP-005: 🟠 MEDIUM — Emulator-only seed scripts in live paths
GP-006: 🟡 LOW    — Missing composite indexes for compound queries
GP-007: 🟡 LOW    — Unused Firebase service account permissions
```

---

## Part 11: The Complete Flow Diagram

```
YOU: "BECCA ACTIVATE"
 │
 ▼
BECCA: RECON ────────────────────────────────────────────────┐
 │  Read state, history, indexes, manual, hivemind            │
 │  Declare PROJECT LOCK                                      │
 │  "Ready to dispatch Scout → I AM"                          │
 │                                                            │
 ▼  YOU: "I AM"                                               │
BECCA: SCOUT ─────────────────────────────────────────────┐  │
 │  Survey codebase, create TODO with tasks                │  │
 │  "Activate first Ant → I AM"                            │  │
 │                                                         │  │
 ▼  YOU: "I AM"                                            │  │
                                                           │  │
┌──── FOR EACH TASK ──────────────────────────────────┐   │  │
│                                                      │   │  │
│  ANT: ⛑️ CHECKPOINT → DISCOVERY → FOOTPRINT →       │   │  │
│        [BACKUP] → PATCH → VERIFY → REPORT            │   │  │
│        (YOU approve at every gate)                    │   │  │
│                        │                              │   │  │
│  YOU: "I AM"          ▼                              │   │  │
│                                                      │   │  │
│  GHOST: 8-Section Review                             │   │  │
│         → APPROVED or REJECTED                       │   │  │
│                        │                              │   │  │
│  YOU: "I AM"          ▼                              │   │  │
│                                                      │   │  │
│  INSPECTOR: Compliance Audit                         │   │  │
│         → PASS or FAIL                               │   │  │
│                        │                              │   │  │
│         ┌──────────────┼──────────────┐              │   │  │
│         ▼              ▼              ▼              │   │  │
│      PASS         REJECTED/FAIL   All tasks done    │   │  │
│    (next task)    (back to Ant)   (→ BECCA)         │   │  │
│         │              │              │              │   │  │
└─────────┘──────────────┘──────────────┘──────────────┘   │  │
                                                           │  │
 ▼  YOU: "I AM"                                            │  │
BECCA: VERIFY ────────────────────────────────────────────┘  │
 │  Regression check, completeness check                      │
 │                                                            │
 ▼                                                            │
BECCA: CLOSE ─────────────────────────────────────────────────┘
 │  Archive TODO
 │  Update STATE.md
 │  Update RUN_INDEX.md
 │  Update HIVE INDEXES (Master, File Ownership, Pheromones)
 │  Check: dispatch Leafcutter for manual update?
 │  Check: cross-project patterns for Global Hivemind?
 │  Aggregate prompt feedback
 │  Sign off
 │
 ▼
🔑 RUN COMPLETE
```

---

## Part 12: Why This Works for SaaS

### Multi-Tenant Safety

SaaS = multiple customers sharing one codebase. The #1 risk is data leaking between tenants. NEO addresses this:

- **NUCLEAR pheromones** on tenant isolation code
- **Collection group queries without tenant filter** = automatic NUCLEAR STOP
- **Inspector NUCLEAR audit** specifically checks for cross-tenant access
- **Operator Manual** documents the tenant model so every Ant understands it

### Payment Safety

SaaS = recurring revenue. Wrong billing code = financial loss or legal issues.

- **Financial Ant** (🔴 HIGH) gets extra scrutiny at every gate
- **Ghost validates** security/payment impact assessment
- **Stripe integration** patterns shared via Global Hivemind

### Progressive Complexity

SaaS grows over time. NEO grows with it:

- **Operator Manual** starts small, grows as features are added
- **Appendices** keep token costs low (load only what's needed)
- **Hive Mind** accumulates institutional knowledge
- **Run Index** tracks the project's entire evolution
- **Manual Drift Detection** ensures docs stay current

### Recovery

Things go wrong in production. NEO makes recovery easy:

- Every Ant creates a **git checkpoint** before work
- Every data operation requires **backup proof**
- Every change has an exact **rollback plan**
- Every task has a complete **evidence trail**
- The full **run history** tells you exactly what changed and when

---

## Summary: The 5-Checkpoint Chain

Every piece of work passes through **5 checkpoints** before it's considered done:

```
1. THE ANT ── Does the work, produces evidence at every gate
               (7 states, each with mandatory approval)

2. THE GHOST ── Validates the evidence is real, grades quality
                (8-section structured review, auto-reject triggers)

3. THE INSPECTOR ── Audits for compliance, drift, security
                    (8 inspection types, 10-point surgical audit)

4. BECCA VERIFY ── Cross-task regression check
                   (Did later tasks break earlier ones?)

5. BECCA CLOSE ── Archive, index, update manual, cross-project learning
                  (Permanent institutional memory)
```

**Nothing passes without your "I AM."**
**Nothing changes without your approval token.**
**Everything produces evidence.**
**Everything gets reviewed twice.**
**Everything is permanently recorded.**

That's how NEO builds and maintains a SaaS system.
