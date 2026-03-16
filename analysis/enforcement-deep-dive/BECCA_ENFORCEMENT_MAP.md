# BECCA ENFORCEMENT MAP
**Mission:** Deep Dive on System Skipping | **Date:** 2026-02-27 | **Analyst:** BECCA

---

## 1. EXECUTION AUTHORITY LAYERS

### Layer 1: System Instructions (CLAUDE.md — Highest Attention Weight)

| Mechanism | File:Lines | Type | Consequence | Fail-Mode |
|-----------|-----------|------|-------------|-----------|
| Context Loss Firewall | `sonny/CLAUDE.md:6-30` | HARD | Must recover from STATE.md before any work | CLOSED |
| BECCA Identity | `sonny/CLAUDE.md:35-61` | HARD | "You are NOT Claude. You are BECCA." | CLOSED |
| Response Boundary Protocol | `sonny/CLAUDE.md:65-110` | HARD | ONE gate per response, STOP after gate output | CLOSED |
| Gate Enforcement | `sonny/CLAUDE.md:216-249` | HARD | No code edit without TASK ID + all 🔑 tokens | CLOSED |
| Role Boundary | `sonny/CLAUDE.md:99-102` | HARD | BECCA may NOT Edit/Write/Bash source code | CLOSED |
| One Task Per Ant | `sonny/CLAUDE.md:104-107` | HARD | Each "I AM" = one Ant, one task | CLOSED |
| Nuclear Invariants | `sonny/CLAUDE.md:303-323` | HARD | Tenant isolation, Menu Lock, Dual Tenant | CLOSED |
| Pre-Build Verification | `sonny/CLAUDE.md:253-282` | HARD | Search before creating files | CLOSED |
| State Machine | `sonny/CLAUDE.md:114-194` | HARD | 6 states with card loading instructions | CLOSED |
| Dispatch Table | `sonny/CLAUDE.md:198-213` | SOFT | Cards first, monolith if stuck (guidance) | OPEN |

**Layer 1 verdict:** 9 HARD gates, 1 SOFT. All procedural (no code enforcement). Response Boundary is the newest — added 2026-02-27.

### Layer 2: Conversation Context (Monoliths — Loaded into Chat)

| Mechanism | File:Lines | Type | Consequence | Fail-Mode |
|-----------|-----------|------|-------------|-----------|
| BECCA Identity + Scope | `NEO-BECCA.md:48-78` | HARD | Orchestrates, does NOT execute | CLOSED |
| Load Shared Modules | `NEO-BECCA.md:32-44` | HARD | 8 modules required in order | CLOSED |
| ANT Checkpoint First | `NEO-ANT.md:29-88` | HARD | S-26 BLOCKER if no git checkpoint | CLOSED |
| Protected Collections | `NEO-ANT.md:90-146` | HARD | Count before/after, STOP if decreased | CLOSED |
| Ghost 23 Mandatory Checks | `NEO-GHOST.md:65-150+` | HARD | 13 Ant sections required, any missing = reject | CLOSED |
| Ghost CARD COMPLIANCE | `NEO-GHOST.md:475-487` | HARD | CARD_RECEIPT missing = FAIL_BLOCKING | CLOSED |

**Layer 2 verdict:** All HARD/CLOSED. But monoliths are 1,000-2,000 lines — attention degrades with distance from conversation top.

### Layer 3: Point-of-Use (Cards — Loaded Fresh at Phase Start)

| Card | File | END RESPONSE Marker | STOP Conditions | Fail-Mode |
|------|------|-------|------|-----------|
| ANT_CHECKPOINT | `cards/ant/ANT_CHECKPOINT.md` | YES (line ~54) | S-25, S-26, S-28 BLOCKER | CLOSED |
| ANT_DISCOVERY | `cards/ant/ANT_DISCOVERY.md` | YES ("🔑 DISCOVERY OK?") | S-01, S-07/S-08 NUCLEAR, S-14, S-25/S-28/S-30 | CLOSED |
| ANT_FOOTPRINT | `cards/ant/ANT_FOOTPRINT.md` | YES ("🔑 FOOTPRINT OK?") | S-13, S-35 | CLOSED |
| ANT_PATCH | `cards/ant/ANT_PATCH.md` | YES ("🔑 PATCH OK?") | S-02, S-15 | CLOSED |
| ANT_VERIFY | `cards/ant/ANT_VERIFY.md` | YES ("🔑 VERIFY OK?") | S-02, S-15, S-29, S-31, S-32 | CLOSED |
| ANT_REPORT | `cards/ant/ANT_REPORT.md` | YES ("I AM (Ghost)") | Pre-submit self-review (5 checks) | CLOSED |
| GHOST_REVIEW | `cards/ghost/GHOST_REVIEW.md` | — | 14 compliance checks, AUTO REJECT conditions | CLOSED |
| GHOST_VERDICT | `cards/ghost/GHOST_VERDICT.md` | YES ("I AM") | 8 AUTO-REJECT triggers | CLOSED |
| BECCA_RECON | `cards/becca/BECCA_RECON.md` | YES ("I AM (Scout)") | RESPONSE BOUNDARY block | CLOSED |
| BECCA_CLOSE_GOVERNANCE | `cards/becca/BECCA_CLOSE_GOVERNANCE.md` | — | GPS audit, merge gate | CLOSED |

**Layer 3 verdict:** All cards have END RESPONSE markers and STOP conditions. All fail-closed. BUT: cards are only effective if they're actually loaded (see Root Cause Analysis).

### Layer 4: Gate Infrastructure (NEO-GATES.md + NEO-ACTIVATION.md)

**S-Conditions:** 37 total (`NEO-GATES.md:214-250`)
- 12 BLOCKER (pipeline cannot proceed)
- 5 NUCLEAR (hard halt, not pause)
- 17 HIGH (must address before proceeding)
- 4 MEDIUM (operator decides)

**V-Violations:** 13 total (`NEO-GATES.md:584-625`)
- ALL auto-reject in Ghost review

**Gate Tokens:** 11 named (`NEO-GATES.md:560-680`)
- All require explicit operator approval

**Response Boundary:** `NEO-ACTIVATION.md:Section 0` — one gate per response

---

## 2. WHERE OUTPUTS ARE ACCEPTED/MERGED EVEN IF MISSING SECTIONS

### Ghost Acceptance Path (the critical chokepoint)

Ghost is the ONLY enforcement point between Ant output and merge. Evidence:

| Gate | Ghost Checks For | What If Missing | Source |
|------|-----------------|----------------|--------|
| CARD_RECEIPT | Section present in Ant report | FAIL_BLOCKING | `NEO-GHOST.md:475-487` |
| Evidence citations | file:line format | INVALID_CHECK = FAIL | `GHOST_VERDICT.md:27-30` |
| 13 report sections | All present | AUTO REJECT | `GHOST_REVIEW.md:19-33` |
| Evidence score | >=70% | AUTO REJECT if <50% | `GHOST_REVIEW.md:41` |
| V-01 through V-13 | No violations | AUTO REJECT | `GHOST_VERDICT.md:17` |
| Five Horsemen | H1 check | AUTO REJECT if hallucination | `GHOST_VERDICT.md:23` |
| SAAS Safety | Critical items | AUTO REJECT for tenant/secret/env | `GHOST_REVIEW.md:75-85` |

**The problem:** Ghost is honor-system enforced. No upstream mechanism prevents Ghost from skipping its own checklist. Ghost CAN approve an Ant report without checking CARD_RECEIPT, and nobody catches it until BECCA's GPS audit — which runs only during CLOSE (and CLOSE happens 0.7% of the time — see Skip Point Report).

### Inspector Acceptance Path

Inspector audits compliance AFTER Ghost approves. But Inspector also:
- Does NOT check if Ghost checked CARD_RECEIPT (`cards/inspector/INSPECTOR_AUDIT.md` — no explicit Ghost-review-of-Ghost-review)
- Does NOT verify Ghost was thorough
- Checks governance compliance of the Ant's work, not Ghost's review quality

### BECCA Acceptance Path (CLOSE)

BECCA's GPS audit (`BECCA_CLOSE_GOVERNANCE.md:steps 11d-11f`) re-validates:
- Card compliance, evidence citations, gate behavior
- BUT: Only runs during CLOSE
- CLOSE runs 0.7% of the time (1 out of 143 Sonny runs)

---

## 3. SUMMARY: ENFORCEMENT TOPOLOGY

```
CLAUDE.md (Layer 1) ─── ALWAYS LOADED ─── Identity + Boundaries + Response Boundary
    │
    ├── Cards (Layer 3) ─── LOADED PER PHASE ─── Checklists + STOP conditions + END RESPONSE
    │       │
    │       └── Ghost Card ─── THE CHOKEPOINT ─── 24 fail-closed checks (honor system)
    │               │
    │               └── Inspector Card ─── GOVERNANCE AUDIT ─── Does NOT audit Ghost
    │
    ├── Monoliths (Layer 2) ─── LOADED INTO CHAT ─── Detailed procedures (attention fades)
    │
    └── BECCA CLOSE (Layer 2+3) ─── RUNS 0.7% OF THE TIME ─── GPS audit, health intelligence
```

**Critical finding:** The system has 87 enforcement mechanisms, 59 of which are hard/fail-closed. But enforcement is pyramidal — everything depends on Ghost being thorough, and Ghost enforcement is honor-system. BECCA CLOSE is the safety net, but it almost never runs.
