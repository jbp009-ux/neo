# CARD-CORE-004: Evidence Capture Plan

**Purpose:** Define what evidence will be captured BEFORE doing the work — no post-hoc fabrication
**Phase:** FOOTPRINT (declared before PATCH)
**Required:** YES — always

## INPUTS REQUIRED
- FOOTPRINT table (what files change)
- Task packet success criteria
- Definition of Done criteria

## STEPS (max 5)
1. For each success criterion: state what evidence will prove it (test output, screenshot, diff, log)
2. For each file in FOOTPRINT: state what verification method applies (test, manual check, build)
3. Identify evidence artifacts that will be captured (file paths in `.neo/audit/evidence/`)
4. State the verification command(s) that will run (npm test, build, grep, etc.)
5. Declare the plan — this becomes the contract Ghost checks against

## OUTPUT REQUIRED
- Evidence capture plan table
- List of expected evidence artifact paths
- Verification commands to execute

## ACCEPTANCE CRITERIA
| # | Check | Pass/Fail |
|---|-------|-----------|
| 1 | Every success criterion has a mapped evidence source | |
| 2 | Every FOOTPRINT file has a verification method | |
| 3 | Evidence artifact paths declared (not "TBD") | |
| 4 | Verification commands are specific (not "run tests") | |

## FAIL MODE
FAIL_BLOCKING — Ghost will reject reports where evidence doesn't match the plan. Declare your evidence plan upfront.

## MANUAL REFERENCES (per step)
- Step 1: `shared/NEO-EVIDENCE.md` — Evidence Requirements (what counts as evidence per claim type)
- Step 2: `shared/NEO-EVIDENCE.md` — Verification Methods (test, manual check, build, screenshot)
- Step 3: `shared/NEO-EVIDENCE.md` — Evidence Path Format (`.neo/audit/evidence/` structure)
- Step 4: Project `OPERATOR_MANUAL.md` — Build & Test Commands section
- Step 5: `cards/ghost/GHOST_REVIEW.md` — Evidence Validation section (what Ghost checks against)
