# Protocol Cards — Phase-Specific Instructions for Claude AI

## What Are Protocol Cards?

Protocol Cards are slim, phase-specific instruction files (50-100 lines each) that replace loading the entire NEO protocol (~8,000 lines) at once. Each card contains ONLY what Claude needs at THAT step — actions, checks, outputs, gate tokens, and stop conditions.

**Why:** Claude's attention degrades with context length. Rules on line 3,000 get less weight than rules on line 50. Cards keep every instruction within the first 100 lines of active context.

## How To Use

### For BECCA (dispatching tasks)
Include in the task packet:
```
## PROTOCOL CARDS
Load cards in sequence as you progress through phases:
1. cards/ant/ANT_CHECKPOINT.md → complete → proceed
2. cards/ant/ANT_DISCOVERY.md → complete → present → wait for gate
3. cards/ant/ANT_FOOTPRINT.md → complete → present → wait for gate
4. cards/ant/ANT_BACKUP.md → (if data ops) → complete → wait for gate
5. cards/ant/ANT_PATCH.md → complete → present → wait for gate
6. cards/ant/ANT_VERIFY.md → complete → present → wait for gate
7. cards/ant/ANT_REPORT.md → complete → present → wait for gate

Reference cards (load once, keep available):
- cards/ref/GATE_TOKENS.md
- cards/ref/STOP_CONDITIONS.md
```

### For Operators (mid-session injection)
```
Read cards/ant/ANT_VERIFY.md and follow it.
```

### When Stuck
Full reference manuals remain the authority:
- `roles/NEO-ANT.md` + `shared/` modules

## Card Inventory

| Dir | Card | Lines | Phase |
|-----|------|-------|-------|
| **core/** | CARD-CORE-001.md | ~45 | ALL — Load Policy Pack + Pheromones |
| **core/** | CARD-CORE-002.md | ~45 | Ant — Backup-First Proof (conditional) |
| **core/** | CARD-CORE-003.md | ~40 | Ant — Scope Lock |
| **core/** | CARD-CORE-004.md | ~40 | Ant — Evidence Capture Plan |
| **core/** | CARD-CORE-005.md | ~40 | Ant — Post-Change Verification |
| **ref/** | GATE_TOKENS.md | ~55 | All roles — complete token vocabulary |
| **ref/** | STOP_CONDITIONS.md | ~55 | All roles — S-01 to S-37 quick reference |
| **ant/** | ANT_CHECKPOINT.md | ~50 | Activation, TODO, Project Lock, Git checkpoint |
| **ant/** | ANT_DISCOVERY.md | ~85 | Strategy, Hive Mind, Code Analysis, Snapshot |
| **ant/** | ANT_FOOTPRINT.md | ~80 | Data Op Classification, Features, Risk, Pheromones |
| **ant/** | ANT_BACKUP.md | ~50 | Backup creation, Restore test (conditional) |
| **ant/** | ANT_PATCH.md | ~65 | Apply changes, Truthy Diffs, Scope check |
| **ant/** | ANT_VERIFY.md | ~75 | Tests, CI/CD, Feature Inventory |
| **ant/** | ANT_REPORT.md | ~75 | 13-section report, Lessons, Preflight, Handoff |
| **ghost/** | GHOST_REVIEW.md | ~135 | 14-section review + violations + Horsemen + re-execution |
| **ghost/** | GHOST_VERDICT.md | ~70 | Verdict categories, Strike 3 escalation, TODO update |
| **inspector/** | INSPECTOR_AUDIT.md | ~125 | 10 inspection types with checklists + Horsemen audit |
| **inspector/** | INSPECTOR_VERDICT.md | ~50 | Severity levels, verdict, report structure |
| **becca/** | BECCA_RECON.md | ~80 | Index health, pheromone triage, manual drift |
| **becca/** | BECCA_VERIFY.md | ~60 | Regression, completeness, consistency |
| **becca/** | BECCA_CLOSE_ARCHIVE.md | ~87 | Steps 1-5: state, archive, RUN_INDEX, 6 HIVE indexes + 2 checkpoints |
| **becca/** | BECCA_CLOSE_ANALYTICS.md | ~129 | Steps 6-10: metrics, band-aid, velocity, eval, manual, hivemind, feedback, retro + 4 checkpoints |
| **becca/** | BECCA_CLOSE_DEVTOOLS.md | ~80 | Step 10.5: DevTools verification hard gate — trigger assessment, dispatch Sentinel + specialists, aggregate verdict |
| **becca/** | BECCA_CLOSE_GOVERNANCE.md | ~160 | Steps 11-13: health, adoption, escalation, GPS Quick/Deep audit, rotating deep scan, scan log, merge, sign off + 3 checkpoints |
| **ant/** | F12_SETUP.md | ~50 | DevTools setup — MCP verification, page inventory, navigate |
| **ant/** | F12_CONSOLE_AUDIT.md | ~60 | Console scan — classify errors/warnings, capture stack traces |
| **ant/** | F12_NETWORK_AUDIT.md | ~70 | Network scan — 4xx/5xx, auth leaks, PII exposure, duplicates |
| **ant/** | F12_VISUAL_SNAPSHOT.md | ~50 | Visual baseline — screenshots, snapshots, dark mode check |
| **ant/** | F12_PERF_TRACE.md | ~70 | Performance trace — CWV capture, throttle test, regression check |
| **ant/** | F12_STATE_INSPECTION.md | ~70 | State validation — localStorage, auth state, tenant isolation |
| **ant/** | ANT_F12_STRESS.md | ~80 | Stress test — chat playbook execution, scenario evaluation, recording check |
| **planner/** | PLANNER_SKELETON.md | ~100 | Planner Pass 1 — inbox scan, hive mind check, task decomposition, skeleton output |
| **planner/** | PLANNER_DETAIL.md | ~110 | Planner Pass 2 — per-task enrichment, TASK_PACKET generation, RUN_PLAN output |

**33 cards total + 1 Atlas index. ~2,520 lines vs ~8,000+ lines today.**

### System Atlas
| File | Lines | Purpose |
|------|-------|---------|
| SYSTEM_ATLAS_INDEX.md | ~65 | Pointer-only TOC — links to 5 Atlas source files + deep scan rotation schedule. No rules duplicated. |

## CDEX: Card-Deck Execution System

**Prime directives:**
- "If it isn't on a card, it didn't happen."
- "If it didn't produce a receipt, it isn't accepted."

Every run has a CARD_DECK (generated by BECCA in RECON). Three card layers:
- **CORE cards** — always required, governance + safety ("you shall not pass" set)
- **TASK cards** — per-task, generated from task packet by BECCA
- **TOOL cards** — project-specific (test, build, deploy), from Operator Manual

Every agent output MUST include a **CARD_RECEIPT** listing:
- `deck_id`, `cards_executed`, `cards_skipped`, `card_outputs_attached`, `blockers`

Missing CARD_RECEIPT → `OUTPUT_INVALID: CARD_COMPLIANCE_FAILED`

Skipping a card requires a **CARD_WAIVER** with: reason, risk, mitigation, approver.
No waiver → no skip → NUCLEAR.

### Sub-Decks (Nested Index)
A Master Card can point to a **Sub-Deck** (`SD-<ID>`) — a nested set of cards for complex operations. Sub-Decks have their own receipt. Max nesting depth = 1. See `templates/CARD_DECK.md` for full rules.

### GPS Map
`cards/CARD_GPS_MAP.md` maps every card to exact role prompt sections (file, line number, shared module). Policy Pack version tracks map currency.

### Mission Log
`cards/TASK_CARD_GPS_LINKING.md` is the crash-proof append-only log. If a session crashes mid-implementation, the next session reads this file to resume.

## Design Principles

1. **Checklist format** — □ items, not prose paragraphs
2. **Tables over text** — output formats shown as tables
3. **Exact tokens** — every gate token spelled with emoji
4. **Phase-specific STOPs** — only the S-NNs that apply to THIS step
5. **Self-contained** — Claude never needs to cross-reference another file
6. **Action-oriented** — "DO this, CHECK this, OUTPUT this, WAIT for this"
