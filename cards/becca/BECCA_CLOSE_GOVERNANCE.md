# BECCA CLOSE — GOVERNANCE CARD
**CARD_ID:** BECCA-CLOSE-GOVERNANCE | **Phase:** CLOSE (4 of 4) | **Role:** BECCA
**INPUTS:** CLOSE-ANALYTICS outputs, CLOSE-DEVTOOLS verdict (🔑 DEVTOOLS VERIFICATION APPROVED), CARD_GPS_MAP.md, all task artifacts
> After DEVTOOLS card completes, load this card. Steps 11-13: governance checks, GPS audit, merge, sign off.
> Cognitive mode: judgment and decisions. Every section may require operator input.
> **CLOSE STATE:** Continue updating STATE.md at each checkpoint (see CLOSE_ARCHIVE card for format).

---

### Step 11: FRAMEWORK HEALTH CHECK
□ Scan 6 signal sources:
  - FINDINGS_INDEX: any type with count >=3 (RECURRING)
  - REJECTION_INDEX: any category appearing 3+ times this run
  - Prompt feedback: any CONFUSED or MISSING items from step 9
  - Pheromone debt: net delta GROWING for 2+ consecutive runs
  - Strike 3 escalations: any this run
  - Manual drift: OPERATOR_MANUAL not updated in 5+ runs
□ If signals found: recommend Prompt Architect activation
□ If zero signals: "No framework health signals. Ecosystem healthy."

### Step 11b: PROTOCOL ADOPTION SCAN
□ For each Ant report, check 7 signals:
  | Signal | Present? |
  |--------|----------|
  | CHECKPOINT PROOF table | YES/NO |
  | HIVE EVIDENCE PROOF (7-row table) | YES/NO |
  | COMMAND PROOF (actual grep output) | YES/NO |
  | BUDGET LEDGER (with numbers) | YES/NO |
  | TRUTHY DIFFS (7/7 listed) | YES/NO |
  | DISCOVERY STRATEGY (ONE QUESTION + answer) | YES/NO |
  | FEATURE INVENTORY (before/after table) | YES/NO |
□ For each Ghost review, check 4 signals:
  | HORSEMEN VERDICT (H1-H5) | Full violation scan (V-01→V-13) | Evidence re-execution | Scope contraction check |
□ Score: PROTOCOL ADOPTION = signals found / signals expected x 100
□ If <70%: "Protocol adoption low — inject cards explicitly next run"
□ Trend vs last 3 runs: IMPROVING / STABLE / DECLINING / FIRST RUN
□ Record in RUN_INDEX

---

**□ CHECKPOINT 7:** Health + adoption scored. Does step 11c trigger?
□ Update STATE.md: `CLOSE_PROGRESS: step 11b of 21 | card: CLOSE_GOVERNANCE | checkpoint: 7`
  TRIGGER: step 11 signals found OR step 11b adoption <70% (restate: the threshold is 70%)
  If NOT triggered: skip to Step 11d (GPS INTEGRITY AUDIT).

---

### Step 11c: FRAMEWORK FIX ESCALATION (conditional)
□ Present FRAMEWORK HEALTH ADVISORY to operator:
  ```
  FRAMEWORK HEALTH ADVISORY — Run <N>
  ADOPTION SCORE: ___%  (trend: IMPROVING/STABLE/DECLINING)
  FAILED SIGNALS: <list with likely cause per signal>
  BECCA'S DIAGNOSIS: <what's broken and why>
  BECCA'S FIX SUGGESTION: <specific files + sections>
  RECOMMEND: Activate Prompt Architect → "I AM"
  ```
□ WAIT for operator: "I AM" (escalate) or "skip" (proceed to 11d)
□ If escalated: 9-step Architect flow (see monolith). ONE attempt per run, no loops.

---

### Step 11d: GPS INTEGRITY AUDIT

**RULE 0:** Focused scanning — catch what matters, don't drown. Quick check first; deep check only where issues appear.

#### GPS QUICK CHECK (always — evidence-cited, per task)
□ Read `cards/CARD_GPS_MAP.md` — know expected routes and current policy_pack
□ For each task artifact this run, score these 8 checks:
  **FORMAT: YES (evidence: <path>:<section or line>) or NO (evidence: <path>:<what's missing>)**
  **HARD RULE: Any uncited YES/NO is INVALID_CHECK — treated as NO.**
  | # | Check | Result + Evidence |
  |---|-------|-------------------|
  | Q1 | CARD_RECEIPT section exists? | YES/NO (evidence: `<report_path>`:Section 12) |
  | Q2 | policy_pack matches current PP-<date>? | YES/NO (evidence: `<report_path>`:CARD_RECEIPT.policy_pack) |
  | Q3 | All 5 CORE cards accounted for? | YES/NO (evidence: `<report_path>`:cards_executed list) |
  | Q4 | Ghost Section 6b (Card Compliance) exists? | YES/NO (evidence: `<ghost_review_path>`:Section 6b) |
  | Q5 | All card IDs valid per CARD_GPS_MAP.md? | YES/NO (evidence: each card ID → GPS MAP match) |
  | Q6 | Cards in correct phase order? | YES/NO (evidence: cards_executed order vs GPS sequence) |
  | Q7 | "I AM" at each state transition? | YES/NO (evidence: `<report_path>`:gate tokens listed) |
  | Q8 | STOP conditions respected? | YES/NO (evidence: no S-NN violations in Ghost review) |
□ GPS QUICK SCORE = passed / total checks (INVALID_CHECK counts as failed)
□ **If 100%: GPS VERDICT: CLEAN → skip to Step 11e (ROTATING DEEP SCAN)**
□ **If < 100%: proceed to GPS DEEP CHECK below**

#### GPS DEEP CHECK (only on failures from Quick Check)
□ For EACH failed check:
  1. **SKIP_DETECTION block:**
     | who | what_skipped | where_detected | evidence | severity | impact |
  2. **GPS-TARGETED READ** (not full-file — use GPS MAP coordinates):
     → Read `CARD_GPS_MAP.md` to find the exact line range for the skipped card
     → Read ONLY that section of the role prompt (e.g., NEO-ANT.md L700-756)
     → If section doesn't explain the skip: read the card file (e.g., cards/ant/ANT_FOOTPRINT.md)
     → Only if BOTH fail: read adjacent sections. Never load the full role file.
  3. **Root cause:** instruction unclear? card not loaded? structural gap? broader system issue?
  4. **FIX_PROPOSAL:**
     | proposed_change | why_it_prevents_recurrence | minimal_scope_patch | risks | requires_owner_approval: **YES** |
  5. Operator decides per proposal: "I AM" (apply) / "skip" / "defer"
□ Append incidents to `cards/TASK_CARD_GPS_LINKING.md` INCIDENT LOG
□ Cross-reference recurring incidents with prior runs

□ Present GPS AUDIT OUTPUT:
  ```
  GPS INTEGRITY AUDIT — Run <N>
  GPS Map: PP-<date>  |  Tasks: <count>
  QUICK SCORE:        <passed>/<total> checks
  Card Compliance:    <PASS/FINDINGS>
  Route Correctness:  <PASS/DRIFT>
  Evidence & Safety:  <PASS/FINDINGS>
  Gate Behavior:      <PASS/VIOLATIONS>
  Skips: <count>  Fix Proposals: <count>  Incidents: <count>
  GPS VERDICT: <CLEAN / SKIPS DETECTED / ROUTE DRIFT>
  ```

---

**□ CHECKPOINT 8:** GPS audit done. Verdict recorded.
□ Update STATE.md: `CLOSE_PROGRESS: step 11d of 21 | card: CLOSE_GOVERNANCE | checkpoint: 8`
Proceed to deep scan.

---

### Step 11e: ROTATING DEEP SCAN (exactly one area per closing)

□ Read `cards/SYSTEM_ATLAS_INDEX.md` → DEEP SCAN ROTATION SCHEDULE
□ Determine current position: check last run's `GPS_DEEP` entry in RUN_INDEX
  - If no prior entry or SCAN-008 was last: start SCAN-001 (new cycle)
  - Otherwise: next SCAN-00N in sequence
□ Execute ONE scan area (see schedule for what to check per area):
  - Read the "Key Files" for that scan area
  - Compare against the source of truth (role file, shared module, template)
  - Check: alignment current? refs valid? no orphaned pointers? format correct?
□ Score: DEEP SCAN RESULT = CLEAN / ISSUES (<count>)
□ If ISSUES found:
  - Produce FIX_PROPOSAL per issue (same format as GPS Deep Check)
  - Append to INCIDENT LOG in TASK_CARD_GPS_LINKING.md
  - Operator decides per proposal: "I AM" (apply) / "skip" / "defer"
□ If CLEAN: log `SCAN-00N: CLEAN` (proof of coverage — no action needed)

---

### Step 11f: GPS SCAN LOG (append to RUN_INDEX)

□ Append these 3 lines to this run's RUN_INDEX entry:
  ```
  GPS_QUICK: CLEAN|FAIL (<reason>)
  GPS_DEEP: SCAN-00N CLEAN|ISSUES (<count>)
  COVERAGE: <position>/8 (cycle <cycle_id>)
  ```
□ If this was SCAN-008: note `CYCLE COMPLETE — next run starts new cycle`

---

**□ CHECKPOINT 9:** Deep scan + scan log done.
□ Update STATE.md: `CLOSE_PROGRESS: step 11f of 21 | card: CLOSE_GOVERNANCE | checkpoint: 9`
Ready to close.

---

### Step 12: MERGE
□ `git checkout main && git merge run/<N> --no-ff -m "NEO Run <N>: <summary>"`
□ Only after VERIFY passed AND GPS VERDICT is not ROUTE DRIFT with unresolved blockers

### Step 13: SIGN OFF
□ Present COMPLETION REPORT (pipeline summary, artifacts, hive updates, metrics, GPS audit)
□ Update STATE.md: `CLOSE_PROGRESS: COMPLETE | Status: COMPLETE`

```
🛑 END RESPONSE HERE. Write this as your LAST line:
🔑 RUN COMPLETE
This is the final gate. The run is done. No further output.
```

---

## PRESERVED FILES (NEVER delete/overwrite during CLOSE)
- `.neo/inbox/`, `.neo/outbox/`, `.neo/audit/`, `.neo/archive/`
- `.neo/index/` (append-only), `.neo/STATE.md`, `.neo/RUN_INDEX.md`
- `.neo/TODO_<PROJECT>.md`, `.neo/CRITICAL_SURFACES.md`, `.neo/OPERATOR_MANUAL_<PROJECT>.md`
