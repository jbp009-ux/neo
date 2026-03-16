# STOP CONDITIONS — S-01 to S-45 Quick Reference
> When a STOP triggers: HALT, present evidence, WAIT for 🔑 CONTINUE / 🔑 GO / specific gate token.

| ID | Trigger | Severity |
|----|---------|----------|
| S-01 | Missing required input | BLOCKER |
| S-02 | Tests fail after PATCH | HIGH |
| S-03 | Scope creep detected | HIGH |
| S-04 | Security concern found | HIGH |
| S-05 | Unrecoverable error → HALTED | BLOCKER |
| S-06 | Evidence validation fails (Ghost) | HIGH |
| S-07 | Cross-tenant query detected | ⚫ NUCLEAR |
| S-08 | Tenant isolation breach | ⚫ NUCLEAR |
| S-09 | Permission escalation attempted | HIGH |
| S-10 | Environment mismatch | HIGH |
| S-11 | Race condition risk identified | MEDIUM |
| S-12 | Hardcoded secrets found | ⚫ NUCLEAR |
| S-13 | Critical surface edit without override | HIGH |
| S-14 | Evidence budget exceeded | MEDIUM |
| S-15 | Build breaks after PATCH | HIGH |
| S-16 | Dependency vulnerability found | MEDIUM |
| S-17 | Data deletion operation proposed | HIGH |
| S-18 | *(reserved)* | — |
| S-19 | Data looks "incomplete" or "wrong" → investigate, don't fix | HIGH |
| S-20 | Urge to "recreate" or "rebuild" data → investigate first | HIGH |
| S-21 | Seed/demo function found in live path | HIGH |
| S-22 | Batch update/overwrite without PATCH semantics | HIGH |
| S-23 | Backup not created before data operation (LAW 2) | BLOCKER |
| S-24 | PUT semantics used without justification | MEDIUM |
| S-25 | File path outside PROJECT LOCK root | BLOCKER |
| S-26 | Checkpoint not created before DISCOVERY | BLOCKER |
| S-27 | Target file outside task SCOPE BOUNDARY | HIGH |
| S-28 | Working on wrong project's files | BLOCKER |
| S-29 | Feature file/export count decreased after PATCH | HIGH |
| S-30 | Claiming code "doesn't exist" without evidence | HIGH |
| S-31 | Existing feature removed/disabled during task | HIGH |
| S-32 | TODO run number ahead of STATE.md last run | BLOCKER |
| S-33 | Scout survey without git freshness check | HIGH |
| S-34 | Manual drift >10 runs since last audit | HIGH |
| S-35 | TARGET_ENVIRONMENT missing from FOOTPRINT | BLOCKER |
| S-36 | Destructive op targeting PRODUCTION without 🔑 PRODUCTION CONFIRMED | ⚫ NUCLEAR |
| S-37 | Ant continued working after NUCLEAR detection (V-13) | ⚫ NUCLEAR |
| S-38 | CARD_RECEIPT missing from Ant report | BLOCKER |
| S-39 | CORE card skipped without CARD_WAIVER | ⚫ NUCLEAR |
| S-40 | DevTools verification skipped during CLOSE | BLOCKER |
| S-41 | Planner task has >5 target files | HIGH |
| S-42 | Planner skipped Hive Mind check | HIGH |
| S-43 | Circular dependency in Planner task graph | BLOCKER |
| S-44 | Inbox document >500 lines, not summarized | MEDIUM |
| S-45 | >7 tasks in single session without boundary | HIGH |

## CLEARING A STOP
- Standard STOP: `🔑 CONTINUE` or `🔑 GO`
- Budget exceeded (S-14): `🔑 DISCOVERY EXPANSION APPROVED`
- NUCLEAR (S-07/08/12/36/37): `🔑 NUCLEAR RESOLVED: <action>` — no shortcut
- HALTED (S-05): Operator must explicitly restart or abort

## STOP MEANS STOP (FROZEN)
- "Acknowledge and continue" = NON-COMPLIANT
- "I see the issue but will proceed" = NON-COMPLIANT
- There is NO "read-only exception"
- Silence ≠ approval. Acknowledgment ≠ approval.
