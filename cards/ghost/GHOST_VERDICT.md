# GHOST VERDICT CARD
**CARD_ID:** GHOST-VERDICT | **Phase:** VERDICT | **Role:** Ghost
**INPUTS:** Completed GHOST-REVIEW checklist, findings list, evidence scores, violation scan results
> Read this card after completing the review checklist. Follow every □ item.

## 0. SELF-AUDIT (before issuing verdict — MANDATORY)
□ Did I check Section 2 HARD GATE items (CARD_RECEIPT, SAAS Safety, Horsemen)? If not, go back now.
□ Count: How many of the 14 compliance checks in GHOST_REVIEW did I actually perform? ___/14
□ If fewer than 14: I missed checks. Go back and complete them before issuing verdict.

## 1. VERDICT CATEGORIES

| Verdict | Token | When |
|---------|-------|------|
| APPROVED | `🔑 GHOST APPROVED` | All checks pass, evidence ≥70% |
| APPROVED WITH FINDINGS | `🔑 GHOST APPROVED` + findings list | Minor issues, none blocking |
| CHANGES REQUESTED | `🔑 GHOST CHANGES REQUESTED: <list>` | Specific fixable deficiencies |
| REJECTED | `🔑 GHOST REJECTED: <reason>` | Evidence <50%, violations, NUCLEAR missed |

## 2. AUTO-REJECT CONDITIONS (any one = REJECTED)
□ Evidence score <50%
□ ANY violation detected (V-01 through V-13)
□ NUCLEAR condition missed (no pheromone emitted)
□ Ant continued after NUCLEAR without `🔑 NUCLEAR RESOLVED`
□ Fabricated evidence detected (test output doesn't match)
□ Evidence re-execution mismatch (Section 4b)
□ TARGET_ENVIRONMENT missing from FOOTPRINT (S-35)
□ H1 HALLUCINATION ❌ DETECTED (Horsemen verdict)
□ CARD_RECEIPT missing or required CORE cards absent without waiver (CDEX)

## 2b. EVIDENCE-CITATION RULE (applies to ALL checklist outputs)
□ Any GPS QUICK CHECK claim (Q1-Q8) without evidence citation → INVALID_CHECK
□ Any HIVE EVIDENCE PROOF claim without file path → INVALID_CHECK
□ INVALID_CHECK is treated as FAIL — uncited claims are not evidence
□ Ghost MUST flag uncited checks as finding: "INVALID_CHECK: Q<N> claimed YES without evidence"

## 3. GHOST_REVIEW OUTPUT (8 sections)
□ Write to `.neo/outbox/ghost/GHOST_REVIEW_<TASK_ID>.md`

| # | Section | Content |
|---|---------|---------|
| 1 | REVIEW SUMMARY | Task ID, Ant Type, evidence score, verdict |
| 2 | ANT TYPE VALIDATION | Type check, risk level, risk-specific checks |
| 3 | REPORT COMPLETENESS | 13-section check results |
| 4 | EVIDENCE VALIDATION | Per-item PASS/FAIL, evidence score |
| 4b | EVIDENCE RE-EXECUTION | Re-run results (if applicable) |
| 5 | COMPLIANCE CHECKS | Surgical, proof-forcing, token, nearest truth, lessons |
| 5b | HIVE MIND COMPLIANCE | 7-index proof, pheromone validation |
| 6 | NUCLEAR & PHEROMONE AUDIT | NUCLEAR check, pheromone completeness |
| 7 | FINDINGS | Finding ID (F-NNN), severity, category, description, evidence |
| 8 | VERDICT & HANDOFF | Verdict token, deficiency list, handoff |

## 4. DEFICIENCY LIST FORMAT
□ For each deficiency:
  - ID: D-NNN
  - Severity: BLOCKER / HIGH / MEDIUM / LOW / INFO
  - Category: EVIDENCE / COMPLIANCE / SURGICAL / NUCLEAR / HIVE / QUALITY / DOD
  - **Rule Triggered: S-NN / V-NN / NONE** (cite specific rule from NEO-GATES Appendix A)
  - **Stage: DISCOVERY / FOOTPRINT / BACKUP / PATCH / VERIFY / REPORT** (where the failure occurred)
  - Description: what's wrong
  - Location: where in the Ant report
  - Required fix: what the Ant must do

> Rule Triggered + Stage enable BECCA to track rejection patterns in REJECTION_INDEX.
> Always cite the most specific rule. If no standard rule applies, use NONE.

## 5. STRIKE 3 DETECTION
□ Count: how many times has this task been rejected? (check REJECTION_INDEX + TODO loop count)
□ Loop 1-2: standard rejection → Ant retries
□ If this would be rejection #3 → STRIKE 3 ESCALATION:
  "⚠️ STRIKE 3: Task <TASK_ID> rejected 3 times. Ant does NOT retry."
  "Recommend: Operator 'I AM' → BECCA reactivates → reads all Ghost reviews → decides:"
  - **DEBUGGER** — same deficiency repeated OR different issue each loop → 🐛 Debugger diagnoses root cause
  - **SPLIT** — scope too large / 5+ files across 3+ dirs → BECCA breaks into sub-tasks
  - **RE-ASSIGN** — wrong Ant type / domain-specific failures → assign correct specialist
  Tie-breaker: prefer DEBUGGER (diagnosis before action)

## 6. TODO UPDATE
□ If APPROVED: mark task stage as "Ghost: APPROVED" in TODO
□ If REJECTED: mark task stage as "Ghost: REJECTED — <reason>" in TODO

## NEXT

```
🛑 END RESPONSE HERE. Write this as your LAST line:
⏸️ Waiting for: I AM
Do NOT produce Inspector audit output or Ant rework output.
Do NOT continue working. The operator decides what happens next.
```

Present full review + verdict to operator.
If APPROVED → suggest: "Activate Inspector? → I AM"
If REJECTED → suggest: "Send back to Ant? → I AM"
