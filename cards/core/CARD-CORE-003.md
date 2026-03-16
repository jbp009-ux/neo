# CARD-CORE-003: Scope Lock

**Purpose:** Lock the exact scope of changes — what's in, what's out, nothing else
**Phase:** FOOTPRINT (after DISCOVERY, before PATCH)
**Required:** YES — always

## INPUTS REQUIRED
- DISCOVERY findings (what was learned)
- Task packet objective and target files
- Active pheromones on target files

## STEPS (max 5)
1. List EVERY file that will be modified (the FOOTPRINT table)
2. For each file: state the operation type (CODE_ONLY, DATA_WRITE, etc.) and write semantics (PATCH/PUT/DELETE)
3. State what is OUT of scope — changes you will NOT make even if tempting
4. If FOOTPRINT includes critical surfaces: flag them and request `🔑 CRITICAL SURFACE OVERRIDE`
5. Get `🔑 APPROVED FOOTPRINT` from operator before proceeding

## OUTPUT REQUIRED
- FOOTPRINT table (file, operation, semantics, justification)
- OUT OF SCOPE statement
- `🔑 APPROVED FOOTPRINT` token in gate log

## ACCEPTANCE CRITERIA
| # | Check | Pass/Fail |
|---|-------|-----------|
| 1 | FOOTPRINT table lists every file to be changed | |
| 2 | Every file has operation type and write semantics | |
| 3 | OUT OF SCOPE statement present | |
| 4 | `🔑 APPROVED FOOTPRINT` received from operator | |
| 5 | No critical surfaces without override token | |

## FAIL MODE
FAIL_BLOCKING — No patch without locked scope. If operator rejects footprint, revise and re-present.

## MANUAL REFERENCES (per step)
- Step 1: `shared/NEO-EVIDENCE.md` — FOOTPRINT table format (file, operation, semantics, justification)
- Step 2: `shared/NEO-EVIDENCE.md` — Data Op Classification table (valid operation types + write semantics)
- Step 3: `shared/NEO-SURGICAL.md` — Scope Discipline (anti-drift rules)
- Step 4: `shared/NEO-TOOLS.md` — Section 5: Critical Surfaces list; `injections/CRITICAL_SURFACE.md` — override gate
- Step 5: `shared/NEO-GATES.md` — Footprint Gate (🔑 APPROVED FOOTPRINT token rules)
