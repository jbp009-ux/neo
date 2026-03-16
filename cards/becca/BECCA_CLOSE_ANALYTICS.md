# BECCA CLOSE — ANALYTICS CARD
**CARD_ID:** BECCA-CLOSE-ANALYTICS | **Phase:** CLOSE (2 of 4) | **Role:** BECCA
**INPUTS:** CLOSE-ARCHIVE outputs (HIVE INDEX UPDATE summary), all run reports, RUN_INDEX (updated), HIVE indexes (updated)
> After ARCHIVE card completes, load this card. Steps 6-10: assess the run's health.
> Cognitive mode: analytical cross-referencing. Compute metrics, detect patterns, generate assessments.
> **CLOSE STATE:** Continue updating STATE.md at each checkpoint (see CLOSE_ARCHIVE card for format).
> **SHOW YOUR WORK:** For all calculations (metrics, scores, percentages), list each input value before computing. No formula without listed inputs.

---

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

---

**□ CHECKPOINT 3:** Metrics table complete?
□ Update STATE.md: `CLOSE_PROGRESS: step 6 of 21 | card: CLOSE_ANALYTICS | checkpoint: 3`
Present to operator before health scans.

---

### Step 6b: BAND-AID DETECTION
□ Scan 4 patterns using last 5 runs' data from RUN_INDEX + HIVE indexes:

**FILE CHURN:**
□ Cross-reference this run's modified files against FILE_OWNERSHIP index
□ Flag files touched in 3+ of last 5 runs → CHURN SIGNAL
  *Concrete: same file path appears in MASTER_INDEX for 3+ of last 5 run numbers*

**PHEROMONE OSCILLATION:**
□ Check PHEROMONE_REGISTRY for emit→resolve→re-emit patterns
□ Flag: same category + same subsystem resolved last run but re-emitted this run
  *Concrete: PH with matching `category` AND overlapping `files` field within 2 runs*

**REJECTION RECURRENCE:**
□ Check REJECTION_INDEX for same category rejected 3+ consecutive runs
  *Concrete: REJ entries with identical `category` value in runs N, N-1, N-2*

**LESSON REPETITION:**
□ Check LESSONS_INDEX for same lesson recurring across 3+ runs
  *Concrete: same L-NNN ID or same file pattern (first 2 path segments) in 3+ runs*

□ Present BAND-AID REPORT:
  ```
  BAND-AID REPORT — Run <N>
  | Pattern | Type | Details | Runs Affected |
  |---------|------|---------|---------------|
  | <item> | CHURN/OSCILLATION/RECURRENCE/REPETITION | <description> | <run list> |
  BAND-AID SCORE: <count> signals (0=CLEAN, 1-2=WATCH, 3+=CONCERN)
  ```
□ If 0 signals: "No band-aid patterns — fixes appear to be holding"
□ Record BAND-AID SCORE in RUN_INDEX

### Step 6c: IMPROVEMENT VELOCITY
□ Calculate resolution speed metrics:
  | Velocity Metric | Value |
  |-----------------|-------|
  | Avg pheromone lifespan (this run) | <days from emit to resolve> |
  | Avg pheromone lifespan (all-time) | <days from PHEROMONE_REGISTRY> |
  | Deferred items count | <N items from RUN_INDEX marked DEFERRED> |
  | Oldest deferred item | <M runs old> |
  | Avg runs to resolve recurring finding | <N runs> |
□ If lifespan this run < all-time: "Resolving faster than average"
□ If lifespan this run > all-time x 1.5: "Resolution slowing down"
□ If deferred items > 5: "Backlog growing"
□ If any deferred item > 5 runs old: "Stale deferred item"
□ Record velocity metrics in RUN_INDEX

---

**□ CHECKPOINT 4:** Band-aid + velocity done?
□ Update STATE.md: `CLOSE_PROGRESS: step 6c of 21 | card: CLOSE_ANALYTICS | checkpoint: 4`
Present health intelligence results before eval.

---

### Step 6d: PIPELINE EVAL
□ Run 19 pass/fail governance checks (see `templates/PIPELINE_EVAL.md`):
  - EVAL-01 through EVAL-15: Hive Mind, evidence, gates, scope, pheromones, lessons, NUCLEAR, build, tests, self-review, rejections, HIVE CONTEXT, manual
  - EVAL-16: CARD_RECEIPT present | EVAL-17: Policy Pack current | EVAL-18: CORE cards accounted | EVAL-19: Ghost card compliance
□ Calculate EVAL SCORE: `passed / (passed + failed) x 100` (N/A excluded)
□ Grade: >=90%=A, 70-89%=B, 50-69%=C, <50%=D
□ Record EVAL SCORE in RUN_INDEX
□ If EVAL SCORE < 70%: feeds into FRAMEWORK HEALTH ADVISORY (step 11c)

---

**□ CHECKPOINT 5:** EVAL scored and graded?
□ Update STATE.md: `CLOSE_PROGRESS: step 6d of 21 | card: CLOSE_ANALYTICS | checkpoint: 5`
Present EVAL SCORE before operational checks.

---

### Step 7: OPERATOR MANUAL UPDATE CHECK
□ Scan Ant reports for FEATURE SIGNALS:
  *Concrete: new files in src/, changed function exports, new API routes, changed DB schemas, new environment variables*
□ If signals found: dispatch Leafcutter to update OPERATOR_MANUAL
□ If none: skip — "No new features detected"

### Step 8: CROSS-PROJECT HIVEMIND UPDATE
□ Scan pheromones + lessons for cross-project relevance:
  *Concrete: pheromone affects a shared module (shared/*.md) OR same bug category exists in another governed project's PHEROMONE_REGISTRY*
□ If relevant patterns found: append to `shared/NEO-HIVEMIND-GLOBAL.md`

### Step 9: PROMPT FEEDBACK AGGREGATION
□ Read Section 13 from all Ant reports this run
□ Collect: HELPED / CONFUSED / MISSING / OVERKILL items
□ If 3+ Ants report same issue → PRIORITY FIX

### Step 10: RUN RETROSPECTIVE
□ What went well? What broke? What was slow?
□ Save to RUN_INDEX.md under the run entry

---

**□ CHECKPOINT 6:** All analytics done?
□ Update STATE.md: `CLOSE_PROGRESS: step 10 of 21 | card: CLOSE_ANALYTICS | checkpoint: 6`
Present combined summary to operator:
```
ANALYTICS SUMMARY — Run <N>
Metrics:     First-pass <N>%, Deficiency <N>/task, Pheromone delta <net>
Band-aids:   <score> signals (<CLEAN/WATCH/CONCERN>)
Velocity:    <IMPROVING/SLOWING/STALLING>
EVAL SCORE:  <N>% (Grade <A/B/C/D>)
Signals:     <count> health signals from steps 7-10
```

## NEXT

```
🛑 END RESPONSE HERE. Write this as your LAST line:
⏸️ ANALYTICS complete. Loading DEVTOOLS.
Do NOT skip ahead. Do NOT produce a COMPLETION REPORT yet.
The operator says "continue" → you load BECCA_CLOSE_DEVTOOLS card.
After DEVTOOLS → load BECCA_CLOSE_GOVERNANCE card.
```
