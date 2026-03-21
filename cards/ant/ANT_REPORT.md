# ANT REPORT CARD
**CARD_ID:** ANT-REPORT | **Phase:** REPORT | **Role:** Ant
**INPUTS:** 🔑 VERIFY APPROVED, all phase outputs (DISCOVERY→VERIFY), evidence artifacts, HIVE CONTEXT
> Read this card after VERIFY is approved. Follow every □ item.

## 1. REPORT STRUCTURE (13 sections)
□ Write ANT_REPORT to `.neo/outbox/ants/ANT_REPORT_<TASK_ID>.md`

| # | Section | Content |
|---|---------|---------|
| 1 | TASK SUMMARY | Task ID, Ant Type, objective, success criteria, verdict |
| 1b | DISCOVERY STRATEGY | ONE QUESTION + answer + evidence reference |
| 2 | DISCOVERY FINDINGS | Code analysis, snapshot summary, budget ledger |
| 3 | FOOTPRINT | Data op classification, feature impact, target environment |
| 4 | BACKUP (if applicable) | Backup proof table, restore test |
| 5 | PATCH | Diffs, truthy diffs checklist (7/7), anti-assumption check |
| 6 | VERIFICATION | Test/build/lint results, CI/CD table, Feature Inventory (before/after table: what existed → what changed) |
| 7 | EVIDENCE | All file paths, line numbers, diffs — no placeholders |
| 8 | LESSONS FOR FUTURE ANTS | See categories below |
| 9 | PHEROMONES | Emitted + resolved pheromones |
| 10 | ROLLBACK PLAN | Exact steps to undo all changes |
| 11 | HIVE EVIDENCE | Hive Mind Briefing + 7-row proof table (use this exact format): |

```
| Index | Checked? | Finding |
|-------|----------|---------|
| MASTER_INDEX | YES/NO | <what you found or "no relevant entries"> |
| FILE_OWNERSHIP | YES/NO | <owner/run for target files or "new file"> |
| PHEROMONE_MEDIUM | YES/NO | <active pheromones on target files or "none"> |
| LESSONS_INDEX | YES/NO | <relevant lessons or "none"> |
| REJECTION_INDEX | YES/NO | <prior rejections in this area or "none"> |
| FINDINGS_INDEX | YES/NO | <relevant recurring findings or "none"> |
| NEO-HIVEMIND-GLOBAL | YES/NO | <relevant cross-project patterns or "none"> |
```
| 12 | SELF-ASSESSMENT | Honest evaluation, confidence level |
| 13 | PROMPT FEEDBACK | See categories below |

## 2. LESSONS FOR FUTURE ANTS (Section 8)
□ For each lesson, classify:
  - WHAT_WORKED: approach that succeeded — repeat it
  - GOTCHA: trap or surprise — watch out
  - FRAGILE: file or pattern that breaks easily
  - APPROACH: how to tackle this kind of task
  - VERIFICATION: how to verify changes in this area

## 3. PROMPT FEEDBACK (Section 13)
□ For each feedback item, classify:
  - HELPED: rule/protocol that was useful
  - CONFUSED: rule that was unclear or contradictory
  - MISSING: rule that should exist but doesn't
  - OVERKILL: rule that added friction without value

## 4. SAAS SAFETY PREFLIGHT (10-item one-pass check)
□ Tenant isolation scan performed? YES/NO/N/A
□ Secret scan performed? YES/NO
□ Data classification done? YES/NO/N/A
□ TARGET_ENVIRONMENT declared? YES/NO
□ Production confirmed (if applicable)? YES/NO/N/A
□ Destructive op log complete? YES/NO/N/A
□ Restore test passed (if applicable)? YES/NO/N/A
□ No PII in report? YES/NO
□ No secrets in report? YES/NO
□ NUCLEAR incidents (if any) properly halted? YES/NO/N/A

## 5. HORSEMEN SELF-CHECK
□ H1 HALLUCINATION: All claims backed by evidence?
□ H2 AMNESIA: Hive Mind consulted? Lessons acknowledged?
□ H3 DRIFT: Stayed within approved scope?
□ H4 PRIVILEGE CREEP: No unnecessary permission escalation?
□ H5 SILENT FAILURE: All errors surfaced?

## 5b. PRE-SUBMIT SELF-REVIEW (8 checks — MANDATORY)
□ Did I read HIVE CONTEXT and act on injected lessons?
□ Are ALL evidence paths real, not placeholders?
□ Did I stay within FOOTPRINT — no files outside approved scope?
□ Would Ghost find real diffs if they checked my claims?
□ Did I self-check for the Five Horsemen? (Section 5 above — all 5 must be answered)
□ Is CARD_RECEIPT present? (deck_id, cards_executed, card_outputs, **policy_pack_version: PP-XXXX** — Ghost AUTO REJECTs if missing)
□ Is SAAS SAFETY PREFLIGHT present? (Section 4 above — all 10 items answered)
□ Is HORSEMEN SELF-CHECK present? (Section 5 above — all 5 items answered)
**→ If ANY answer is NO: fix it BEFORE submitting. Do NOT submit with known deficiencies.**
**→ Ghost will AUTO REJECT if CARD_RECEIPT is missing (S-38). Do not skip it.**

## 6. GATE LOG
□ Include complete gate log (all tokens received during task)

## NEXT

```
🛑 END RESPONSE HERE. Write this as your LAST line:
⏸️ Waiting for: I AM (Ghost)
Do NOT produce Ghost review output. Do NOT continue working.
Do NOT start the next task. Your work on this task is DONE.
The operator must say "I AM" to activate Ghost for review.
```

Present full report to operator.
Save report to `.neo/outbox/ants/ANT_REPORT_<TASK_ID>.md`.
