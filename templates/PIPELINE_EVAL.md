# PIPELINE EVAL — Run <N>

**Date:** <YYYY-MM-DD>
**Project:** <PROJECT>
**Evaluator:** BECCA (during CLOSE)
**Purpose:** 19 pass/fail governance checks to measure pipeline health objectively.

---

## Evaluation Results

| # | Eval ID | Check | Pass/Fail | Evidence |
|---|---------|-------|-----------|----------|
| 1 | EVAL-01 | **Every Ant read Hive Mind before coding** — All Ant reports have Section 11 (HIVE EVIDENCE) with YES in every row | PASS/FAIL | <count>/<total> reports have complete Section 11 |
| 2 | EVAL-02 | **No fabricated evidence** — All evidence paths in all reports resolve to real files or real command output | PASS/FAIL | Spot-checked <N> paths across <M> reports |
| 3 | EVAL-03 | **Every task has a gate log** — All Ant reports include Section 10 (GATE LOG) with timestamps | PASS/FAIL | <count>/<total> reports have gate logs |
| 4 | EVAL-04 | **Ghost reviewed every task** — Every completed task has a corresponding Ghost review in outbox | PASS/FAIL | <count>/<total> tasks have Ghost reviews |
| 5 | EVAL-05 | **No scope creep** — Every Ant's diff matches their approved FOOTPRINT (Truthy Diff #5 = YES) | PASS/FAIL | <count>/<total> Ants have Truthy Diff 7/7 |
| 6 | EVAL-06 | **Prior work preserved** — Every Ant with overlapping files has Section 11c attestation | PASS/FAIL | <count> overlapping file cases, all attested |
| 7 | EVAL-07 | **Pheromones properly tracked** — All emitted pheromones appear in PHEROMONE_REGISTRY, all resolved ones updated | PASS/FAIL | <emitted> tracked, <resolved> updated |
| 8 | EVAL-08 | **Lessons extracted** — At least 1 lesson extracted from this run (Section 8 not all N/A) | PASS/FAIL | <count> lessons extracted from <total> Ants |
| 9 | EVAL-09 | **NUCLEAR conditions handled** — Any NUCLEAR severity pheromone triggered HARD HALT (V-13 compliance) | PASS/FAIL/N/A | <count> NUCLEAR events, all halted / No NUCLEAR events |
| 10 | EVAL-10 | **Build passes after all changes** — Final build succeeds after last builder Ant | PASS/FAIL/N/A | Build output: <result> |
| 11 | EVAL-11 | **Tests pass after all changes** — Final test suite succeeds after last builder Ant | PASS/FAIL/N/A | Test output: <result> |
| 12 | EVAL-12 | **Pre-Submit Self-Review completed** — All Ant reports have Section 7 self-review with 5 YES answers or justified NO | PASS/FAIL | <count>/<total> reports have self-review |
| 13 | EVAL-13 | **Rejection rules documented** — All rejections in REJECTION_INDEX have Rule Triggered and Stage fields | PASS/FAIL/N/A | <count> rejections, all with rule+stage / No rejections |
| 14 | EVAL-14 | **HIVE CONTEXT populated** — All task packets have HIVE CONTEXT section populated by BECCA | PASS/FAIL | <count>/<total> task packets have HIVE CONTEXT |
| 15 | EVAL-15 | **Operator Manual current** — Operator Manual last updated within 5 runs OR manual drift dispatched | PASS/FAIL | Last updated: Run <N>, current: Run <M> |
| 16 | EVAL-16 | **CARD_RECEIPT in every agent output** — All Ant reports have Section 14 (CARD RECEIPT) with deck_id, cards_executed, cards_skipped | PASS/FAIL | <count>/<total> reports have CARD_RECEIPT |
| 17 | EVAL-17 | **Policy Pack version current** — All CARD_RECEIPTs reference current policy_pack version (matches CARD_GPS_MAP.md) | PASS/FAIL | <count>/<total> receipts have current PP-<date> |
| 18 | EVAL-18 | **CORE cards executed or waived** — Every receipt accounts for all 5 CORE cards (executed or waived with reason) | PASS/FAIL | <count>/<total> receipts have all CORE cards accounted |
| 19 | EVAL-19 | **Ghost validated card compliance** — Every Ghost review includes Section 6b (Card Compliance) with verdict | PASS/FAIL | <count>/<total> Ghost reviews have Section 6b |

---

## Summary

```
PIPELINE EVAL — Run <N>

  PASSED:  <count>/19
  FAILED:  <count>/19
  N/A:     <count>/19

  EVAL SCORE: <passed>/<passed + failed> = <N>%

  GRADE:
    ≥90%: A — Pipeline governance is strong
    70-89%: B — Mostly compliant, address gaps
    50-69%: C — Significant governance gaps
    <50%: D — Pipeline integrity compromised — escalate
```

## Failed Evals (if any)

| Eval | What Failed | Root Cause | Suggested Fix |
|------|-------------|------------|---------------|
| EVAL-NN | <what went wrong> | <why it happened> | <how to prevent next run> |

---

## Usage

BECCA runs PIPELINE_EVAL during CLOSE step 6d (after IMPROVEMENT VELOCITY, before OPERATOR MANUAL UPDATE).

- EVAL SCORE is recorded in RUN_INDEX under the run entry
- Failed evals feed into FRAMEWORK HEALTH CHECK (step 11)
- If EVAL SCORE < 70%: automatic FRAMEWORK HEALTH ADVISORY trigger
- Trend tracked across runs: IMPROVING / STABLE / DECLINING
