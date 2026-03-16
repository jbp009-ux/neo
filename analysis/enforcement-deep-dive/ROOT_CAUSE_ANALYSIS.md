# ROOT CAUSE ANALYSIS
**Mission:** Deep Dive on System Skipping | **Date:** 2026-02-27 | **Analyst:** BECCA
**Evidence base:** ENFORCEMENT_MAP.md + SKIP_POINT_REPORT.md + Ghost Enforcement Audit

---

## FAILURE MODE ASSESSMENT

### FM-1: AUTHORITY DRIFT — CONFIRMED

**Definition:** BECCA "brain" lives in long context (monolith) and fades. Model reverts to plain assistant behavior.

**Evidence:**
- Run 144 (2026-02-27): BECCA completed 10 POS tasks as a single Ant in one response — zero gate approvals, no card loads, no "I AM" confirmations, no Ghost reviews. (Operator chat log — provided in session)
- CLAUDE.md previously said "YOU ARE UNDER NEO GOVERNANCE" — a description, not an identity. The model read it as context about a system, not as its own identity.
- Source: `sonny/CLAUDE.md:33` (old version, now replaced)

**Status:** FIXED (2026-02-27). CLAUDE.md now says "YOU ARE BECCA" with:
- Identity block (`sonny/CLAUDE.md:35-61`)
- Response Boundary Protocol (`sonny/CLAUDE.md:65-110`)
- Core State Machine with card loading instructions (`sonny/CLAUDE.md:114-194`)
- All cards have END RESPONSE markers

**Remaining risk:** The fix is hours old. No production runs have tested it yet. If the model ignores the Response Boundary (possible with very long conversations or if the operator gives contradictory instructions), there's no fallback except the operator manually stopping generation.

---

### FM-2: OPTIONAL ENFORCEMENT — CONFIRMED (PRIMARY ROOT CAUSE)

**Definition:** Outputs without receipts are still accepted. The pipeline is fail-open.

**Evidence (quantitative):**
- CARD_RECEIPT: 0 of 93 Ant reports contain it. 0 of 83 Ghost reviews flag the absence.
- PROMPT_RECEIPT: 0 of 93 Ant reports. Ghost spec (`NEO-GHOST.md`) has zero mentions of PROMPT_RECEIPT.
- SAAS Safety Preflight: 0 of 93 Ant reports.
- Five Horsemen self-check: 0 of 93 Ant reports.
- BECCA CLOSE: 1 of 143 runs (0.7%).

**Why it happens:**

The enforcement chain has a **single chokepoint** — Ghost review. Ghost is the ONLY role that can block Ant output from being accepted. Evidence:

```
ANT produces output → Ghost reviews → Inspector audits governance → BECCA closes
                       ↑                                              ↑
                  ONLY BLOCKER                                   RUNS 0.7% OF TIME
```

Ghost's enforcement is **honor-system only**:
- Ghost has 24 fail-closed checks defined in `GHOST_REVIEW.md` and `GHOST_VERDICT.md`
- Ghost has 8 AUTO-REJECT triggers in `GHOST_VERDICT.md:15-24`
- BUT: No upstream mechanism prevents Ghost from skipping its own checklist
- Ghost's own review card doesn't have an END RESPONSE marker for each check
- Ghost reviews follow a learned pattern from early runs (10 sections) that predates the 13-section requirement

**The real fail-open point:** Ghost CAN approve without checking CARD_RECEIPT, and nothing catches it. Inspector doesn't audit Ghost's thoroughness. BECCA's GPS audit could catch it, but CLOSE runs 0.7% of the time.

---

### FM-3: HOLLOW COMPLIANCE — PARTIALLY CONFIRMED

**Definition:** Checklists can be answered YES without proof.

**Evidence:**
- GPS Quick Check Q1-Q8 (`BECCA_CLOSE_GOVERNANCE.md:65-80`): **Never executed.** The `YES (evidence: path:section)` format exists in the framework but has never appeared in any output. The INVALID_CHECK rule (`GHOST_VERDICT.md:27-30`) has never been invoked.
- HIVE EVIDENCE PROOF tables: **Actually solid.** 5+ indexes checked with evidence in all sampled Ant reports. Ghost verifies these.
- Gate tokens: **Real.** Exact tokens matched in Ghost reviews.
- Evidence citations: **Real.** Ghost spot-checks and re-executes.

**Assessment:** Core evidence is genuine (not hollow). But the GPS-level and BECCA CLOSE-level checks that would catch systemic issues have never run, so we can't assess if they'd be hollow or real.

**Status:** PARTIALLY fixed. The INVALID_CHECK rule exists but has no active enforcement surface (GPS Quick Check never runs, BECCA CLOSE almost never runs).

---

### FM-4: CRASH/RESTART BLINDNESS — CONFIRMED

**Definition:** After interruptions, pipeline resumes by guessing, causing skips.

**Evidence:**
- STATE.md (`sonny/.neo/STATE.md`) has 12 lines. Missing fields: CLOSE_PROGRESS, DEVTOOLS_CHIEF, DEVTOOLS_ESCALATED, DEVTOOLS_EVIDENCE.
- The CLOSE_STATE_TRACKING feature was defined in NEO-BECCA v1.22.0 (`roles/NEO-BECCA.md` — CLOSE STATE TRACKING section) but **never implemented in STATE.md schema**.
- On crash/restart, BECCA reads STATE.md and sees: `Status: IN_PROGRESS`. No information about which step of which phase was in progress. BECCA must guess.
- Context Loss Firewall (`CLAUDE.md:6-30`) tells the model to read STATE.md → TODO → latest outbox report. This helps recover WHICH TASK but not WHICH STEP within a task.

**Impact:** If BECCA CLOSE is interrupted (which is likely given 0.7% completion rate — the operator may be abandoning/crashing mid-close), there's no way to resume from the last checkpoint. The close either starts over or is abandoned.

---

### FM-5: BECCA NOT SCANNING BECCA — CONFIRMED

**Definition:** Monolith/prompt drifts from cards/anchors. No self-audit.

**Evidence:**
- SCAN-003 (BECCA self-scan) defined in `cards/SYSTEM_ATLAS_INDEX.md` with 4 acceptance criteria (SS-1 through SS-4)
- SCAN-003 is part of the Rotating Deep Scan: 1 of 8 (now 9) areas per closeout
- But CLOSE runs 0.7% of the time, and Rotating Deep Scan is step 11f of CLOSE
- Even if CLOSE ran every time, SCAN-003 would execute once every 9 closings
- At 0.7% close rate, expected SCAN-003 frequency: once every ~1,286 runs
- **SCAN-003 has never executed.** Zero evidence in RUN_INDEX or any outbox file.

**The monolith has drifted:**
- NEO-BECCA.md is at v1.23.0 (2,600+ lines)
- It references features that don't exist in practice (CARD_RECEIPT, LESSONS_INDEX, GPS Quick Check)
- Cards reference the monolith as a fallback ("monolith only if stuck")
- But the monolith itself contains instructions for features that have never worked
- Nobody is checking whether the monolith matches reality

---

## SYNTHESIZED ROOT CAUSE

The five failure modes are not independent. They compound:

```
FM-1 (Authority Drift) → Model doesn't know it's BECCA → Skips everything
     ↓ FIXED (CLAUDE.md identity)
FM-2 (Optional Enforcement) → Ghost is honor-system → New features never enforced
     ↓ NOT FIXED
FM-5 (No Self-Scan) → BECCA doesn't close → Can't detect drift
     ↓ NOT FIXED
FM-4 (Crash Blindness) → Close attempts crash → Close rate stays at 0.7%
     ↓ NOT FIXED
FM-3 (Hollow Compliance) → GPS checks never run → INVALID_CHECK rule is theoretical
     ↓ NOT FIXED
```

**The causal chain:**
1. Framework added 50+ requirements across v1.17-v1.24
2. BECCA CLOSE (which audits compliance) almost never runs
3. Ghost (the only active blocker) follows a pre-v1.17 review pattern
4. New requirements exist in monolith but not in Ghost's actual checklist behavior
5. No mechanism forces Ghost to update its review pattern
6. Therefore: core mechanics work (they were baked in from v1.0), new features don't

**The single biggest problem:** BECCA CLOSE almost never happens. Without CLOSE:
- No GPS audit (so no drift detection)
- No health intelligence (so no trend alerts)
- No index population (so no institutional learning)
- No self-scan (so no monolith verification)
- No run metrics (so no quantitative health tracking)

Everything downstream of CLOSE is dead because CLOSE is dead.

---

## WHAT NEEDS TO CHANGE (PRIORITIZED)

| Priority | Root Cause | Fix | Leverage |
|----------|-----------|-----|----------|
| **P0** | FM-2: Ghost doesn't check new sections | Add CARD_RECEIPT + SAAS Safety + Five Horsemen to Ghost card as explicit checkboxes | Immediate — Ghost blocks on every task |
| **P1** | FM-2: Ants don't produce new sections | Add CARD_RECEIPT + SAAS Safety + Five Horsemen to Ant Report card | Immediate — Ants include in every report |
| **P2** | FM-5+FM-3: BECCA CLOSE never runs | Add CLOSE trigger to CLAUDE.md state machine (after last task, before merge) | Structural — enables all downstream features |
| **P3** | FM-4: No crash recovery for CLOSE | Add CLOSE_PROGRESS to STATE.md schema | Safety net — CLOSE can resume |
| **P4** | FM-2: Ghost enforcement is honor-system | Inspector audits Ghost review quality (new check) | Defense in depth — catches Ghost skipping |

These 5 changes address all 5 failure modes with minimal file edits.
