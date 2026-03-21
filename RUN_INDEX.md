# NEO Framework — Run Index

| Run | Date | Tasks | Status | Branch | Commit |
|-----|------|-------|--------|--------|--------|
| 001 | 2026-03-16 | 6 (T-001→T-006) | COMPLETE | main | b4017a7 |
| 002 | 2026-03-20 | 8 (T-007→T-015) | COMPLETE | main | pending |
| 003 | 2026-03-20 | 10 (T-016→T-023) | COMPLETE | main | pending |
| 004 | 2026-03-20 | 3 (T-024→T-026) | COMPLETE | main | pending |
| 005 | 2026-03-20 | 2 (T-027→T-028) | COMPLETE | main | pending |

**Run 005 Summary:** Author Mac-compatible bash scripts for APEX deployment — T-027 (apex-init.sh, 366 lines, bash equiv of apex-init.ps1) and T-028 (apex-refresh.sh, 645 lines, bash equiv of apex-refresh.ps1 incl. Hivemind merge via python3). Zero NEO modifications. Both tasks passed Ant+Ghost+Inspector first-pass.

**Run 005 Analytics:**
- First-pass rate: 100% (2/2) | Deficiency density: 0/task | Pheromone delta: 0
- Band-aid score: 0 (CLEAN) | Velocity: STABLE
- EVAL SCORE: 100% (Grade A) | Avg evidence score: 87%
- Recurring finding: INS-001 (abbreviated report format) — 2nd occurrence → FINDINGS_INDEX signal
- Band-aid score: 0 (CLEAN) | Velocity: STABLE
- EVAL SCORE: 77% (Grade B) — EVAL-05/06/10 all from abbreviated report format (INS-001)
- Deferred: 1 item (cross-project neo-refresh, 1 run old)
- GPS_QUICK: CLEAN (8/8)
- GPS_DEEP: SCAN-005 ISSUES (3 — PIPELINE_EVAL.md stale section refs EVAL-03/12/16 — LOW, FIX_PROPOSAL raised)
- COVERAGE: 5/10 (cycle 1)

**QUICK STATS:** Total runs: 5 | Total tasks: 29 | Total files: 87+

**Run 004 Summary:** Apply 3 GPS FIX_PROPOSALs from Run 003 audit — T-024 (NO-OP: template already correct, execution gap), T-025 (Section 6b CARD COMPLIANCE added to GHOST_REVIEW), T-026 (all 5 BECCA GPS anchors corrected). Zero NEO application changes.

**Run 004 Analytics:**
- First-pass rate: 100% (3/3) | Deficiency density: 0/task | Pheromone delta: +3 INFO (PH-011→PH-013)
- Band-aid score: 0 (CLEAN) | Velocity: IMPROVING (SS-1 raised+resolved same session)
- EVAL SCORE: 100% (Grade A) | Avg evidence score: 100%
- Cross-project signal: governed projects need neo-refresh to receive Section 6b + GPS anchor corrections
- GPS_QUICK: CLEAN (8/8)
- GPS_DEEP: SCAN-004 CLEAN (Shared Modules — 9/9 version headers, no orphaned refs)
- COVERAGE: 4/10 (cycle 1)

**QUICK STATS:** Total runs: 4 | Total tasks: 27 | Total files: 85+

**Run 003 Summary:** Migrate all NEO content to APEX — shared modules (9), CLAUDE.md (1), prompts (14), injections (8), templates (34), scripts (2), blank project template (15 files). APEX now fully operational. Zero NEO modifications. All 10 tasks passed Ant+Ghost+Inspector first-pass.

**Run 003 Analytics:**
- First-pass rate: 100% (10/10) | Deficiency density: 0/task | Pheromone delta: +10 INFO
- Band-aid score: 0 (CLEAN) | Velocity: BASELINE (first run with metrics)
- EVAL SCORE: 100% (Grade A) | Avg evidence score: 99.3%
- GPS_QUICK: SKIPS DETECTED (5/8 — Q2 PP date, Q3 CORE cards, Q4 Ghost section label — all LOW severity)
- GPS_DEEP: SCAN-003 ISSUES (SS-1 FAIL: BECCA-VERIFY/CLOSE anchor drift ~108 lines — FIX_PROPOSAL raised)
- COVERAGE: 3/10 (cycle 1)

**Run 001 Summary:** Track ungoverned framework content — isolation shield (.gitignore), protocol cards (39), prompts (12), templates (11), analysis+injections+playbooks (7), infrastructure (3). First governed run on NEO repo. All gates passed.

**Run 001 Analytics:**
- First-pass rate: 100% (6/6) | Deficiency density: 0/task | Pheromone delta: 0
- Band-aid score: 0 (CLEAN) | Velocity: BASELINE
- EVAL SCORE: 100% (Grade A) | Protocol adoption: 83%
- GPS_QUICK: CLEAN (3/3 applicable)
- GPS_DEEP: SCAN-001 CLEAN (Ant cards — 14/14 aligned)
- COVERAGE: 1/10 (cycle 1)

**Run 002 Summary:** Bootstrap APEX parallel test architecture — 30 dirs, 10 files created in d:\projects\neo-apex\. Deliverables: APEX_ARCHITECTURE.md, STATE_SCHEMAS.json, TENANT_ENVELOPE.json, NODE_PROTOCOL.md, PROMPT_COMPILER.md, SECURITY_MODEL.md, MIGRATION_PLAN.md, README.md. Zero NEO modifications. All 8 tasks passed Ant+Ghost+Inspector.

**Run 002 Analytics:**
- First-pass rate: 100% (8/8) | Deficiency density: 0/task | Pheromone delta: 0
- Band-aid score: 0 (CLEAN) | Velocity: STRONG
- EVAL SCORE: 100% (Grade A) | Protocol adoption: 100%
- GPS_QUICK: CLEAN | GPS_DEEP: pending ANALYTICS card
- GPS_QUICK: CLEAN (7/7 applicable)
- GPS_DEEP: SCAN-002 CLEAN (Ghost + Inspector cards — 6/6 aligned)
- COVERAGE: 2/10 (cycle 1)
