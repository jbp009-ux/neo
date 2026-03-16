# ANT DISCOVERY CARD
**CARD_ID:** ANT-DISCOVERY | **Phase:** DISCOVERY | **Role:** Ant
**INPUTS:** Completed CHECKPOINT, task objective, target files from packet, HIVE CONTEXT
> Read this card at the start of DISCOVERY. Follow every □ item.

## 1. DISCOVERY STRATEGY (present BEFORE reading code)
□ State ONE QUESTION this task must answer
□ Name the FIRST FILE most likely to answer it
□ List max 3 grep/glob patterns to run
□ State budget expectation: N files, N greps
□ Present to operator. If corrected → update and proceed.

## 2. HIVE MIND CHECK (BEFORE reading code)
□ `grep "<file>" .neo/index/MASTER_INDEX_*.md` → prior tasks
□ `grep -A 20 "## <path>" .neo/index/FILE_OWNERSHIP_<dir>.md` → last touches
□ `grep "ACTIVE" .neo/index/PHEROMONE_*.md | grep "<file>"` → warnings
  → If ⚫ NUCLEAR found: STOP (S-07/S-08) → request clearance
□ `grep "<file>" .neo/index/LESSONS_INDEX_*.md` → GOTCHAs + FRAGILE lessons
□ `grep "<file>" .neo/index/REJECTION_INDEX.md` → prior rejections
□ `grep "RECURRING" .neo/index/FINDINGS_INDEX.md` → framework signals
□ Read `shared/NEO-HIVEMIND-GLOBAL.md` → cross-project patterns

Present HIVE EVIDENCE PROOF (ALL 7 must be YES):

| Index | Read? | Found |
|-------|-------|-------|
| MASTER_INDEX | YES/NO | ... |
| FILE_OWNERSHIP | YES/NO | ... |
| PHEROMONE_REGISTRY | YES/NO | ... |
| LESSONS_INDEX | YES/NO | ... |
| REJECTION_INDEX | YES/NO | ... |
| FINDINGS_INDEX | YES/NO | ... |
| HIVEMIND_GLOBAL | YES/NO | ... |

□ COMMAND PROOF: paste actual grep commands + output (not "I checked")
□ If first run (no .neo/index/): note "First run — no hive data"

## 3. CODE ANALYSIS
□ Read target files (max 5 files, 200 lines, 10 greps)
□ If budget exceeded: STOP (S-14) → request `🔑 DISCOVERY EXPANSION APPROVED`
□ Complete UNDERSTANDING PROOF (LAW 1):
  - Current behavior: what does system DO now?
  - Design intent: WHY designed this way?
  - Hidden constraints: what's intentionally constrained?
  - Blast radius: what breaks at scale if wrong?
  → If ANY cannot be evidenced: STOP — "Looks wrong ≠ is wrong"
□ Check Operator Manual: danger zones, safe ops, intentional patterns
□ NEAREST TRUTH: Code > Config > Manual > Reports > External
  → If sources conflict: REPORT the conflict, do NOT silently pick a side

## 4. CONDITIONAL CHECKS
□ [If SaaS] TENANT ISOLATION SCAN: grep for unscoped queries
  → Breach detected: STOP → S-07/S-08 → ⚫ NUCLEAR pheromone
□ [If SaaS] SECRET SCAN: grep for hardcoded credentials
  → Secrets found: STOP → S-12 → ⚫ NUCLEAR
□ [If creating new] PRE-BUILD SEARCH: glob/grep for existing implementations
  → If existing found: AUDIT existing, do NOT rebuild (S-30)
□ [If data ops] DATA CLASSIFICATION: classify fields T1-T4, flag PII

## 5. OUTPUT (present to operator)
□ SNAPSHOT SUMMARY:
  - Root cause | Affected files | Proposed approach | Risk | Estimated scope
□ BUDGET LEDGER:
  | Resource | Budget | Used | Remaining |
  |----------|--------|------|-----------|
  | Files    | 5      | ?    | ?         |
  | Lines    | 200    | ?    | ?         |
  | Greps    | 10     | ?    | ?         |
□ Discovery Strategy question answered: YES/NO + answer with evidence

## STOP CONDITIONS THIS PHASE
- S-01: Missing required input → BLOCKER
- S-07: Cross-tenant query → ⚫ NUCLEAR
- S-08: Tenant isolation breach → ⚫ NUCLEAR
- S-12: Hardcoded secrets → ⚫ NUCLEAR
- S-14: Evidence budget exceeded → MEDIUM
- S-19: Data looks wrong → investigate, don't assume (HIGH)
- S-20: Urge to rebuild → STOP, investigate first (HIGH)
- S-25: Path outside PROJECT LOCK → BLOCKER
- S-28: Wrong project's files → BLOCKER
- S-30: Claiming code "doesn't exist" without evidence → HIGH

## NEXT

```
🛑 END RESPONSE HERE. Write this as your LAST line:
⏸️ Gate: 🔑 DISCOVERY OK?
Do NOT produce FOOTPRINT output in this same response.
Do NOT proceed until the operator responds.
```

Present findings + hive evidence + snapshot to operator.
Load **ANT_FOOTPRINT** card only AFTER operator approves in their next message.
