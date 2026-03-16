# CARD-CORE-005: Post-Change Verification

**Purpose:** Verify changes work and nothing is broken BEFORE handing off to Ghost
**Phase:** VERIFY (after PATCH, before REPORT)
**Required:** YES — always

## INPUTS REQUIRED
- Applied patch (diffs from PATCH phase)
- Evidence Capture Plan (from CARD-CORE-004)
- Project test/build commands (from OPERATOR_MANUAL or CLAUDE.md)

## STEPS (max 5)
1. Execute verification commands from Evidence Capture Plan (tests, build, lint)
2. Capture ALL outputs to evidence files in `.neo/audit/evidence/`
3. Run Feature Inventory check: features before vs after (no features lost)
4. Run Truthy Diffs: 7-point check (TD-1 through TD-7)
5. If any verification fails: STOP, do NOT proceed to REPORT

## OUTPUT REQUIRED
- Test output (captured to evidence file)
- Build output (captured to evidence file)
- Feature Inventory before/after comparison
- Truthy Diffs 7-point checklist result
- `🔑 VERIFY APPROVED` token (self-assessed, Ghost will re-check)

## ACCEPTANCE CRITERIA
| # | Check | Pass/Fail |
|---|-------|-----------|
| 1 | All tests pass (or failures explained) | |
| 2 | Build succeeds | |
| 3 | Feature count: after >= before | |
| 4 | Truthy Diffs: all 7 checks pass | |
| 5 | Evidence files exist at declared paths | |

## FAIL MODE
STOP — Do NOT submit report with failing verification. Fix the issue or report the blocker to operator.

## MANUAL REFERENCES (per step)
- Step 1: Project `OPERATOR_MANUAL.md` or `CLAUDE.md` — test/build/lint commands
- Step 2: `shared/NEO-EVIDENCE.md` — Evidence Path Format (`.neo/audit/evidence/` structure)
- Step 3: `shared/NEO-EVIDENCE.md` — Feature Inventory checklist (before/after comparison)
- Step 4: `shared/NEO-SURGICAL.md` — LAW 3: Truthy Diffs (TD-1 through TD-7 checklist)
- Step 5: `shared/NEO-GATES.md` — Verify Gate (🔑 VERIFY APPROVED token rules)
