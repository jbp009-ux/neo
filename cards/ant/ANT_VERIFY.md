# ANT VERIFY CARD
**CARD_ID:** ANT-VERIFY | **Phase:** VERIFY | **Role:** Ant
**INPUTS:** 🔑 APPROVED PATCH, applied diffs, Evidence Capture Plan, test/build commands from Operator Manual
> Read this card after PATCH is approved. Follow every □ item.

## 1. LOCAL VERIFICATION
□ Run tests: `npm test` (or project's test command)
□ Run build: `npm run build` (or project's build command)
□ Run lint: `npm run lint` (if available)
□ Run type-check: `npx tsc --noEmit` (if TypeScript)
□ Record all output — actual commands + actual results

## 2. CI/CD VERIFICATION
□ Check CI status: `gh run list --limit 5`
□ Wait for green (if CI runs on push)
□ If Vercel: `vercel ls` → check latest deployment
□ Present CI/CD STATUS TABLE:
  | Check | Command | Result | Status |
  |-------|---------|--------|--------|
  | Tests | npm test | ... | ✅/❌ |
  | Build | npm run build | ... | ✅/❌ |
  | CI | gh run list | ... | ✅/❌ |

## 3. SUCCESS CRITERIA
□ For each criterion from task packet: explicitly PASS or FAIL
  | # | Criterion | Result | Evidence |
  |---|-----------|--------|----------|
  | 1 | <from task> | PASS/FAIL | <reference> |

## 4. RISK-SPECIFIC EXTRAS
□ 🔴 HIGH (Fire/Financial/Color): domain-specific tests (auth flow, payment flow, permission tests)
□ 🟠 MEDIUM (Soldier): edge-case validation tests (empty input, boundary values, bypass attempts)
□ 🟡🟢 STANDARD/LOW: no additional requirements

## 5. FEATURE INVENTORY (mandatory)
□ Compare before/after for all features in scope:
  | Feature | Files Before | Files After | Exports Before | Exports After | Delta | Status |
  |---------|-------------|-------------|----------------|---------------|-------|--------|
□ If Delta is NEGATIVE without `🔑 FEATURE REMOVAL OVERRIDE` → STOP (S-29)

## 6. CONDITIONAL CHECKS
□ [If destructive ops] DESTRUCTIVE OPERATION LOG:
  | # | Operation | Target | Before State | After State | Reversible? |
  |---|-----------|--------|-------------|-------------|-------------|
□ [If DELETE/MIGRATION] RESTORE TEST PROOF:
  | Field | Value |
  |-------|-------|
  | Environment | <where tested> |
  | Records backed up | <N> |
  | Records restored | <N> |
  | Sample verified | YES/NO |
  | Result | PASS/FAIL |

## 7. HORSEMEN CHECKS
□ H1 HALLUCINATION: Am I claiming results I didn't actually observe?
□ H5 SILENT FAILURE: Are there any errors I'm sweeping under the rug?

## STOP CONDITIONS THIS PHASE
- S-02: Tests fail → HIGH
- S-15: Build breaks → HIGH
- S-29: Feature count decreased → HIGH
- S-31: Feature removed/disabled → HIGH
- S-32: TODO run number ahead of STATE.md → BLOCKER

## NEXT

```
🛑 END RESPONSE HERE. Write this as your LAST line:
⏸️ Gate: 🔑 VERIFY OK?
Do NOT produce REPORT output in this same response.
Do NOT proceed until the operator responds with approval.
```

Present verification results + CI/CD table + feature inventory to operator.
Load **ANT_REPORT** card only AFTER operator approves in their next message.
