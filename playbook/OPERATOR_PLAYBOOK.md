# NEO OPERATOR PLAYBOOK
## Your Complete Training Manual

**Version:** 1.0.0
**Last Updated:** 2026-02-12
**For:** The human operator (you) — NOT for AI agents

---

## What Is NEO?

NEO is your AI governance pipeline. It's a 4-role system that lets you run AI agents safely on your codebases without them breaking things.

**The 4 Roles:**

| Role | Who | What They Do |
|------|-----|-------------|
| **BECCA** | Orchestrator | Plans the run, dispatches tasks, indexes results, closes runs |
| **ANT** | Worker | Reads code, proposes changes, applies patches, runs tests |
| **GHOST** | Reviewer | Validates the Ant's evidence, catches lies, grades work |
| **INSPECTOR** | Auditor | Audits for compliance, drift, NUCLEAR violations |

**You** are the operator. Every gate requires YOUR approval. Nothing happens without you saying yes.

---

## How a Run Works (Start to Finish)

```
YOU: "BECCA ACTIVATE" (or "deep dive into Sonny")
 │
 ├─ BECCA runs RECON
 │   → Checks project state, reads history, scans for risks
 │   → Presents summary: "Here's what I found"
 │   → Declares PROJECT LOCK (all work locked to one project)
 │
 ├─ BECCA dispatches SCOUT
 │   → Scout surveys the codebase, finds bugs/issues/improvements
 │   → Creates TODO_<PROJECT>.md with prioritized tasks
 │   → YOU approve the TODO
 │
 ├─ For each task in the TODO:
 │   │
 │   ├─ YOU: "I AM" → activates the ANT
 │   │   → Ant reads code (DISCOVERY)
 │   │   → Ant proposes changes (FOOTPRINT) → YOU approve
 │   │   → Ant backs up data if needed (BACKUP) → YOU approve
 │   │   → Ant applies changes (PATCH) → YOU approve
 │   │   → Ant runs tests (VERIFY) → YOU approve
 │   │   → Ant writes report (REPORT) → YOU approve
 │   │
 │   ├─ YOU: "I AM" → activates the GHOST
 │   │   → Ghost reviews the Ant's report (8-section Index 8)
 │   │   → Ghost may request evidence re-execution
 │   │   → Ghost gives verdict: APPROVED or REJECTED
 │   │
 │   ├─ YOU: "I AM" → activates the INSPECTOR
 │   │   → Inspector audits for compliance, drift, NUCLEAR issues
 │   │   → Inspector gives verdict: PASS or FAIL
 │   │
 │   └─ If FAIL → loop back to Ant. If PASS → next task.
 │
 └─ After all tasks:
     YOU: "I AM" → activates BECCA for CLOSE
     → Archives TODO, updates indexes, checks for manual drift
     → Writes cross-project lessons to global hivemind
     → Run complete
```

---

## The Magic Words

| Command | What It Does |
|---------|-------------|
| `"BECCA ACTIVATE"` | Starts a new run on a project |
| `"I AM"` | Activates the next role in the pipeline |
| `"Y"` or `"approved"` | Approves a gate (FOOTPRINT, BACKUP, PATCH, VERIFY, REPORT) |
| `"N"` or `"rejected"` | Rejects — sends back for revision |
| Numbers (`"1"`, `"2"`) | Selects options when BECCA presents choices |

---

## Gate Approvals — What to Look For

### DISCOVERY (Ant shows you what it found)
- Does the Ant understand the problem correctly?
- Did it check the Operator Manual for known patterns?
- Is the root cause hypothesis reasonable?

### FOOTPRINT (Ant proposes changes)
- Is the scope minimal? (Less is better)
- Are the right files targeted?
- Does the Data Op Classification make sense? (CODE_ONLY vs DATA_WRITE)
- Are any DANGER ZONE files being touched?

### BACKUP (if data operations)
- Was a backup actually created?
- Is there a restore path?
- Only appears for DATA_WRITE/DELETE/MIGRATION tasks

### PATCH (Ant shows the actual code changes)
- Do the diffs look correct?
- Are changes confined to the approved FOOTPRINT?
- No unexpected files touched?

### VERIFY (Ant runs tests)
- Did tests pass?
- Did the build succeed?
- Did lint/type-check pass?

### REPORT (Ant writes its final report)
- 13 sections present?
- Lessons captured?
- Pheromones emitted for any risks?

---

## Red Flags to Watch For

### During ANY Gate
- Ant saying "I assume..." → STOP. Assumptions = mistakes.
- Ant touching files outside approved FOOTPRINT → REJECT.
- Ant skipping the Operator Manual check → REJECT.
- Any mention of `setDoc()` without `merge: true` → investigate.
- Any `firebase deploy --only functions` (all functions) → ask for targeted deploy.

### During Ghost Review
- Evidence score below 70% → concerning (below 50% = auto-reject)
- Ghost says "UNVERIFIED" → Ant's test results weren't re-run. Consider re-running.
- NUCLEAR finding → task MUST be rejected. No exceptions.

### During Inspector Audit
- MANUAL_DRIFT findings → manual is out of date, Leafcutter needed
- HIVE inconsistencies → indexes need repair
- SURGICAL violations → Ant didn't follow the 3 Laws

---

## Understanding Pheromones

Pheromones are risk markers that persist across runs. They're the colony's memory of danger.

| Severity | Icon | Meaning | Action |
|----------|------|---------|--------|
| NUCLEAR | ⚫ | Catastrophic risk (data loss, security breach) | STOP. Must be resolved before ANY work on that file. |
| HIGH | 🔴 | Significant risk | Proceed with caution. Extra review required. |
| MEDIUM | 🟠 | Moderate risk | Noted. Monitor across runs. |
| LOW | 🟡 | Minor risk | Informational. Fix when convenient. |
| INFO | 🟢 | Observation | No action needed. |

**Active pheromones** block work on affected files until resolved.
**Resolved pheromones** stay in the registry (historical record) but don't block.

---

## Understanding the Hive Mind

The Hive Mind is the colony's permanent memory. Three index files:

| Index | What It Tracks | Why It Matters |
|-------|---------------|---------------|
| **MASTER_INDEX** | Every completed task (one line each) | Know what was done and when |
| **FILE_OWNERSHIP** | Which tasks touched which files | Know a file's full history |
| **PHEROMONE_REGISTRY** | Active risk warnings | Know what's dangerous right now |

Plus the **Global Hivemind** (`NEO-HIVEMIND-GLOBAL.md`) — lessons that apply across ALL projects.

**Only BECCA writes to indexes.** This is intentional — single writer prevents corruption.

---

## Project-Specific Briefings

Detailed project knowledge is in separate briefing files:

| File | Project |
|------|---------|
| [SONNY_BRIEFING.md](SONNY_BRIEFING.md) | Sonny — AI Pizza SaaS |
| [RIZEND_BRIEFING.md](RIZEND_BRIEFING.md) | Rizend — AI Fitness Coaching |

Each briefing covers: what the project does, key architecture, danger zones, what to watch for during runs, and deploy procedures.

---

## Daily Operations Quick Reference

See [CHEAT_SHEET.md](CHEAT_SHEET.md) for a one-page quick reference of common commands and workflows.

---

## When Things Go Wrong

### Ant Gets Rejected by Ghost
Normal. Ghost caught something. The Ant will be re-activated with the Ghost's feedback. Just say "I AM" to re-activate the Ant.

### Inspector Fails a Task
Similar to Ghost rejection. Inspector found a compliance issue. Ant loops back to fix. Say "I AM".

### NUCLEAR Pheromone Blocks Work
You must explicitly clear it. Read the pheromone details, understand the risk, then tell BECCA to proceed (or don't). This is the system protecting your data.

### Chat Crashes / Context Too Long
This happens with large runs. Create a TODO.md capturing where you are, then start a fresh session. BECCA will read STATE.md and pick up where you left off.

### Wrong Project Lock
If BECCA locked to the wrong project, start a new run. Project lock is per-run, not permanent.

### Manual Is Out of Date
Run a MANUAL_DRIFT inspection (Inspector will tell you what drifted). Then dispatch a Leafcutter Ant to update. BECCA auto-checks this every 5 runs.

---

## The 3 Laws of Surgical Change

Every Ant follows these. Know them so you can spot violations:

1. **LAW 1: Understand Before Touching** — Ant must prove it understands current behavior, design intent, hidden constraints, and blast radius. No assumptions.

2. **LAW 2: Protect Data** — Any operation that writes, deletes, or migrates data requires backup proof and your explicit BACKUP APPROVED token.

3. **LAW 3: Minimum Effective Change** — Smallest possible change. PATCH (merge) by default, never PUT (replace) unless justified. No "while I'm here" improvements.

---

## Terminology

| Term | Meaning |
|------|---------|
| **Run** | A batch of tasks on one project (RECON → tasks → CLOSE) |
| **Task** | A single unit of work (Ant → Ghost → Inspector) |
| **Gate** | A point where YOU must approve before continuing |
| **Token** | A gate approval marker (e.g., FOOTPRINT APPROVED) |
| **Pheromone** | A risk marker that persists across runs |
| **Hive Mind** | The colony's indexes (permanent memory) |
| **Nuclear Lock** | A pheromone that blocks ALL writes to specific data |
| **Leafcutter** | An Ant type that only updates documentation |
| **Scout** | An Ant type that surveys the codebase and creates the TODO |
| **Index 8** | Ghost's 8-section review format |
| **HOTLINE** | Sonny's security hardening operation (78 fixes, 857 tests) |
| **PROFIT SHIELD** | Sonny's usage/cost guardrail system |
