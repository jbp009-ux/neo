# CARD GPS MAP
**Version:** 1.0.0
**Policy Pack:** PP-2026-02-27
**Generated:** 2026-02-27
**Purpose:** Turn-by-turn GPS linking every protocol card to exact role prompt sections. No guessing — every pointer is verified against the source.

> "A card without a GPS coordinate is a card that gets lost."

---

## ROLE ENTRYPOINTS

| Role | File | Version | Lines | Shared Modules |
|------|------|---------|-------|----------------|
| **Ant** | `roles/NEO-ANT.md` | v1.27.0 | ~1,600 | 8 (ACTIVATION, GATES, EVIDENCE, OUTPUTS, TOOLS, HIVE, SURGICAL, FIVE-HORSEMEN) |
| **BECCA** | `roles/NEO-BECCA.md` | v1.25.0 | ~2,900 | 8+1 (same + HIVEMIND-GLOBAL) |
| **Planner** | `prompts/PLANNER_ANT.md` | v1.0.0 | ~300 | 4 (ACTIVATION, GATES, HIVE, OUTPUTS) |
| **Ghost** | `roles/NEO-GHOST.md` | v1.20.0 | 1,069 | 8 (ACTIVATION, GATES, EVIDENCE, OUTPUTS, TOOLS, HIVE, SURGICAL, FIVE-HORSEMEN) |
| **Inspector** | `roles/NEO-INSPECTOR.md` | v1.8.0 | 690 | 9 (same 8 + HIVEMIND-GLOBAL) |

---

## ANT GPS

### Entrypoint
`roles/NEO-ANT.md` — Load at task dispatch. Ant reads §INSTANT ACTIVATION (L12), §CHECKPOINT FIRST (L36), then follows state flow.

### Card Sequence
```
ANT_CHECKPOINT → ANT_DISCOVERY → ANT_FOOTPRINT → [ANT_BACKUP] → ANT_PATCH → ANT_VERIFY → ANT_REPORT
```
Plus: CORE-001 at CHECKPOINT, CORE-002 at BACKUP, CORE-003 at FOOTPRINT, CORE-004 at FOOTPRINT, CORE-005 at VERIFY.

### Card → Prompt Section Links

#### ANT-CHECKPOINT → `NEO-ANT.md` L36–L82
| Card Step | Role Prompt Section | Line(s) | Shared Module |
|-----------|-------------------|---------|---------------|
| §1 Activation Response | §INSTANT ACTIVATION RESPONSE | L12–L34 | `NEO-ACTIVATION.md` — "I AM" protocol |
| §2 Project Lock | §CHECKPOINT FIRST: PROJECT LOCK subsection | L36–L82 | — |
| §3 Git Checkpoint | §CHECKPOINT FIRST: Git checkpoint | L36–L82 | — |
| §4 Checkpoint Proof | §CHECKPOINT FIRST: CHECKPOINT PROOF table | L36–L82 | — |
| §5 Transition to DISCOVERY | §Process: STATE: DISCOVERY header | L407 | `NEO-GATES.md` — state transitions |

**Acceptance:** Checkpoint Proof table present, PROJECT LOCK stated, branch/commit recorded.

---

#### ANT-DISCOVERY → `NEO-ANT.md` L407–L698
| Card Step | Role Prompt Section | Line(s) | Shared Module |
|-----------|-------------------|---------|---------------|
| §1 Discovery Strategy | §DISCOVERY: Discovery Strategy subsection | L407–L450 | — |
| §2 Hive Mind Check | §DISCOVERY: Hive Mind Check (7 indexes) | L407–L500 | `NEO-HIVE.md` — index formats, HIVE EVIDENCE PROOF |
| §2 Command Proof | §DISCOVERY: Command Proof requirement | L407–L500 | `NEO-EVIDENCE.md` — evidence standards |
| §3 Code Analysis | §DISCOVERY: Understanding Proof (LAW 1) | L407–L600 | `NEO-SURGICAL.md` — LAW 1: Understanding First |
| §3 Nearest Truth | §DISCOVERY: Nearest Truth Rule | L407–L600 | `NEO-EVIDENCE.md` §14 — source hierarchy |
| §3 Operator Manual check | §DISCOVERY: Check Operator Manual | L407–L600 | Project `OPERATOR_MANUAL.md` |
| §4 Conditional: Tenant scan | §DISCOVERY: TENANT ISOLATION SCAN | L407–L650 | `NEO-SURGICAL.md` §11–15 — SaaS Safety |
| §4 Conditional: Secret scan | §DISCOVERY: SECRET SCAN | L407–L650 | `NEO-SURGICAL.md` §11–15 |
| §4 Conditional: Pre-build search | §DISCOVERY: PRE-BUILD SEARCH | L407–L650 | — |
| §4 Conditional: Data classification | §DISCOVERY: DATA CLASSIFICATION | L407–L650 | `NEO-SURGICAL.md` — PII 4-tier (T1–T4) |
| §5 Output: Snapshot + Budget | §DISCOVERY: Budget Ledger format | L407–L698 | `NEO-EVIDENCE.md` — budget rules (5 files/200 lines/10 greps) |

**Acceptance:** Discovery Strategy (ONE QUESTION), HIVE EVIDENCE PROOF (7 rows YES), Budget Ledger (numbers), Understanding Proof (4 checks).

---

#### ANT-FOOTPRINT → `NEO-ANT.md` L700–L756
| Card Step | Role Prompt Section | Line(s) | Shared Module |
|-----------|-------------------|---------|---------------|
| §1 Data Op Classification | §FOOTPRINT: Data Op Classification table | L700–L720 | `NEO-EVIDENCE.md` — valid op types |
| §2 Target Environment | §FOOTPRINT: TARGET_ENVIRONMENT declaration | L700–L730 | `NEO-GATES.md` — S-35/S-36 rules |
| §3 Feature Impact | §FOOTPRINT: Feature Impact table | L700–L740 | `NEO-EVIDENCE.md` — feature inventory |
| §4 Critical Surfaces | §FOOTPRINT: Critical Surface flagging | L700–L745 | `NEO-TOOLS.md` §5 — Critical Surfaces list; `injections/CRITICAL_SURFACE.md` |
| §5 Risk Assessment | §FOOTPRINT: Risk classification | L700–L750 | — |
| §6 Rollback Plan | §Rollback Plan Template | L1072–L1090 | — |
| §7 Pheromone Emission | §FOOTPRINT: Pheromone emission | L700–L756 | `NEO-HIVE.md` — PHEROMONE_REGISTRY format |
| §8 Horsemen H3/H4 | §FOOTPRINT: scope/privilege checks | L700–L756 | `shared/NEO-FIVE-HORSEMEN.md` — H3 DRIFT, H4 PRIVILEGE CREEP |

**Acceptance:** FOOTPRINT table (file/op/semantics/justification), Feature Impact table, `🔑 APPROVED FOOTPRINT` received.

---

#### ANT-BACKUP → `NEO-ANT.md` L757–L792
| Card Step | Role Prompt Section | Line(s) | Shared Module |
|-----------|-------------------|---------|---------------|
| §1 When Triggered | §BACKUP: trigger condition (data ops in FOOTPRINT) | L757–L765 | `NEO-SURGICAL.md` — LAW 2 |
| §2 Create Backup | §BACKUP: backup execution | L757–L775 | `NEO-SURGICAL.md` — LAW 2: Backup-First |
| §3 Backup Proof | §BACKUP: Backup Proof table format | L757–L785 | `NEO-EVIDENCE.md` — backup evidence requirements |
| §4 Restore Test | §BACKUP: restore test for DELETE/MIGRATION | L757–L792 | `NEO-SURGICAL.md` — LAW 2: Restore Test (actual, not attestation) |

**Acceptance:** Backup Proof table present, restore test PASS (if DELETE/MIGRATION), `🔑 BACKUP APPROVED` received.

---

#### ANT-PATCH → `NEO-ANT.md` L793–L838
| Card Step | Role Prompt Section | Line(s) | Shared Module |
|-----------|-------------------|---------|---------------|
| §1 Apply Changes | §PATCH: apply changes exactly per FOOTPRINT | L793–L810 | — |
| §2 Truthy Diffs (7) | §PATCH: Truthy Diffs TD-1→TD-7 | L793–L820 | `NEO-SURGICAL.md` — LAW 3: Truthy Diffs |
| §3 Anti-Assumption (A-01→A-08) | §PATCH: Anti-Assumption Patterns | L793–L830 | `NEO-SURGICAL.md` §5 — anti-assumption rules |
| §4 Scope Checks H3/H4 | §PATCH: scope contraction + euphemism scan | L793–L838 | `NEO-FIVE-HORSEMEN.md` — H3 DRIFT; `NEO-EVIDENCE.md` — scope contraction patterns |
| §5 Error Recovery | §PATCH: error recovery (build fail, git conflict) | L793–L838 | — |

**Acceptance:** Diffs shown, Truthy Diffs 7/7 PASS, A-01→A-08 clean, `🔑 PATCH APPROVED` received.

---

#### ANT-VERIFY → `NEO-ANT.md` L839–L894
| Card Step | Role Prompt Section | Line(s) | Shared Module |
|-----------|-------------------|---------|---------------|
| §1 Local Verification | §VERIFY: test/build/lint execution | L839–L860 | Project `OPERATOR_MANUAL.md` — test/build commands |
| §2 CI/CD Verification | §VERIFY: CI/CD STATUS TABLE | L839–L870 | — |
| §3 Success Criteria | §VERIFY: success criteria check per task packet | L839–L880 | — |
| §4 Risk-Specific Extras | §VERIFY: risk-level-specific tests | L839–L885 | — |
| §5 Feature Inventory | §VERIFY: Feature Inventory before/after | L839–L890 | `NEO-EVIDENCE.md` — Feature Inventory format |
| §6 Conditional: Destructive Op Log | §VERIFY: Destructive Operation Log | L839–L894 | `NEO-SURGICAL.md` §12 — Destructive Op Registry |
| §7 Horsemen H1/H5 | §VERIFY: Horsemen self-check | L839–L894 | `NEO-FIVE-HORSEMEN.md` — H1 HALLUCINATION, H5 SILENT FAILURE |

**Acceptance:** Tests PASS, build PASS, Feature Inventory (after >= before), `🔑 VERIFY APPROVED` received.

---

#### ANT-REPORT → `NEO-ANT.md` L895–L916
| Card Step | Role Prompt Section | Line(s) | Shared Module |
|-----------|-------------------|---------|---------------|
| §1 Report Structure (13 sections) | §REPORT: 13-section structure | L895–L916 | `NEO-OUTPUTS.md` — ANT_REPORT format |
| §2 Lessons (Section 8) | §REPORT: Lessons for Future Ants | L895–L916 | `NEO-HIVE.md` — LESSONS_INDEX format |
| §3 Prompt Feedback (Section 13) | §REPORT: Prompt Feedback categories | L895–L916 | — |
| §4 SaaS Safety Preflight | §SaaS Safety Preflight | L1092–L1131 | `NEO-SURGICAL.md` §11–15 |
| §5 Horsemen Self-Check | §REPORT + Quick Reference: Horsemen | L895–L916, L1144–L1285 | `NEO-FIVE-HORSEMEN.md` — all 5 |
| §5b Pre-Submit Self-Review | §Quick Reference: 5 constitutional checks | L1144–L1285 | `NEO-EVIDENCE.md` — self-review requirements |
| §6 Gate Log | §REPORT: gate log inclusion | L895–L916 | `NEO-GATES.md` — token log format |

**Acceptance:** All 13 sections present, Pre-Submit Self-Review 5/5 YES, `🔑 REPORT APPROVED` received.

---

## GHOST GPS

### Entrypoint
`roles/NEO-GHOST.md` — Load at Ghost dispatch. Ghost reads §INSTANT ACTIVATION (L12), then STATE: REVIEW (L104).

### Card Sequence
```
GHOST_REVIEW → GHOST_VERDICT
```
Plus: CORE-001 at activation (policy/pheromone context).

### Card → Prompt Section Links

#### GHOST-REVIEW → `NEO-GHOST.md` L104–L263
| Card Step | Role Prompt Section | Line(s) | Shared Module |
|-----------|-------------------|---------|---------------|
| §1 Activation | §INSTANT ACTIVATION RESPONSE | L12–L34 | `NEO-ACTIVATION.md` |
| §2 Ant Type Validation | §Review Checklist: Ant Type Validation | L282–L290 | — |
| §3 Report Completeness (13 sections) | §Review Checklist: Completeness | L291–L299 | `NEO-OUTPUTS.md` — ANT_REPORT sections |
| §4 Evidence Validation | §Review Checklist: Evidence Quality | L307–L314 | `NEO-EVIDENCE.md` — evidence scoring |
| §5 Surgical Protocol Compliance | §Review Checklist: Surgical Protocol Compliance | L355–L365 | `NEO-SURGICAL.md` — 3 Laws |
| §6 Proof-Forcing Checks | §Review Checklist: Discovery Strategy → Operator Manual Currency | L379–L416 | — |
| §7 Compliance Checks | §Review Checklist: Token Normalization → SaaS Safety | L412–L460 | `NEO-GATES.md` §3.4 — V-12; `NEO-EVIDENCE.md` §14 — Nearest Truth; `NEO-HIVE.md` §9 — Lessons |
| §8 NUCLEAR + Pheromone | §Review Checklist: Nuclear & Pheromone check | L469–L490 | `NEO-HIVE.md` — PHEROMONE_REGISTRY |
| §9 SaaS Safety | §Review Checklist: SaaS Safety Compliance | L434–L460 | `NEO-SURGICAL.md` §11–15 |
| §10 Violation Scan (V-01→V-13) | §Review Checklist: Violation Detection | L366–L378 | `NEO-GATES.md` — Appendix A: violation table |
| §11 Scope Contraction | §Review Checklist: Snapshot Summary → Critical Surface | L461–L473 | `NEO-EVIDENCE.md` — scope contraction euphemisms |
| §12 Non-Existence Verification | §STATE: VALIDATE_EVIDENCE → VERIFY_EVIDENCE | L190–L252 | — |
| §13 Evidence Re-Execution | §STATE: VERIFY_EVIDENCE (conditional) | L214–L252 | — |
| §14 Five Horsemen Verdict | §Review Checklist: CARD COMPLIANCE → Ghost Verdicts | L474–L500 | `NEO-FIVE-HORSEMEN.md` — H1–H5 |

**Acceptance:** Evidence score ≥70%, Horsemen verdict (5 rows), Violation scan (V-01→V-13), CARD COMPLIANCE checked.

---

#### GHOST-VERDICT → `NEO-GHOST.md` L264–L279 + L491–L592
| Card Step | Role Prompt Section | Line(s) | Shared Module |
|-----------|-------------------|---------|---------------|
| §1 Verdict Categories | §Ghost Verdicts | L491–L501 | `NEO-GATES.md` — verdict tokens |
| §2 Auto-Reject Conditions | §Ghost Verdicts + Hard Limits | L491–L594 | `NEO-GATES.md` — V-01→V-13 |
| §3 GHOST_REVIEW Output (8 sections) | §Output Format — 8 Sections | L617–L717 | `NEO-OUTPUTS.md` — GHOST_REVIEW format |
| §4 Deficiency List Format | §Output: §8 VERDICT & HANDOFF | L706–L717 | `NEO-HIVE.md` — REJECTION_INDEX (Rule Triggered + Stage fields) |
| §5 Strike 3 Detection | §TODO Coordination: On Rejection | L534–L582 | `NEO-ACTIVATION.md` — Strike 3 Decision Matrix |
| §6 TODO Update | §TODO Coordination: On Completion / On Rejection | L504–L582 | — |

**Acceptance:** Verdict token present, deficiency list (if any) with Rule+Stage, Strike 3 check performed.

---

## INSPECTOR GPS

### Entrypoint
`roles/NEO-INSPECTOR.md` — Load at Inspector dispatch. Inspector reads §INSTANT ACTIVATION (L12), then §Inspection Types (L102).

### Card Sequence
```
INSPECTOR_AUDIT → INSPECTOR_VERDICT
```
Plus: CORE-001 at activation.

### Card → Prompt Section Links

#### INSPECTOR-AUDIT → `NEO-INSPECTOR.md` L102–L338
| Card Step | Role Prompt Section | Line(s) | Shared Module |
|-----------|-------------------|---------|---------------|
| §1 Activation | §INSTANT ACTIVATION RESPONSE | L12–L35 | `NEO-ACTIVATION.md` |
| §DRIFT | §Inspection Types: DRIFT | L104–L112 | — |
| §COMPLIANCE | §Inspection Types: COMPLIANCE | L113–L123 | `NEO-EVIDENCE.md`, `NEO-OUTPUTS.md`, `NEO-GATES.md`, `NEO-TOOLS.md` |
| §QUALITY | §Inspection Types: QUALITY | L124–L133 | — |
| §NUCLEAR | §Inspection Types: NUCLEAR | L134–L148 | `NEO-SURGICAL.md` — tenant/credential rules |
| §PHEROMONE | §Inspection Types: PHEROMONE | L149–L159 | `NEO-HIVE.md` — PHEROMONE_REGISTRY |
| §HIVE (9-point) | §Inspection Types: HIVE | L160–L183 | `NEO-HIVE.md` — all 6 index formats |
| §SURGICAL (10-point) | §Inspection Types: SURGICAL | L184–L211 | `NEO-SURGICAL.md` — 3 Laws + anti-assumption |
| §SAAS_SAFETY (12-point) | §Inspection Types: SAAS_SAFETY | L212–L247 | `NEO-SURGICAL.md` §11–15 |
| §MANUAL_DRIFT (10-point) | §Inspection Types: MANUAL_DRIFT | L248–L282 | Project `OPERATOR_MANUAL.md` |
| §GATE_COMPLIANCE | §Inspection Types: GATE_COMPLIANCE | L283–L310 | `NEO-GATES.md` — full token vocabulary |
| §CARD_COMPLIANCE | §Inspection Types: CARD_COMPLIANCE | L311–L338 | `templates/CARD_DECK.md` — CDEX rules |
| §HORSEMEN | Card: INSPECTOR-AUDIT §HORSEMEN table | (card only) | `NEO-FIVE-HORSEMEN.md` — H1–H5 cross-chain audit |

**Acceptance:** All applicable inspection types run, finding format correct (INS-NNN), HORSEMEN table (Ant+Ghost+Inspector columns).

---

#### INSPECTOR-VERDICT → `NEO-INSPECTOR.md` L353–L468
| Card Step | Role Prompt Section | Line(s) | Shared Module |
|-----------|-------------------|---------|---------------|
| §1 Severity Levels | §Severity Definitions | L370–L382 | — |
| §2 Verdict Categories | §STATE: REPORT → verdict output | L353–L369 | `NEO-GATES.md` — `🔑 INSPECTOR PASS/FAIL` |
| §3 INSPECTOR_REPORT Output (7 sections) | §Output Format: INSPECTOR REPORT | L501–L562 | `NEO-OUTPUTS.md` — INSPECTOR_REPORT format |
| §4 Finding Summary Table | §Inspector Findings Format | L383–L399 | — |
| §5 TODO Update | §TODO Coordination: On Completion / On Failure | L400–L468 | — |

**Acceptance:** Verdict token present, finding table with severity+category, TODO updated.

---

## PLANNER GPS

### Entrypoint
`prompts/PLANNER_ANT.md` v1.0.0 — Load when BECCA triggers PLAN state (tasks >3, files >3, or inbox/ideas/ non-empty). Planner is a Board Ant specialization.

### Card Sequence
```
PLANNER_SKELETON → PLANNER_DETAIL
```

### Card → Prompt Section Links

#### PLAN-001 (PLANNER_SKELETON) → `prompts/PLANNER_ANT.md`
| Card Step | Prompt Section | Shared Module |
|-----------|---------------|---------------|
| §1 Activation | §PURPOSE | `NEO-ACTIVATION.md` — "I AM" protocol |
| §2 Inbox Scan | §INBOX READING PROTOCOL | — |
| §3 Scout TODO Review | §DECOMPOSITION RULES | — |
| §4 Hive Mind Intelligence | §HIVE MIND INTELLIGENCE | `NEO-HIVE.md` — index contracts |
| §5 Decomposition | §DECOMPOSITION RULES (Rules 1-5) | — |
| §6 Skeleton Output | §OUTPUT FORMAT → Pass 1 | `NEO-OUTPUTS.md` — §1c RUN_PLAN |
| §7 Gate | §RESPONSE BOUNDARIES → Pass 1 | `NEO-GATES.md` — PLAN SKELETON OK token |

**Acceptance:** Task sequence table present, dependency map shown, no task >5 files, no circular dependencies.

#### PLAN-002 (PLANNER_DETAIL) → `prompts/PLANNER_ANT.md`
| Card Step | Prompt Section | Shared Module |
|-----------|---------------|---------------|
| §1 Batch Preparation | §TWO-PASS ARCHITECTURE → Pass 2 | — |
| §2 Per-Task Enrichment | §PRE-ENRICHMENT: TASK PACKET GENERATION | `NEO-HIVE.md` — scoring function |
| §3 Batch Output | §OUTPUT FORMAT → Pass 2 | `NEO-OUTPUTS.md` — §1c RUN_PLAN |
| §4 Batch Gate | §RESPONSE BOUNDARIES → Per batch | `NEO-GATES.md` — TASK BATCH OK token |
| §5 RUN_PLAN | §OUTPUT FORMAT → Final | `templates/RUN_PLAN.md` |
| §6 Final Gate | §RESPONSE BOUNDARIES → Final | `NEO-GATES.md` — RUN PLAN APPROVED token |

**Acceptance:** Task packets written to `.neo/inbox/`, HIVE CONTEXT populated, RUN_PLAN with dependency map.

---

## BECCA GPS

### Entrypoint
`roles/NEO-BECCA.md` — Load at run start. BECCA reads §INSTANT ACTIVATION (L12), then STATE: RECON (L147).

### Card Sequence
```
BECCA_RECON → [PLAN assessment → dispatch Planner or skip] → [dispatch tasks → Ant/Ghost/Inspector cycles] → BECCA_VERIFY → BECCA_CLOSE_ARCHIVE → BECCA_CLOSE_ANALYTICS → BECCA_CLOSE_DEVTOOLS → BECCA_CLOSE_GOVERNANCE
```

### Card → Prompt Section Links

#### BECCA-RECON → `NEO-BECCA.md` L147–L385
| Card Step | Role Prompt Section | Line(s) | Shared Module |
|-----------|-------------------|---------|---------------|
| §1 Activation | §INSTANT ACTIVATION RESPONSE | L12–L31 | `NEO-ACTIVATION.md` |
| §2 State Check | §RECON: STATE CHECK | L147–L200 | — |
| §3 Index Health Check | §RECON: INDEX HEALTH CHECK | L147–L250 | `NEO-HIVE.md` — all 6 index schemas |
| §4 Pheromone Triage | §RECON: PHEROMONE TRIAGE | L147–L280 | `NEO-HIVE.md` — PHEROMONE_REGISTRY |
| §5 Manual Drift Check | §RECON: MANUAL DRIFT CHECK | L147–L300 | Project `OPERATOR_MANUAL.md` |
| §6 TODO State Verification | §RECON: TODO STATE VERIFICATION | L147–L320 | — |
| §7 Cross-Project Check | §RECON: CROSS-PROJECT CHECK | L147–L340 | `shared/NEO-HIVEMIND-GLOBAL.md` |
| §8 Health Trend Dashboard | §RECON: HEALTH TREND DASHBOARD | L147–L360 | — |
| §9 Improvement Verification | §RECON: IMPROVEMENT VERIFICATION | L147–L380 | — |
| §10 Ungoverned Changes Scan | §RECON: UNGOVERNED CHANGES SCAN | L147–L385 | — |
| §11 RECON Output | §RECON: RECON OUTPUT + SYSTEM VITALS | L147–L385 | — |
| §12 Branch Creation | §BRANCH-PER-RUN (MANDATORY) | L496–L544 | — |
| CARD DECK generation | §CARD DECK IN TASK PACKETS | L386–L414 | `templates/CARD_DECK.md` |

**Acceptance:** RECON COMPLETE output, SYSTEM VITALS, branch created, CARD DECK generated.

---

#### BECCA-VERIFY → `NEO-BECCA.md` L1073–L1161
| Card Step | Role Prompt Section | Line(s) | Shared Module |
|-----------|-------------------|---------|---------------|
| §1 Task Classification | §VERIFY: task classification (Builder/Debugger/QA) | L1073–L1098 | — |
| §2 Regression Check | §VERIFY: regression check (builder tasks only) | L1073–L1118 | — |
| §3 Completeness Check | §VERIFY: completeness (Ant+Ghost+Inspector ✅) | L1073–L1138 | — |
| §4 Debugger Resolution Check | §VERIFY: debugger resolution (if Debugger tasks) | L1073–L1148 | — |
| §5 Consistency Check | §VERIFY: build + tests still pass | L1073–L1158 | — |
| §6 Verify Output | §VERIFY: VERIFY output block | L1073–L1161 | — |

**Acceptance:** VERDICT: ✅ VERIFIED (or ❌ with evidence).

---

#### BECCA-CLOSE-ARCHIVE → `NEO-BECCA.md` L1162–L1513
| Card Step | Role Prompt Section | Line(s) | Shared Module |
|-----------|-------------------|---------|---------------|
| §1 TODO | §CLOSE: TODO update | L1162–L1178 | — |
| §2 Archive | §CLOSE: archive TODO | L1162–L1188 | — |
| §3 STATE | §CLOSE: STATE.md update | L1162–L1208 | — |
| §4 RUN INDEX | §RUN INDEX UPDATE | L1326–L1367 | — |
| §5 HIVE INDEX WRITES (6 indexes) | §HIVE INDEX UPDATE | L1368–L1513 | `NEO-HIVE.md` — all 6 index write contracts |
| §5 Lesson Reinforcement | §HIVE INDEX: Lesson Reinforcement | L1368–L1513 | `NEO-HIVE.md` §9 — Usage Stats |

**Acceptance:** HIVE INDEX UPDATE summary presented. All 6 indexes updated.

---

#### BECCA-CLOSE-ANALYTICS → `NEO-BECCA.md` L1514–L1980
| Card Step | Role Prompt Section | Line(s) | Shared Module |
|-----------|-------------------|---------|---------------|
| §6 Run Metrics | §RUN METRICS | L1514–L1588 | — |
| §6b Band-Aid Detection | §BAND-AID DETECTION | L1589–L1642 | — |
| §6c Improvement Velocity | §IMPROVEMENT VELOCITY | L1643–L1678 | — |
| §6d Pipeline Eval | §PIPELINE EVAL | L1679–L1724 | `templates/PIPELINE_EVAL.md` — 19 checks |
| §7 Operator Manual Update | §OPERATOR MANUAL UPDATE | L1725–L1813 | Project `OPERATOR_MANUAL.md` |
| §8 Cross-Project Hivemind | §CROSS-PROJECT HIVEMIND UPDATE | L1814–L1866 | `shared/NEO-HIVEMIND-GLOBAL.md` |
| §9 Prompt Feedback Aggregation | §PROMPT FEEDBACK AGGREGATION | L1867–L1917 | — |
| §10 Run Retrospective | §RUN RETROSPECTIVE | L1918–L1980 | — |

**Acceptance:** ANALYTICS SUMMARY presented (metrics, band-aid score, velocity, EVAL SCORE, health signals).

---

#### BECCA-CLOSE-GOVERNANCE → `NEO-BECCA.md` L2032–L2490
| Card Step | Role Prompt Section | Line(s) | Shared Module |
|-----------|-------------------|---------|---------------|
| §11 Framework Health Check | §FRAMEWORK HEALTH CHECK | L2032–L2132 | — |
| §11b Protocol Adoption Scan | §PROTOCOL ADOPTION SCAN | L2133–L2184 | — |
| §11c Framework Fix Escalation | §FRAMEWORK FIX ESCALATION | L2185–L2241 | `prompts/PROMPT_ARCHITECT.md` |
| §11d GPS Integrity Audit | §GPS INTEGRITY AUDIT | L2242–L2415 | `cards/CARD_GPS_MAP.md` |
| §11e Rotating Deep Scan | §ROTATING DEEP SCAN | L2416–L2460 | `cards/SYSTEM_ATLAS_INDEX.md` |
| §11f GPS Scan Log | §GPS SCAN LOG | L2461–L2490 | — |
| §12 Merge | §CLOSE: merge to main | L1162–L1178 | — |
| §13 Sign Off | §CLOSE: COMPLETION REPORT | L1230–L1325 | — |

**Acceptance:** All CLOSE steps completed, GPS VERDICT + DEEP SCAN logged, `🔑 RUN COMPLETE`.

---

#### BECCA-CLOSE-DEVTOOLS → `NEO-BECCA.md` L1981–L2031 (DEVTOOLS VERIFICATION)
| Card Step | Role Prompt Section | Line(s) | Shared Module |
|-----------|-------------------|---------|---------------|
| §1 Trigger Assessment | §DEVTOOLS VERIFICATION: trigger tables | L1981–L2013 | — |
| §2 Dispatch Chief Sentinel | §DEVTOOLS VERIFICATION: dispatch | L1981–L2023 | `prompts/DEVTOOLS_SENTINEL_ANT.md` |
| §3 Dispatch Specialists | §DEVTOOLS VERIFICATION: specialists | L1981–L2023 | `prompts/DEVTOOLS_PERF_ANT.md`, `prompts/DEVTOOLS_NETWORK_ANT.md` |
| §4 DevTools Verdict | §DEVTOOLS VERIFICATION: verdict | L1981–L2031 | `templates/DEVTOOLS_REPORT.md` |

**Acceptance:** `🔑 DEVTOOLS VERIFICATION APPROVED` issued. DEVTOOLS_CHIEF/DEVTOOLS_ESCALATED/DEVTOOLS_EVIDENCE recorded in STATE.md.

---

### F12 CARDS — DevTools Ant GPS

#### F12-001 (SETUP) → `prompts/DEVTOOLS_SENTINEL_ANT.md` (+ Perf, Network)
| Card Step | Prompt Section | Shared Module |
|-----------|---------------|---------------|
| §1 Activation | §PURPOSE | `NEO-TOOLS.md` §6b |
| §2 MCP Verification | §SENTINEL PROTOCOL: NAVIGATE | — |
| §3 Page Inventory | §SENTINEL PROTOCOL: NAVIGATE (page inventory) | — |
| §4 Navigate | §CHROME DEVTOOLS MCP TOOLS REFERENCE | `NEO-TOOLS.md` §6b |

#### F12-002 (CONSOLE AUDIT) → `prompts/DEVTOOLS_SENTINEL_ANT.md`
| Card Step | Prompt Section | Shared Module |
|-----------|---------------|---------------|
| §1 Capture | §SENTINEL PROTOCOL: SCAN — Console Audit | — |
| §2 Classify | §SENTINEL PROTOCOL: SCAN — classification table | — |

#### F12-003 (NETWORK AUDIT) → `prompts/DEVTOOLS_SENTINEL_ANT.md` + `prompts/DEVTOOLS_NETWORK_ANT.md`
| Card Step | Prompt Section | Shared Module |
|-----------|---------------|---------------|
| §1 Capture | §SENTINEL PROTOCOL: SCAN — Network Audit | — |
| §2 Flag | §SENTINEL PROTOCOL: SCAN — issue patterns table | — |
| §3 Deep Inspect (Network only) | §NETWORK PROTOCOL: INSPECT | `NEO-EVIDENCE.md` |

#### F12-004 (VISUAL SNAPSHOT) → `prompts/DEVTOOLS_SENTINEL_ANT.md`
| Card Step | Prompt Section | Shared Module |
|-----------|---------------|---------------|
| §1 Capture | §SENTINEL PROTOCOL: SNAPSHOT | — |
| §2 Visual Check | §SENTINEL PROTOCOL: SNAPSHOT | — |
| §4 Sentinel Verdict | §SENTINEL PROTOCOL: VERDICT | `templates/DEVTOOLS_REPORT.md` |

#### F12-005 (PERF TRACE) → `prompts/DEVTOOLS_PERF_ANT.md`
| Card Step | Prompt Section | Shared Module |
|-----------|---------------|---------------|
| §1 Baseline | §PERF PROTOCOL: BASELINE | — |
| §2 Analyze | §PERF PROTOCOL: TRACE | — |
| §3 Throttle | §PERF PROTOCOL: THROTTLE | — |
| §4 Compare | §PERF PROTOCOL: COMPARE | — |
| §5 Verdict | §PERF PROTOCOL: VERDICT | `templates/DEVTOOLS_REPORT.md` |

#### F12-006 (STATE INSPECTION) → `prompts/DEVTOOLS_NETWORK_ANT.md`
| Card Step | Prompt Section | Shared Module |
|-----------|---------------|---------------|
| §1 Session State | §NETWORK PROTOCOL: VALIDATE — Session State | — |
| §2 Auth State | §NETWORK PROTOCOL: VALIDATE — Auth State | — |
| §3 App State | §NETWORK PROTOCOL: VALIDATE — Application State | — |
| §4 Tenant Isolation | §NETWORK PROTOCOL: VALIDATE — Tenant Isolation | — |
| §5 Verdict | §NETWORK PROTOCOL: VERDICT | `templates/DEVTOOLS_REPORT.md` |

---

## CORE CARDS — Cross-Role GPS

CORE cards are loaded by ALL agents but map to different sections depending on the role.

### CARD-CORE-001: Load Policy Pack + Pheromones

| Role | Maps To | Line(s) |
|------|---------|---------|
| Ant | §Load These Shared Modules + §CHECKPOINT FIRST | `NEO-ANT.md` L84–L99, L36–L82 |
| Ghost | §Load These Shared Modules + §Inputs Required | `NEO-GHOST.md` L35–L50, L89–L101 |
| Inspector | §Load These Shared Modules + §Inputs Required | `NEO-INSPECTOR.md` L36–L52, L90–L101 |
| BECCA | §Load These Shared Modules | `NEO-BECCA.md` L32–L47 |

**Shared modules loaded:** `NEO-GATES.md`, `NEO-EVIDENCE.md`, `NEO-SURGICAL.md`, `NEO-HIVE.md`, `NEO-TOOLS.md`, `NEO-OUTPUTS.md`, `NEO-ACTIVATION.md`, `NEO-FIVE-HORSEMEN.md`

---

### CARD-CORE-002: Backup-First Proof

| Role | Maps To | Line(s) |
|------|---------|---------|
| Ant | §STATE: BACKUP (Conditional — LAW 2) | `NEO-ANT.md` L757–L792 |
| Ghost | §Review Checklist: Surgical Protocol — LAW 2 checks | `NEO-GHOST.md` L355–L365 |
| Inspector | §Inspection Types: SURGICAL — backup proof checks | `NEO-INSPECTOR.md` L184–L211 |

**Key shared module:** `NEO-SURGICAL.md` — LAW 2: Backup-First

---

### CARD-CORE-003: Scope Lock

| Role | Maps To | Line(s) |
|------|---------|---------|
| Ant | §STATE: FOOTPRINT | `NEO-ANT.md` L700–L756 |
| Ghost | §Review Checklist: Completeness (Section 3: Footprint) + Scope Contraction | `NEO-GHOST.md` L291–L299, L461–L468 |
| Inspector | §Inspection Types: DRIFT (scope deviations) | `NEO-INSPECTOR.md` L104–L112 |

**Key shared modules:** `NEO-EVIDENCE.md` (FOOTPRINT table), `NEO-SURGICAL.md` (scope discipline), `NEO-GATES.md` (🔑 APPROVED FOOTPRINT)

---

### CARD-CORE-004: Evidence Capture Plan

| Role | Maps To | Line(s) |
|------|---------|---------|
| Ant | §STATE: FOOTPRINT (evidence plan declared before PATCH) | `NEO-ANT.md` L700–L756 |
| Ghost | §Review Checklist: Evidence Quality (validates plan was followed) | `NEO-GHOST.md` L307–L314 |
| Inspector | §Inspection Types: COMPLIANCE (evidence completeness) | `NEO-INSPECTOR.md` L113–L123 |

**Key shared module:** `NEO-EVIDENCE.md` — evidence requirements, verification methods, evidence path format

---

### CARD-CORE-005: Post-Change Verification

| Role | Maps To | Line(s) |
|------|---------|---------|
| Ant | §STATE: VERIFY | `NEO-ANT.md` L839–L894 |
| Ghost | §STATE: VERIFY_EVIDENCE (re-execution) | `NEO-GHOST.md` L214–L252 |
| Inspector | §Inspection Types: QUALITY (code quality, tests) | `NEO-INSPECTOR.md` L124–L133 |

**Key shared modules:** `NEO-EVIDENCE.md` (Feature Inventory), `NEO-SURGICAL.md` (Truthy Diffs), `NEO-GATES.md` (🔑 VERIFY APPROVED)

---

## REFERENCE CARDS — Universal GPS

### GATE_TOKENS → `cards/ref/GATE_TOKENS.md`
| Role | Maps To | Line(s) |
|------|---------|---------|
| ALL | §Quick Reference: token tables | `NEO-ANT.md` L1144; `NEO-GHOST.md` L718; `NEO-INSPECTOR.md` L563; `NEO-BECCA.md` L2110 |
| ALL | NEO-GATES.md — Appendix A: Master Reference Card | Full token vocabulary |

### STOP_CONDITIONS → `cards/ref/STOP_CONDITIONS.md`
| Role | Maps To | Line(s) |
|------|---------|---------|
| Ant | §Hard Limits (STOP Immediately) | `NEO-ANT.md` L986–L1031 |
| Ghost | §Hard Limits (STOP Immediately) | `NEO-GHOST.md` L583–L594 |
| Inspector | §Hard Limits (STOP Immediately) | `NEO-INSPECTOR.md` L469–L479 |
| BECCA | §Hard Limits (STOP Immediately) | `NEO-BECCA.md` L2098–L2109 |

---

## SHARED MODULE REFERENCE

For GPS completeness — which shared modules are referenced by which cards:

| Shared Module | Referenced By Cards |
|---------------|-------------------|
| `NEO-ACTIVATION.md` | CORE-001, ANT-CHECKPOINT, GHOST-REVIEW, INSPECTOR-AUDIT, BECCA-RECON |
| `NEO-GATES.md` | CORE-003, CORE-005, ANT-FOOTPRINT, ANT-REPORT, GHOST-VERDICT, INSPECTOR-VERDICT, GATE_TOKENS, STOP_CONDITIONS |
| `NEO-EVIDENCE.md` | CORE-002, CORE-003, CORE-004, CORE-005, ANT-DISCOVERY, ANT-FOOTPRINT, ANT-VERIFY, ANT-REPORT, GHOST-REVIEW |
| `NEO-OUTPUTS.md` | ANT-REPORT, GHOST-VERDICT, INSPECTOR-VERDICT |
| `NEO-TOOLS.md` | ANT-FOOTPRINT (Critical Surfaces), INSPECTOR-AUDIT (tool compliance) |
| `NEO-HIVE.md` | CORE-001, ANT-DISCOVERY, ANT-FOOTPRINT, ANT-REPORT, GHOST-REVIEW, GHOST-VERDICT, INSPECTOR-AUDIT, BECCA-RECON, BECCA-CLOSE-ARCHIVE, BECCA-CLOSE-ANALYTICS, BECCA-CLOSE-GOVERNANCE |
| `NEO-SURGICAL.md` | CORE-002, CORE-005, ANT-DISCOVERY, ANT-FOOTPRINT, ANT-PATCH, ANT-REPORT, GHOST-REVIEW, INSPECTOR-AUDIT |
| `NEO-FIVE-HORSEMEN.md` | ANT-FOOTPRINT, ANT-VERIFY, ANT-REPORT, GHOST-REVIEW, INSPECTOR-AUDIT |
| `NEO-HIVEMIND-GLOBAL.md` | ANT-DISCOVERY, BECCA-RECON, BECCA-CLOSE-ARCHIVE, BECCA-CLOSE-ANALYTICS, BECCA-CLOSE-GOVERNANCE |

---

## POLICY PACK VERSION

This GPS map is versioned as **PP-2026-02-27**. Every CARD_RECEIPT must include:

```
| policy_pack_version | PP-2026-02-27 |
```

If the role file version changes, this map MUST be regenerated. Stale GPS = wrong directions.

---

## Changelog

### [1.0.0] 2026-02-27
- Initial GPS map creation
- All 4 roles mapped: Ant (7 cards), Ghost (2 cards), Inspector (2 cards), BECCA (3 cards)
- All 5 CORE cards cross-mapped to all applicable roles
- 2 reference cards mapped
- 9 shared modules cross-referenced
- Policy Pack versioning introduced (PP-2026-02-27)
