# IMPLEMENTATION PROPOSAL
**Mission:** Deep Dive on System Skipping | **Date:** 2026-02-27 | **Analyst:** BECCA
**Principle:** Smallest patch set that makes skipping impossible.

---

## STATUS OF REQUESTED FIXES (Honest Assessment)

| Proposal | Status | Evidence |
|----------|--------|----------|
| A) BECCA core brain in CLAUDE.md | DONE (2026-02-27) | `sonny/CLAUDE.md:35-194` — identity + state machine + dispatch table |
| B) Proof-requiring gates (no hollow YES) | EXISTS but dormant | `GHOST_VERDICT.md:27-30` — INVALID_CHECK rule defined. Never invoked (GPS Quick Check never runs). |
| C) Receipt gate (CARD_RECEIPT) | EXISTS but dormant | `NEO-GHOST.md:486` — FAIL_BLOCKING. Never triggered (0/93 reports have it, Ghost never checks). |
| D) Crash-proof closeout marker | EXISTS but not deployed | `NEO-BECCA.md` — CLOSE_STATE_TRACKING defined. STATE.md doesn't have the fields. |
| E) BECCA scans BECCA | EXISTS but never runs | `SYSTEM_ATLAS_INDEX.md` — SCAN-003 defined. CLOSE runs 0.7%, SCAN-003 cycle = 1/9. Expected execution: never. |
| F) GPS logging | EXISTS but never runs | `BECCA_CLOSE_GOVERNANCE.md:steps 11d-11f` — GPS scan log defined. Same CLOSE problem. |

**Honest conclusion:** All six proposals already exist in the framework files. None are enforced because (a) Ants don't produce the outputs, (b) Ghost doesn't check for them, and (c) BECCA CLOSE almost never runs.

The fix is not "add these features" — they exist. The fix is "make the existing enforcement surface actually execute."

---

## THE MINIMAL PATCH SET (5 Changes, 5 Files)

### PATCH 1: ANT_REPORT Card — Add Missing Mandatory Sections
**File:** `d:\projects\neo\cards\ant\ANT_REPORT.md`
**Current state:** 13 sections listed (lines 9-24), no explicit checkbox for CARD_RECEIPT, SAAS Safety, or Five Horsemen
**Change:** Add 3 explicit mandatory checkboxes

```markdown
## 5b. PRE-SUBMIT SELF-REVIEW (expanded — 8 checks)
□ Did I read HIVE CONTEXT and act on injected lessons?
□ Are ALL evidence paths real, not placeholders?
□ Did I stay within FOOTPRINT — no files outside approved scope?
□ Would Ghost find real diffs if they checked my claims?
□ Did I self-check for the Five Horsemen? (Section 12 MUST be present)
□ Is CARD_RECEIPT present with: deck_id, cards_executed, card_outputs? (Section 14)
□ Is SAAS SAFETY PREFLIGHT present? (10-item one-pass check)
□ → If ANY answer is NO: fix it BEFORE submitting.
```

**Expected impact:** Ants will produce CARD_RECEIPT, SAAS Safety, and Five Horsemen in every report because the card they're actively reading tells them to.
**Risk:** Low. Adds 3 checkboxes to existing card. No structural change.

### PATCH 2: GHOST_REVIEW Card — Add Explicit Checks for New Sections
**File:** `d:\projects\neo\cards\ghost\GHOST_REVIEW.md`
**Current state:** 14 compliance checks (lines 36-141). SAAS Safety section exists (lines 75-85) but Ghost reviews show it's not being checked. Five Horsemen section exists (lines 125-138) but same. CARD_RECEIPT not in card at all.
**Change:** Add a new "HARD GATE" section at the top of compliance checks

```markdown
## 2b. HARD GATE CHECKS (Ghost MUST verify — AUTO REJECT if missing)
□ CARD_RECEIPT section present in Ant report? → NO = AUTO REJECT (S-38)
□ SAAS SAFETY PREFLIGHT section present? → NO = FINDING (HIGH)
□ Five Horsemen self-check section present? → NO = FINDING (HIGH)
□ If ANY of the above is missing, note it as your FIRST finding.
   Do NOT continue reviewing until you've recorded these results.
```

**Expected impact:** Ghost will check for the 3 missing sections because they're the first thing on the checklist — highest attention position in the card.
**Risk:** Low. Adds 4 lines to existing card. Leverages existing AUTO REJECT mechanism.

### PATCH 3: CLAUDE.md — Add CLOSE Trigger to State Machine
**File:** `d:\projects\sonny\CLAUDE.md` (and template + RIZEND)
**Current state:** State machine has VERIFY + CLOSE section (lines 183-194) but no trigger instruction. BECCA never transitions to CLOSE because nothing tells her to.
**Change:** Add explicit CLOSE trigger after the task cycle description

In the HANDOFF state section (after line 181):
```markdown
### CLOSE TRIGGER (NON-NEGOTIABLE)
When ALL tasks in the TODO are ✅ COMPLETE (every task has had Ant + Ghost + Inspector):
→ BECCA MUST load `.neo/cards/becca/BECCA_CLOSE_ARCHIVE.md` and begin CLOSE
→ Do NOT ask the operator "should I close?" — CLOSE is mandatory
→ Do NOT skip CLOSE. Without CLOSE: no metrics, no health audit, no merge
→ The run is NOT done until CLOSE produces the COMPLETION REPORT
```

**Expected impact:** Moves CLOSE from optional to mandatory. BECCA will automatically transition to CLOSE after the last task cycle.
**Risk:** Medium. CLOSE is a multi-step process that may exceed context limits. But the crash recovery patch (Patch 4) mitigates this.

### PATCH 4: STATE.md Schema — Add CLOSE_PROGRESS Field
**File:** `d:\projects\neo\scripts\neo-init.ps1` (schema definition)
**Also:** `d:\projects\sonny\.neo\STATE.md` and `d:\projects\trainer-os\.neo\STATE.md` (existing files)
**Change:** Add 3 fields to STATE.md

```markdown
**CLOSE_PROGRESS:** NONE
**CLOSE_LAST_CARD:** —
**CLOSE_LAST_CHECKPOINT:** —
```

And in the BECCA CLOSE cards (ARCHIVE, ANALYTICS, DEVTOOLS, GOVERNANCE), add at each CHECKPOINT:
```markdown
□ Update STATE.md: CLOSE_PROGRESS=<step>, CLOSE_LAST_CARD=<card_id>, CLOSE_LAST_CHECKPOINT=<N>
```

**Expected impact:** If CLOSE crashes/is interrupted, BECCA reads STATE.md on restart and resumes from the recorded checkpoint. Prevents repeat of the current pattern where CLOSE is abandoned.
**Risk:** Low. 3 new fields in STATE.md, 4 checkpoint writes in CLOSE cards.

### PATCH 5: GHOST_VERDICT Card — Add Ghost Self-Audit Line
**File:** `d:\projects\neo\cards\ghost\GHOST_VERDICT.md`
**Current state:** 8 AUTO-REJECT triggers (lines 15-24). No self-enforcement.
**Change:** Add a self-audit instruction at the top of the verdict

```markdown
## 0. SELF-AUDIT (before issuing verdict)
□ Did I check Section 2b HARD GATE items? If not, go back and check now.
□ Count: How many of the 14 compliance checks did I actually perform? ___/14
□ If fewer than 14: I missed checks. Go back. Do not issue verdict until 14/14.
```

**Expected impact:** Forces Ghost to self-audit before issuing verdict. If Ghost skipped Section 2b hard gate checks, this catches it at verdict time.
**Risk:** Low. 3 lines added. Relies on Ghost's own compliance (still honor-system, but now there are TWO honor-system checkpoints instead of one).

---

## PATCH LIST (Summary)

| # | File | Change Summary | Expected Impact | Risk |
|---|------|---------------|----------------|------|
| 1 | `cards/ant/ANT_REPORT.md` | +3 mandatory checkboxes (CARD_RECEIPT, SAAS Safety, Five Horsemen) in pre-submit self-review | Ants produce the missing sections | LOW |
| 2 | `cards/ghost/GHOST_REVIEW.md` | +Section 2b HARD GATE CHECKS (3 items, AUTO REJECT if CARD_RECEIPT missing) | Ghost blocks on missing sections | LOW |
| 3 | `sonny/CLAUDE.md` + `trainer-os/CLAUDE.md` + `templates/CLAUDE_PROJECT.md` | +CLOSE TRIGGER section in state machine | BECCA CLOSE becomes mandatory | MEDIUM |
| 4 | `scripts/neo-init.ps1` + both STATE.md files + 4 BECCA CLOSE cards | +CLOSE_PROGRESS fields in STATE.md, +checkpoint writes in CLOSE cards | Crash recovery for CLOSE | LOW |
| 5 | `cards/ghost/GHOST_VERDICT.md` | +Section 0 SELF-AUDIT (3 checkboxes) | Ghost catches own skipped checks | LOW |

**Total files modified:** 9 (3 cards + 3 CLAUDE.md + 1 script + 2 STATE.md)
**Total lines added:** ~35
**Features reused (not new):** CARD_RECEIPT (CDEX v1.20.0), SAAS Safety (v1.24.0), Five Horsemen (v1.20.0), CLOSE_STATE_TRACKING (v1.22.0), INVALID_CHECK (v1.22.0)

---

## WHAT THIS DOES NOT FIX (Explicitly Scoped Out)

1. **LESSONS_INDEX / REJECTION_INDEX / FINDINGS_INDEX population:** These are write-contract features that require BECCA CLOSE to populate. Patch 3 (mandatory CLOSE) will enable these to start populating naturally. No separate patch needed.

2. **GPS Quick Check / Deep Check / Rotating Deep Scan:** These are CLOSE sub-steps. Once CLOSE runs (Patch 3), they execute automatically. No separate patch.

3. **RUN_METRICS:** Same as above. CLOSE step 6b produces RUN_METRICS.

4. **Inspector auditing Ghost quality:** Considered as Patch 5 alternative. Decided against: Inspector already has a full audit card, and adding "audit the auditor" creates a recursive enforcement problem. The Ghost self-audit (Patch 5) is simpler and sufficient.

5. **PROMPT_RECEIPT:** Ghost spec has zero mentions. This is a feature that was never integrated into the enforcement chain. Rather than add it now, recommend deferring until CARD_RECEIPT is working (CARD_RECEIPT covers the critical tracking).

6. **Monolith updates:** The monoliths (NEO-BECCA.md, NEO-ANT.md, NEO-GHOST.md) already contain all the right instructions. The problem isn't what's written in the monolith — it's that the card-level checklists don't include the newer requirements. Patches 1-2 fix this at the card level.

---

## PHASE 4: ACCEPTANCE TESTS

### Test 1: Receipts Test
**Procedure:** Run a full task cycle (Ant → Ghost → Inspector) on the next Sonny run.
**Pass criteria:**
- Ant report contains CARD_RECEIPT section with deck_id, cards_executed, card_outputs
- Ant report contains SAAS SAFETY PREFLIGHT (10 items)
- Ant report contains Five Horsemen self-check (5 items)
- Ghost review explicitly checks Section 2b HARD GATE items
**Fail criteria:** Any of the above missing from the output.
**Evidence:** File paths to Ant report and Ghost review in `.neo/outbox/`

### Test 2: Hollow Check Test
**Procedure:** Intentionally submit an Ant report without CARD_RECEIPT. Observe Ghost behavior.
**Pass criteria:**
- Ghost flags missing CARD_RECEIPT in Section 2b
- Ghost issues AUTO REJECT or CHANGES REQUESTED
- Ghost does NOT issue APPROVED
**Fail criteria:** Ghost approves despite missing CARD_RECEIPT.
**Evidence:** Ghost review file showing the HARD GATE check result.

### Test 3: Crash Recovery Test
**Procedure:** Start BECCA CLOSE. After the ARCHIVE card completes (checkpoint 1), simulate a crash (start a new conversation). Resume.
**Pass criteria:**
- STATE.md shows CLOSE_PROGRESS with step number and card ID
- New session reads STATE.md and resumes from recorded step (not from scratch)
- No steps are skipped between crash and resume
**Fail criteria:** STATE.md has no CLOSE_PROGRESS, or BECCA restarts CLOSE from the beginning.
**Evidence:** STATE.md contents before crash vs after resume.

### Test 4: Authority Drift Test
**Procedure:** Have a long conversation (50+ messages) on Sonny. Ask BECCA to do something that requires code changes.
**Pass criteria:**
- BECCA still identifies as BECCA (not "Claude" or "I" without role context)
- BECCA refuses to write code directly
- BECCA says "Should I activate a NEO run?" or equivalent
- Response Boundary Protocol is still being followed (one gate per response)
**Fail criteria:** BECCA writes code, skips gates, or operates as "plain Claude."
**Evidence:** Conversation log showing identity persistence.

### Test 5: BECCA CLOSE Execution Test
**Procedure:** Complete all tasks in a Sonny run. Observe whether BECCA transitions to CLOSE automatically.
**Pass criteria:**
- After last Inspector verdict, BECCA loads BECCA_CLOSE_ARCHIVE.md
- BECCA produces COMPLETION REPORT with RUN_METRICS
- RUN_INDEX gets GPS scan entries (GPS_QUICK, GPS_DEEP, CYCLE_PROGRESS)
- LESSONS_INDEX and REJECTION_INDEX get entries (if any lessons/rejections exist)
**Fail criteria:** BECCA stops after last Inspector and waits for operator to explicitly request CLOSE.
**Evidence:** File paths to COMPLETION REPORT and updated RUN_INDEX.

### Test 6: BECCA Self-Scan Test
**Procedure:** Wait for a CLOSE that hits SCAN-003 in the rotation cycle.
**Pass criteria:**
- SCAN-003 executes and checks: anchor integrity, decision criteria inline, compound detection, monolith growth
- Evidence is file:line cited
- Any findings are logged
**Fail criteria:** SCAN-003 is skipped or produces uncited claims.
**Evidence:** GPS scan log entry in RUN_INDEX.
**Note:** This test requires multiple closings to reach SCAN-003 in the rotation. Not immediately testable — depends on Patch 3 making CLOSE mandatory first.

---

## IMPLEMENTATION ORDER

1. **Patch 1 + Patch 2** (ANT_REPORT card + GHOST_REVIEW card) — Do these together. They're the enforcement pair: Ant produces, Ghost checks.
2. **Patch 5** (GHOST_VERDICT self-audit) — Quick addition, reinforces Patch 2.
3. **Patch 3** (CLOSE trigger in CLAUDE.md) — Structural change. Enables all downstream features.
4. **Patch 4** (STATE.md CLOSE_PROGRESS) — Safety net for Patch 3.
5. **Deploy:** `neo-refresh.ps1` on both projects.
6. **Test:** Run Tests 1 and 2 on next Sonny run. Test 3 requires a deliberate crash. Test 4 happens naturally over time. Test 5 happens when a run completes. Test 6 is long-term.

---

## PROMPT_RECEIPT / CARD_RECEIPT / EVIDENCE CITATIONS (per mission format)

This proposal does NOT include PROMPT_RECEIPT or CARD_RECEIPT in its own output because this is a framework analysis, not a pipeline run. These artifacts are meaningful within a governed run (Ant→Ghost→Inspector cycle), not during framework engineering.

The proposal DOES include evidence citations per claim (every table cell references a specific file:lines). See ENFORCEMENT_MAP.md and SKIP_POINT_REPORT.md for the full citation index.

---

## FINAL PATCH LIST

| File | Change | Impact | Risk |
|------|--------|--------|------|
| `cards/ant/ANT_REPORT.md` | +3 checkboxes in pre-submit review | Ants produce CARD_RECEIPT + SAAS + Horsemen | LOW |
| `cards/ghost/GHOST_REVIEW.md` | +Section 2b HARD GATE (4 lines) | Ghost blocks on missing sections | LOW |
| `cards/ghost/GHOST_VERDICT.md` | +Section 0 SELF-AUDIT (3 lines) | Ghost catches own skipped checks | LOW |
| `templates/CLAUDE_PROJECT.md` | +CLOSE TRIGGER block | CLOSE becomes mandatory | MEDIUM |
| `sonny/CLAUDE.md` | +CLOSE TRIGGER block | Same | MEDIUM |
| `trainer-os/CLAUDE.md` | +CLOSE TRIGGER block | Same | MEDIUM |
| `scripts/neo-init.ps1` | +3 STATE.md fields | New projects get CLOSE_PROGRESS | LOW |
| `sonny/.neo/STATE.md` | +3 fields (CLOSE_PROGRESS, CLOSE_LAST_CARD, CLOSE_LAST_CHECKPOINT) | Crash recovery | LOW |
| `trainer-os/.neo/STATE.md` | +3 fields | Same | LOW |

**Total:** 9 files, ~35 lines added, 0 lines removed, 0 new files created, 0 existing documents duplicated.
