# BECCA CLOSE CARD
> Read this card after VERIFY passes. Follow every □ item — 13 main steps + 5 sub-steps + conditional escalation.

## CLOSE PROCEDURE (18 steps + escalation)
> Steps 6b-6d are BECCA's health intelligence — detecting band-aids, measuring improvement velocity, and evaluating pipeline governance.

### Step 1: TODO
□ Mark TODO: **Status:** ✅ COMPLETE + timestamp

### Step 2: ARCHIVE
□ Move `.neo/TODO_<PROJECT>.md` → `.neo/archive/TODO_<PROJECT>_<N>.md`

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

**LESSON REINFORCEMENT (after all indexes updated):**
□ For each task: identify which lessons were injected via HIVE CONTEXT
□ For each injected lesson: Ghost APPROVED first try → increment `Success`; Ghost REJECTED → increment `Failure`
□ If any lesson `Used >= 5` AND `Success/Used < 30%`: flag "⚠️ L-NNN not helping"
□ If any lesson `Used >= 5` AND `Success/Used > 80%`: flag "✅ L-NNN HIGH VALUE"

**REJECTION_INDEX:**
□ For each Ghost REJECTED / CHANGES REQUESTED verdict: assign REJ-NNN, append entry
□ For each Inspector FAIL: same process
□ Track resolution status (FIXED/UNRESOLVED/DEFERRED)

**FINDINGS_INDEX:**
□ For each Ghost/Inspector finding: increment count if type exists, else add new row
□ Update status: RECURRING (seen last 3 runs) / RESOLVED (absent 5+ runs) / IMPROVING

### Step 6: RUN METRICS
□ Calculate and present:
  | Metric | Value |
  |--------|-------|
  | First-pass rate | <N>% (<passed first try>/<total tasks>) |
  | Deficiency density | <N> deficiencies per task |
  | Pheromone delta | <net> (emitted - resolved) |
  | Pheromone trend | GROWING / STABLE / SHRINKING |
  | Quality alerts | <count> or NONE |
  | Avg evidence score | <N>% |

### Step 6b: BAND-AID DETECTION
□ Scan for band-aid patterns using last 5 runs' data from RUN_INDEX + HIVE indexes:

**FILE CHURN:**
□ Cross-reference this run's modified files against FILE_OWNERSHIP index
□ Flag files touched in 3+ of last 5 runs → CHURN SIGNAL
□ "⚠️ <file> touched in runs N, N-1, N-3 — possible instability"

**PHEROMONE OSCILLATION:**
□ Check PHEROMONE_REGISTRY for emit→resolve→re-emit patterns
□ If a pheromone was RESOLVED last run but SIMILAR pheromone emitted this run → OSCILLATION
□ "⚠️ PH-<NNN> resolved Run <N-1> but similar PH-<MMM> emitted this run — fix may be superficial"

**REJECTION RECURRENCE:**
□ Check REJECTION_INDEX for same category rejected 3+ runs in a row
□ "⚠️ <CATEGORY> rejections in runs N, N-1, N-2 — root cause not addressed"

**LESSON REPETITION:**
□ Check LESSONS_INDEX for same topic lessons across 3+ runs
□ "⚠️ Lesson '<topic>' repeated in runs N, N-1, N-3 — system not retaining"

□ Present BAND-AID REPORT:
  ```
  🩹 BAND-AID REPORT — Run <N>

  | Pattern | Type | Details | Runs Affected |
  |---------|------|---------|---------------|
  | <item> | CHURN/OSCILLATION/RECURRENCE/REPETITION | <description> | <run list> |

  BAND-AID SCORE: <count> signals (0=CLEAN, 1-2=WATCH, 3+=CONCERN)
  ```
□ If 0 signals: "✅ No band-aid patterns — fixes appear to be holding"
□ Record BAND-AID SCORE in RUN_INDEX under run entry

### Step 6c: IMPROVEMENT VELOCITY
□ Calculate resolution speed metrics:
  | Velocity Metric | Value |
  |-----------------|-------|
  | Avg pheromone lifespan (this run) | <days from emit to resolve> |
  | Avg pheromone lifespan (all-time) | <days from PHEROMONE_REGISTRY> |
  | Deferred items count | <N items from RUN_INDEX marked DEFERRED> |
  | Oldest deferred item | <M runs old> |
  | Avg runs to resolve recurring finding | <N runs> |
□ If lifespan this run < all-time: "✅ Resolving faster than average"
□ If lifespan this run > all-time × 1.5: "⚠️ Resolution slowing down"
□ If deferred items > 5: "⚠️ Backlog growing — <N> deferred items (oldest: <M> runs)"
□ If any deferred item > 5 runs old: "🔴 Stale deferred item — <item> unresolved for <M> runs"
□ Record velocity metrics in RUN_INDEX under run entry

### Step 6d: PIPELINE EVAL
□ Run 15 pass/fail governance checks (see `templates/PIPELINE_EVAL.md`):
  - EVAL-01: Hive Mind read | EVAL-02: No fabricated evidence | EVAL-03: Gate logs present
  - EVAL-04: Ghost reviewed all | EVAL-05: No scope creep | EVAL-06: Prior work preserved
  - EVAL-07: Pheromones tracked | EVAL-08: Lessons extracted | EVAL-09: NUCLEAR handled
  - EVAL-10: Build passes | EVAL-11: Tests pass | EVAL-12: Self-review completed
  - EVAL-13: Rejection rules documented | EVAL-14: HIVE CONTEXT populated | EVAL-15: Manual current
□ Calculate EVAL SCORE: `passed / (passed + failed) × 100` (N/A excluded)
□ Grade: ≥90%=A, 70-89%=B, 50-69%=C, <50%=D
□ Record EVAL SCORE in RUN_INDEX
□ If EVAL SCORE < 70%: feeds into FRAMEWORK HEALTH ADVISORY (step 11c)

### Step 7: OPERATOR MANUAL UPDATE CHECK
□ Scan Ant reports for FEATURE SIGNALS (new features, changed APIs, new routes)
□ If signals found: dispatch 🌿 Leafcutter to update OPERATOR_MANUAL
□ If none: skip

### Step 8: CROSS-PROJECT HIVEMIND UPDATE
□ Scan pheromones + lessons for cross-project relevance
□ If relevant patterns found: append to `shared/NEO-HIVEMIND-GLOBAL.md`

### Step 9: PROMPT FEEDBACK AGGREGATION
□ Read Section 13 from all Ant reports this run
□ Collect: HELPED / CONFUSED / MISSING / OVERKILL items
□ If 3+ Ants report same issue → PRIORITY FIX

### Step 10: RUN RETROSPECTIVE
□ What went well? What broke? What was slow?
□ Save to RUN_INDEX.md under the run entry

### Step 11: FRAMEWORK HEALTH CHECK
□ Scan 6 signal sources:
  - FINDINGS_INDEX (recurring ≥3), REJECTION_INDEX (common categories)
  - Prompt feedback (CONFUSED/MISSING), Pheromone debt trend
  - Strike 3 escalations, Manual drift
□ If signals found: recommend Prompt Architect activation

### Step 11b: PROTOCOL ADOPTION SCAN
□ For each Ant report this run, scan for card-format artifacts:
  | Signal | Present? |
  |--------|----------|
  | CHECKPOINT PROOF table | YES/NO |
  | HIVE EVIDENCE PROOF (7-row table) | YES/NO |
  | COMMAND PROOF (actual grep output, not "I checked") | YES/NO |
  | BUDGET LEDGER (with numbers) | YES/NO |
  | TRUTHY DIFFS (7/7 listed) | YES/NO |
  | DISCOVERY STRATEGY (ONE QUESTION + answer) | YES/NO |
  | FEATURE INVENTORY (before/after table) | YES/NO |
□ For each Ghost review this run:
  | Signal | Present? |
  |--------|----------|
  | HORSEMEN VERDICT (H1-H5 table) | YES/NO |
  | Full violation scan (V-01 through V-13) | YES/NO |
  | Evidence re-execution (attempted or skip reason) | YES/NO |
  | Scope contraction check | YES/NO |
□ Score:
  PROTOCOL ADOPTION: ___% (signals found / signals expected)
□ If <70%: "⚠️ Protocol adoption low — cards may not be loading. Inject cards explicitly next run."
□ Trend vs last 3 runs: IMPROVING / STABLE / DECLINING / FIRST RUN
□ Record in RUN_INDEX under run entry

### Step 11c: FRAMEWORK FIX ESCALATION (conditional)
□ TRIGGER: Step 11 signals found OR Step 11b adoption <70%
□ If NOT triggered: skip to Step 12

□ Present FRAMEWORK HEALTH ADVISORY to operator:
  ```
  ⚠️ FRAMEWORK HEALTH ADVISORY — Run <N>

  ADOPTION SCORE: ___%  (trend: IMPROVING/STABLE/DECLINING)

  FAILED SIGNALS:
  - <signal 1>: <which reports missing it> — likely cause: <card/section>
  - <signal 2>: ...

  BECCA'S DIAGNOSIS: <what's broken and why>
  BECCA'S FIX SUGGESTION: <specific files + sections to change>

  RECOMMEND: Activate Prompt Architect → "I AM"
  ```

□ WAIT for operator decision:
  - Operator says "I AM" → Prompt Architect activates (BECCA pauses CLOSE)
  - Operator says "skip" → proceed to Step 12

□ ESCALATION FLOW (if activated):
  1. Prompt Architect reads this advisory
  2. Architect independently confirms OR proposes alternative fix
  3. If Architect disagrees with BECCA: presents BOTH options → operator picks
  4. If Architect agrees: tells operator "I AM" to begin implementation
  5. Operator says "I AM" → Architect implements fix in `d:\projects\neo\`
  6. Operator says "I AM" → Prompt Evolution Inspector validates the fix
  7. Operator says "I AM" → BECCA reactivates → re-runs Step 11b ONLY
  8. If adoption improved: proceed to Step 12
  9. If adoption still <70%: STOP — "Fix did not improve adoption. Manual investigation needed."
     Do NOT loop again. One fix attempt per run.

### Step 12: MERGE
□ `git checkout main && git merge run/<N> --no-ff -m "NEO Run <N>: <summary>"`
□ Only after VERIFY passed

### Step 13: SIGN OFF
□ Present COMPLETION REPORT (pipeline summary, artifacts, hive updates, metrics)
□ State: `🔑 RUN COMPLETE`

## PRESERVED FILES (NEVER delete/overwrite during CLOSE)
- `.neo/inbox/` — task packets
- `.neo/outbox/` — all reports
- `.neo/audit/` — evidence + gate logs
- `.neo/archive/` — completed TODOs
- `.neo/index/` — hive mind (append-only)
- `.neo/STATE.md` — (update, never delete)
- `.neo/RUN_INDEX.md` — (append, never delete)
- `.neo/TODO_<PROJECT>.md` — (archive, never delete)
- `.neo/CRITICAL_SURFACES.md`
- `.neo/OPERATOR_MANUAL_<PROJECT>.md`
