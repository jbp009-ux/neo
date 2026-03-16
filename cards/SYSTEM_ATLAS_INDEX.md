# SYSTEM ATLAS INDEX
**Version:** 1.1.0
**Policy Pack:** PP-2026-02-27
**Purpose:** Canonical pointer table — links to the 5 files that together form the NEO System Atlas. No rules, no contracts, no logic duplicated here. If it's not in the source file, it doesn't exist.

> "One truth, five locations. This file points. The sources define."

---

## ATLAS SOURCES OF TRUTH

| # | Document | Path | What It Covers |
|---|----------|------|----------------|
| 1 | **GPS Map** | `cards/CARD_GPS_MAP.md` | Every protocol card → exact role prompt section (file, line range, shared module). Card sequences per role. CORE card cross-role mapping. Policy Pack version. |
| 2 | **Gate & Token Reference** | `shared/NEO-GATES.md` (Appendix A) | Master index: S-01→S-45 STOP conditions, V-01→V-13 violations, all gate tokens with emoji, state machine. |
| 3 | **Hive Mind Contracts** | `shared/NEO-HIVE.md` | 6 local indexes (MASTER, FILE_OWNERSHIP, PHEROMONE, LESSONS, REJECTION, FINDINGS) + 1 global (HIVEMIND). Write contracts, sharding rules, pheromone taxonomy. |
| 4 | **Closure & Audit Procedure** | `cards/becca/BECCA_CLOSE_GOVERNANCE.md` | GPS INTEGRITY AUDIT (Quick Check + Deep Check), Framework Health, Protocol Adoption, Fix Escalation, Merge, Sign Off. |
| 5 | **Mission Log & Crash Recovery** | `cards/TASK_CARD_GPS_LINKING.md` | Append-only task log (T/D entries), INCIDENT LOG (populated by GPS audit), crash recovery instructions. |

---

## DEEP SCAN ROTATION SCHEDULE

BECCA performs one deep scan area per closing (step 11e). The schedule cycles through 10 areas, ensuring full system coverage over 10 runs without overloading any single closing.

| SCAN-ID | Area | What To Check | Key Files |
|---------|------|---------------|-----------|
| SCAN-001 | Ant Cards (7) | Card ↔ prompt alignment, acceptance criteria current, step numbering | `cards/ant/ANT_*.md` vs `roles/NEO-ANT.md` |
| SCAN-002 | Ghost + Inspector Cards (4) | Card ↔ prompt alignment, violation list current, verdict format | `cards/ghost/*.md`, `cards/inspector/*.md` vs role files |
| SCAN-003 | BECCA Cards (5) + BECCA Monolith Self-Scan | Card ↔ prompt alignment, checkpoint gates, handoff chain, **plus monolith self-check** (see acceptance criteria below) | `cards/becca/*.md` + `roles/NEO-BECCA.md` + `cards/CARD_GPS_MAP.md` (BECCA anchors) |
| SCAN-004 | Shared Modules (9) | Cross-reference consistency, version headers match changelogs, no orphaned refs | `shared/NEO-*.md` |
| SCAN-005 | PIPELINE EVAL Suite (19 checks) | EVAL checks still valid, no stale refs, scoring formula current | `templates/PIPELINE_EVAL.md` vs actual artifacts |
| SCAN-006 | Pheromone System | HIVE contracts current, registry health, taxonomy complete, sharding rules | `shared/NEO-HIVE.md`, `.neo/index/PHEROMONE_*.md` |
| SCAN-007 | Templates (18) | Field consistency with role expectations, no missing required sections | `templates/*.md` vs role output format specs |
| SCAN-008 | GATES Reference | S-NN/V-NN completeness, token definitions current, Appendix A matches body | `shared/NEO-GATES.md` body vs Appendix A |
| SCAN-009 | DevTools Program | 3 Ant prompts aligned with Chrome DevTools MCP tools, trigger table covers features, evidence standards current, DEVTOOLS_REPORT template complete, F12 cards ↔ prompts aligned | `prompts/DEVTOOLS_*.md`, `cards/ant/F12_*.md`, `templates/DEVTOOLS_REPORT.md`, `cards/becca/BECCA_CLOSE_DEVTOOLS.md` |
| SCAN-010 | Planner System | Planner prompt ↔ cards aligned, decomposition rules consistent with TASK_PACKET format, RUN_PLAN template matches output spec, inbox README current, S-41→S-45 referenced in cards + GATES, BECCA assessment triggers match cards | `prompts/PLANNER_ANT.md`, `cards/planner/*.md`, `templates/RUN_PLAN.md`, `templates/INBOX_README.md`, `cards/becca/BECCA_RECON.md` |

### SCAN-003 ACCEPTANCE CRITERIA (BECCA Self-Scan)

When SCAN-003 runs, BECCA must verify and log these 4 checks with evidence:

| # | Check | What To Verify | Output |
|---|-------|---------------|--------|
| SS-1 | **Anchor Integrity** | Every line range in `CARD_GPS_MAP.md` that references `NEO-BECCA.md` still points to the correct section. Spot-check at least 3 anchors. | `SS-1: PASS (3/3 anchors valid)` or `FAIL (L1054 drift — expected CLOSE, found X)` |
| SS-2 | **Decision Criteria Inline** | Every decision point in CLOSE cards (checkpoints 7-9, GPS verdict, merge go/no-go) restates its threshold inline — no "see above." | `SS-2: PASS (all 3 thresholds inline)` or `FAIL (<which checkpoint missing threshold>)` |
| SS-3 | **Compound Instruction Detection** | Flag any "Do X and Y and Z" in CLOSE cards or BECCA monolith CLOSE sections as skip-risk. Each atomic action should be its own checkbox. | `SS-3: PASS (0 compounds)` or `ISSUES (<count> compound instructions found — propose split)` |
| SS-4 | **Monolith Growth Check** | Record `NEO-BECCA.md` current line count. Compare vs last SCAN-003 entry. Flag if growth >200 lines since last check or total >3,500 lines. | `SS-4: <N> lines (delta: +<M> since last scan). STATUS: OK|WATCH|ALERT` |

**Cycle rules:**
- Each closing runs exactly ONE scan area (the next in sequence)
- Track current position: `SCAN_CYCLE: <cycle_id>, POSITION: <SCAN-00N>`
- When SCAN-010 completes: archive cycle, restart from SCAN-001 with new cycle_id
- If deep scan finds issues: log in INCIDENT LOG (same as GPS audit incidents)
- If deep scan is clean: still log `SCAN-00N: CLEAN` for proof of coverage

---

## HOW TO USE THIS FILE

1. **BECCA RECON**: Read this file to know where all system documentation lives
2. **BECCA CLOSE step 11e**: Read DEEP SCAN ROTATION SCHEDULE to determine which area to scan this run
3. **Crash recovery**: Read this file → then read the 5 source files in order
4. **Prompt Architect**: Read this file to understand system topology before proposing changes
5. **New contributor**: Start here → follow the 5 links to understand the full system

---

## RULES

1. This file is a **pointer only** — no rules, contracts, or logic are defined here
2. If this file contradicts a source file, the source file wins
3. Changes to system structure → update this file's pointer table (not vice versa)
4. Deep scan schedule → update here when new scan areas are added
5. Version this file alongside CARD_GPS_MAP.md (same Policy Pack)
