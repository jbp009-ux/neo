# ANT PATCH CARD
**CARD_ID:** ANT-PATCH | **Phase:** PATCH | **Role:** Ant
**INPUTS:** 🔑 APPROVED FOOTPRINT, 🔑 BACKUP APPROVED (if data ops), FOOTPRINT table, Evidence Capture Plan
> Read this card after FOOTPRINT (and BACKUP if applicable) are approved. Follow every □ item.

## 1. APPLY CHANGES
□ Apply changes EXACTLY as approved in FOOTPRINT
□ If FOOTPRINT APPROVED WITH CHANGES — incorporate the changes
□ Show exact diffs for every file modified
□ Only touch files listed in FOOTPRINT — nothing else

## 2. TRUTHY DIFFS (all 7 must PASS before presenting)
□ TD-1: Every diff corresponds to a file in FOOTPRINT
□ TD-2: No files modified that aren't in FOOTPRINT
□ TD-3: No ghost files created (files that appear in diff but serve no purpose)
□ TD-4: Diffs match the FOOTPRINT's stated changes (not more, not less)
□ TD-5: No commented-out code left behind (unless FOOTPRINT specified)
□ TD-6: No TODO/FIXME/HACK introduced (unless FOOTPRINT specified)
□ TD-7: Import/export chains intact (no broken references)
  → If ANY fail: STOP — fix before presenting

## 3. ANTI-ASSUMPTION PATTERNS (quick check)
□ A-01: Did NOT modify code I haven't read
□ A-02: Did NOT "fix" data that looks wrong without investigating
□ A-03: Did NOT seed/create demo data in production paths
□ A-04: Did NOT use PUT (replace) when PATCH (merge) was specified
□ A-05: Did NOT delete files outside task scope
□ A-06: Did NOT "rebuild" or "recreate" existing structures
□ A-07: Did NOT assume missing data = broken data
□ A-08: Did NOT remove error handling or guardrails

## 4. SCOPE CHECKS
□ H3 DRIFT: No modifications outside approved scope
□ H4 PRIVILEGE CREEP: No new permissions beyond what's needed
□ Scope contraction: No euphemistic removals ("consolidated", "simplified", "streamlined")

## 5. ERROR RECOVERY
□ If build fails: show full build output, do NOT guess the fix
□ If git conflict: abort, show conflict details, ask operator
□ If test breaks: show output, offer rollback

## STOP CONDITIONS THIS PHASE
- S-02: Tests fail after PATCH → HIGH
- S-15: Build breaks after PATCH → HIGH
- S-29: Feature file/export count decreased → HIGH (needs `🔑 FEATURE REMOVAL OVERRIDE`)
- S-31: Existing feature removed/disabled → HIGH

## NEXT

```
🛑 END RESPONSE HERE. Write this as your LAST line:
⏸️ Gate: 🔑 PATCH OK?
Do NOT produce VERIFY output in this same response.
Do NOT proceed until the operator responds with approval.
```

Present all diffs + Truthy Diffs checklist to operator.
Load **ANT_VERIFY** card only AFTER operator approves in their next message.
