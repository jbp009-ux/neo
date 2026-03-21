# TASK CARD GPS LINKING — Crash-Proof Mission Log
**Version:** 1.0.0
**Policy Pack:** PP-2026-02-27
**Purpose:** Append-only log that tracks exactly which GPS deliverables were completed. If a session crashes mid-implementation, the next session reads this file and knows exactly where to resume.

> "If you crash, you don't restart. You resume."

---

## HOW THIS FILE WORKS

1. Each task below is an atomic unit of work (T001–T007)
2. Tasks are checked off ONLY when the work is verified complete
3. If a session crashes: the next session reads this file, finds the last unchecked task, and resumes there
4. This file is APPEND-ONLY — never delete completed entries, only add new ones
5. Evidence column must cite the actual file path or commit, not "done" or "completed"

---

## GPS IMPLEMENTATION LOG

| Task | Description | Status | Evidence | Session |
|------|-------------|--------|----------|---------|
| T001 | Inventory all 4 role system prompts — exact sections, line numbers, versions | ✅ DONE | ANT: 1,564L 15H2 45H3; BECCA: 2,484L 24H2 38H3; GHOST: 1,069L 27H2 33H3; INSPECTOR: 690L 14H2 24H3 | 2026-02-27 |
| T002 | Create CARD_GPS_MAP.md — Ant GPS section (7 cards → prompt sections) | ✅ DONE | `cards/CARD_GPS_MAP.md` — ANT GPS section: ANT-CHECKPOINT→L36, ANT-DISCOVERY→L407, ANT-FOOTPRINT→L700, ANT-BACKUP→L757, ANT-PATCH→L793, ANT-VERIFY→L839, ANT-REPORT→L895 | 2026-02-27 |
| T003 | Create CARD_GPS_MAP.md — Ghost GPS section (2 cards → prompt sections) | ✅ DONE | `cards/CARD_GPS_MAP.md` — GHOST GPS section: GHOST-REVIEW→L104, GHOST-VERDICT→L264+L491 | 2026-02-27 |
| T004 | Create CARD_GPS_MAP.md — Inspector GPS section (2 cards → prompt sections) | ✅ DONE | `cards/CARD_GPS_MAP.md` — INSPECTOR GPS section: INSPECTOR-AUDIT→L102, INSPECTOR-VERDICT→L353 | 2026-02-27 |
| T005 | Create CARD_GPS_MAP.md — BECCA GPS section (3 cards → prompt sections) | ✅ DONE | `cards/CARD_GPS_MAP.md` — BECCA GPS section: BECCA-RECON→L147, BECCA-VERIFY→L965, BECCA-CLOSE→L1054 | 2026-02-27 |
| T006 | Create CARD_GPS_MAP.md — CORE cards cross-role mapping + shared module reference | ✅ DONE | `cards/CARD_GPS_MAP.md` — 5 CORE cards × 3-4 roles each, 9 shared modules cross-referenced | 2026-02-27 |
| T007 | Add EVAL-CARD checks to PIPELINE_EVAL.md | ✅ DONE | `templates/PIPELINE_EVAL.md` — EVAL-16 (CARD_RECEIPT), EVAL-17 (Policy Pack), EVAL-18 (CORE cards), EVAL-19 (Ghost card compliance); all refs updated 15→19 in BECCA, BECCA_CLOSE, CLAUDE.md | 2026-02-27 |

---

## ADDITIONAL DELIVERABLES LOG

| Task | Description | Status | Evidence | Session |
|------|-------------|--------|----------|---------|
| D001 | Add Sub-Deck / Nested Index rule to card system | ✅ DONE | `templates/CARD_DECK.md` — SUB-DECK / NESTED INDEX RULE section (6 rules, receipt format, when to use); `cards/README.md` — Sub-Deck reference | 2026-02-27 |
| D002 | Add Policy Pack versioning to CARD_RECEIPT format | ✅ DONE | `templates/CARD_DECK.md` +Policy Pack field; `templates/ANT_REPORT.md` +Policy Pack; `templates/INSPECTOR_REPORT.md` +policy_pack; `templates/GHOST_REVIEW.md` +policy_pack in 6b check; `cards/CARD_GPS_MAP.md` — PP-2026-02-27 defined | 2026-02-27 |
| D003 | Deploy GPS system to Sonny and RIZEND via neo-refresh | ✅ DONE | Sonny: 14 files (2 new), RIZEND: 10 files (2 new) — all synced | 2026-02-27 |
| D004 | Gap analysis — compare implementation against GPS PDF | ✅ DONE | 0 gaps — all GPS PDF requirements verified present | 2026-02-27 |
| D005 | Implement SELFHEALING.pdf — GPS Integrity Audit + Self-Healing | ✅ DONE | `roles/NEO-BECCA.md` v1.19.0: step 11d GPS INTEGRITY AUDIT (CLOSEOUT_AUDIT, 4-category check, SKIP_DETECTION, FIX_PROPOSAL, INCIDENT LOG, Rule 0, FULL-PROMPT-READ); `cards/becca/BECCA_CLOSE.md` step 11d; `cards/TASK_CARD_GPS_LINKING.md` +INCIDENT LOG section; deployed to Sonny + RIZEND (3 files each) | 2026-02-27 |
| D006 | Polish BECCA prompt — split CLOSE card, GPS-targeted reads, SaaS context | ✅ DONE | `roles/NEO-BECCA.md` v1.20.0; BECCA_CLOSE.md (289L) → 3 cards: CLOSE_ARCHIVE (87L) + CLOSE_ANALYTICS (129L) + CLOSE_GOVERNANCE (130L); 8 checkpoint gates; GPS QUICK CHECK → DEEP CHECK; FULL-PROMPT-READ → GPS-TARGETED READ; SaaS mission in identity; vague scans concretized; deployed to Sonny + RIZEND | 2026-02-27 |
| D007 | System Atlas + Rotating Deep Scan + Scan Logging | ✅ DONE | `cards/SYSTEM_ATLAS_INDEX.md` (pointer-only TOC, 5 Atlas sources, 8-area deep scan schedule); `cards/becca/BECCA_CLOSE_GOVERNANCE.md` +step 11e (rotating deep scan) +step 11f (GPS scan log) +CHECKPOINT 9; `roles/NEO-BECCA.md` v1.21.0 +ROTATING DEEP SCAN +GPS SCAN LOG sections; GPS_QUICK/GPS_DEEP/COVERAGE 3-line RUN_INDEX format; cross-refs updated (CARD_GPS_MAP, README, CLAUDE.md) | 2026-02-27 |
| D008 | GPS Integrity Hardening — evidence-cited Quick Check, CLOSE state tracking, BECCA self-scan | ✅ DONE | SCAN-003 expanded: +BECCA monolith self-check (4 acceptance criteria: SS-1→SS-4) in `SYSTEM_ATLAS_INDEX.md`; GPS QUICK CHECK: evidence-cited format (`YES (evidence: path:section)`, INVALID_CHECK rule) in `BECCA_CLOSE_GOVERNANCE.md` + monolith; Ghost `GHOST_VERDICT.md` +Section 2b EVIDENCE-CITATION RULE; CLOSE_STATE tracking in all 3 CLOSE cards (9 checkpoints); SHOW YOUR WORK in ANALYTICS card; `NEO-BECCA.md` v1.22.0 | 2026-02-27 |
| D009 | Escalation loop hardening — 8 gaps fixed in Architect + Inspector | ✅ DONE | `PROMPT_ARCHITECT.md` v1.5.0: GPS MAP targeting (P0 step 6 + Section 7 step 1), concrete verification (7b), disagree resolution (7c), ARCHITECT→INSPECTOR handoff format (Section 7 step 4), revision vs loop clarified; `PROMPT_EVOLUTION_INSPECTOR.md` v1.2.0: explicit deploy step, INSPECTOR→BECCA handoff format, loop rules diagram; cross-refs: CLAUDE.md, TASK_CARD_GPS_LINKING | 2026-02-27 |

---

## INCIDENT LOG

> Populated by BECCA during CLOSE step 11d (GPS INTEGRITY AUDIT). Each row represents a skip, route drift, or hollow execution detected during end-of-run audit. This table is APPEND-ONLY.

| Run | Incident | Severity | Type | Root Cause | Fix Status |
|-----|----------|----------|------|------------|------------|
| — | *No incidents recorded yet* | — | — | — | — |
| Run 005 | SCAN-005: PIPELINE_EVAL.md stale section refs — EVAL-03 "Section 10", EVAL-12 "Section 7", EVAL-16 "Section 14" — all point to sections that don't match current Ant report format | LOW | DOCS | Template not updated when report format section numbering changed | PROPOSED (FIX_PROPOSAL-SCAN005-001 — operator to decide) |
| RUN-006 | HIVE EVIDENCE 7-row absent (0/5 reports); FEATURE INVENTORY vague; V-NN table absent in Ghost output; policy_pack not cited; Section 6b absent from Sonny+beccaos Ghost card | MEDIUM | SKIP | Output format gaps: ANT_REPORT.md Section 11 (no template), Section 6 (no before/after spec), CARD_RECEIPT (no policy_pack); GHOST_REVIEW.md Section 11 (checklist not output table), no policy_pack gate, Section 6b missing from deployed copies | APPLIED-RUN-006 — Prompt Architect: 3 changes to ANT_REPORT.md + 4 changes to GHOST_REVIEW.md (incl. Section 6b restore); deployed to neo main + Sonny + beccaos |

**Fix Status values:** PROPOSED (fix suggested, awaiting approval) · DEFERRED (operator chose to defer) · APPLIED-Run-NNN (fix applied in specified run) · RECURRING (seen in multiple runs)

---

## CRASH RECOVERY INSTRUCTIONS

If you are a new session reading this file:

1. Read the tables above — find the first ⬜ PENDING task
2. Read `cards/CARD_GPS_MAP.md` to understand what exists
3. Read `cards/README.md` for card system overview
4. Read `templates/CARD_DECK.md` for CARD_RECEIPT format
5. Resume from the first PENDING task — do NOT redo completed work
6. After completing a task, update this file's Status + Evidence columns

---

## Changelog

### [1.5.0] 2026-02-27
- D009 completed (Escalation loop hardening — 8 gaps in Architect + Inspector)

### [1.4.0] 2026-02-27
- D008 completed (GPS Integrity Hardening — evidence-cited Quick Check, CLOSE state tracking, BECCA self-scan)

### [1.3.0] 2026-02-27
- D007 completed (System Atlas + Rotating Deep Scan + Scan Logging)

### [1.2.0] 2026-02-27
- D006 completed (Prompt polish — CLOSE card split, GPS-targeted reads, SaaS context)

### [1.1.0] 2026-02-27
- D004 completed (gap analysis — 0 gaps found)
- D005 completed (SELFHEALING.pdf implementation — GPS Integrity Audit + Self-Healing)
- Added INCIDENT LOG section (empty, ready for population by BECCA CLOSE step 11d)

### [1.0.0] 2026-02-27
- Initial mission log creation
- T001–T007 all completed (full GPS map, 4 EVAL-CARD checks)
- D001–D003 completed (Sub-Deck rule, Policy Pack versioning, deployment)
- D004 pending (gap analysis against GPS PDF)
