# BECCA CLOSE — ARCHIVE CARD
**CARD_ID:** BECCA-CLOSE-ARCHIVE | **Phase:** CLOSE (1 of 4) | **Role:** BECCA
**INPUTS:** BECCA-VERIFY result, all run reports, TODO, STATE.md, RUN_INDEX.md, HIVE indexes
> After VERIFY passes, load this card FIRST. Steps 1-5: record the run, update all indexes.
> Cognitive mode: mechanical data writes. Follow the contract exactly.

---

### CLOSE STATE TRACKING (crash-proof progress marker)
□ At each CHECKPOINT below, update `.neo/STATE.md` with:
  ```
  CLOSE_PROGRESS: step <N> of 21 | card: CLOSE_ARCHIVE | checkpoint: <N>
  CLOSE_TIMESTAMP: <YYYY-MM-DD HH:MM>
  ```
□ On crash/restart: read STATE.md → resume from recorded step (do NOT restart from step 1)

---

### Step 1: TODO
□ Mark TODO: **Status:** ✅ COMPLETE + timestamp

### Step 2: ARCHIVE
□ Move `.neo/TODO_<PROJECT>.md` → `.neo/archive/TODO_<PROJECT>_<N>.md`

### Step 2b: INBOX ARCHIVE
□ Check `.neo/inbox/ideas/` for documents (exclude README.md)
□ If documents found:
  - Create `.neo/inbox/ideas/completed/run-<NNN>/` (if not exists)
  - Move each document → `.neo/inbox/ideas/completed/run-<NNN>/<filename>`
  - Log: "📬→📁 Archived <N> inbox document(s) to completed/run-<NNN>/"
□ If no documents: skip (nothing to archive)

### Step 3: STATE
□ Update `.neo/STATE.md`:
  - Last Run: <N>
  - Last Task ID: TASK-<highest>
  - Last Pheromone ID: PH-<highest>
  - Last Lesson ID: L-<highest>
  - Last Rejection ID: REJ-<highest>
  - Status: COMPLETE

### Step 4: RUN INDEX
□ Append entry to `.neo/RUN_INDEX.md` (run number, date, task count, summary)
□ Update QUICK STATS (total runs, total tasks)

---

**□ CHECKPOINT 1:** Steps 1-4 done? TODO archived, STATE updated, RUN_INDEX appended?
□ Update STATE.md: `CLOSE_PROGRESS: step 4 of 21 | card: CLOSE_ARCHIVE | checkpoint: 1`
Confirm before proceeding to index writes.

---

### Step 5: HIVE INDEX WRITES (6 indexes — append-only)

**MASTER_INDEX:**
□ For each completed task: append 1 line (9 pipe-delimited fields)
□ If shard ≥500 entries: create new shard
□ Compute fingerprint (SHA256 first 8 chars) — check for duplicates

**FILE_OWNERSHIP:**
□ For each file in each task: append row to appropriate shard
□ Create new shards on demand (first two directory segments)

**PHEROMONE_REGISTRY:**
□ For each emitted pheromone: append row with Status = ACTIVE
□ For each resolved pheromone: update Status to RESOLVED_TASK-NNN

**LESSONS_INDEX:**
□ Read Ant Report Section 8 (Lessons for Future Ants)
□ For each substantive lesson: assign L-NNN ID, classify category, append to domain shard
□ Initialize Usage Stats: `Used: 0 | Success: 0 | Failure: 0`

**LESSON REINFORCEMENT RECONCILIATION (mid-pipeline reinforcement already applied during HANDOFF):**
□ For each task: check TODO for "LESSON_REINFORCEMENT: DONE" marker
□ Tasks WITH marker: already reinforced mid-pipeline — verify (read-only, no double-counting)
□ Tasks WITHOUT marker (crash recovery — session ended between Ghost verdict and next Ant dispatch):
  - Read task packet INJECTED_LESSON_IDS
  - Ghost APPROVED first try (loop count = 0) → increment `Success` for each injected L-NNN
  - Ghost REJECTED/retried (loop count > 0) → increment `Failure` for each injected L-NNN
  - Mark "LESSON_REINFORCEMENT: DONE" in TODO
□ Run anomaly scan: `Used >= 5` AND `Success/Used < 30%` → flag "L-NNN not helping"
□ Run anomaly scan: `Used >= 5` AND `Success/Used > 80%` → flag "L-NNN HIGH VALUE"

**REJECTION_INDEX:**
□ For each Ghost REJECTED / CHANGES REQUESTED verdict: assign REJ-NNN, append entry
□ For each Inspector FAIL: same process
□ Track resolution status (FIXED/UNRESOLVED/DEFERRED)

**FINDINGS_INDEX:**
□ For each Ghost/Inspector finding: increment count if type exists, else add new row
□ Update status: RECURRING (seen last 3 runs) / RESOLVED (absent 5+ runs) / IMPROVING

---

**□ CHECKPOINT 2:** All 6 indexes updated?
□ Update STATE.md: `CLOSE_PROGRESS: step 5 of 21 | card: CLOSE_ARCHIVE | checkpoint: 2`
Present HIVE INDEX UPDATE summary:
```
HIVE INDEX UPDATE — Run <N>
MASTER:     +<N> entries (shard: <name>)
FILES:      +<N> entries
PHEROMONES: +<emitted> emitted, <resolved> resolved
LESSONS:    +<N> extracted, reinforcement: <high_value> HIGH / <not_helping> LOW
REJECTIONS: +<N> indexed
FINDINGS:   +<new> new, <incremented> incremented, <resolved> resolved
```

---

### Step 6: CLOSE RECEIPT (MANDATORY — produces proof that CLOSE ran)
□ Load template: `.neo/templates/CLOSE_RECEIPT.md`
□ Fill ARCHIVE PROOFS table from steps 1-5 results
□ Fill ADOPTION SCOREBOARD from TODO + STATE.md + HIVE indexes
  - First-pass rate: count tasks where Ghost approved on 1st submission / total tasks
  - Regression locks: count fix tasks with lock proof / total fix tasks
□ Set CLOSE DEPTH: CLOSE_ARCHIVE = YES, remaining cards = pending
□ Set RUN STATE: **CLOSED** (this receipt exists = run is closed)
□ Write to: `.neo/outbox/close/CLOSE_RECEIPT_RUN_<N>.md`

> **Binary rule:** This receipt is the ONLY artifact that proves CLOSE happened.
> Even if ANALYTICS/DEVTOOLS/GOVERNANCE are skipped (session crash, operator skip),
> the run is CLOSED because this receipt exists.

---

**□ CHECKPOINT 3:** CLOSE_RECEIPT written to `.neo/outbox/close/`?
□ Update STATE.md: `CLOSE_PROGRESS: step 6 of 21 | card: CLOSE_ARCHIVE | checkpoint: 3`

---

## NEXT

```
🛑 END RESPONSE HERE. Write this as your LAST line:
⏸️ ARCHIVE complete. CLOSE_RECEIPT written. Loading ANALYTICS.
Do NOT skip ahead. Do NOT produce a COMPLETION REPORT yet.
The operator says "continue" → you load BECCA_CLOSE_ANALYTICS card.
```
