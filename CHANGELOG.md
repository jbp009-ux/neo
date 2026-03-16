# NEO Pipeline Governance Framework — Consolidated Changelog

All version history extracted from role and shared module files.
Use `git log` for commit-level history.

---

## NEO-BECCA
**Source:** `roles/NEO-BECCA.md`


### [1.23.0] 2026-02-27
- **DEVTOOLS ANT PROGRAM — Hard Gate in Closeout**
- New CLOSE step 10.5: DEVTOOLS VERIFICATION — mandatory browser inspection before GOVERNANCE
- 3 new DevTools Ant types (17-19): Sentinel (Chief, every closeout), Perf (triggered), Network (triggered)
- Change-based trigger table: 6 patterns (checkout, auth, shared, pheromone, routes, menu)
- Symptom-based trigger table: 4 patterns (console, network, duplicates, perf regression)
- BECCA_CLOSE_DEVTOOLS card: 4-step flow (Trigger Assessment → Dispatch Chief → Dispatch Specialists → Verdict)
- CLOSE card chain: ARCHIVE → ANALYTICS → DEVTOOLS → GOVERNANCE (was 3 cards, now 4)
- 3 new STATE.md fields: DEVTOOLS_CHIEF, DEVTOOLS_ESCALATED, DEVTOOLS_EVIDENCE
- Crash recovery: resume from DEVTOOLS_CHIEF state on restart
- 3 gate tokens: 🔑 DEVTOOLS_CHIEF COMPLETE, 🔑 DEVTOOLS_SPECIALISTS COMPLETE, 🔑 DEVTOOLS VERIFICATION APPROVED
- FAIL_BLOCKING stops merge; operator can override with justification recorded in RUN_INDEX
- Quick Cards updated: +CLOSE_DEVTOOLS in sequence

### [1.22.0] 2026-02-27
- **GPS INTEGRITY HARDENING — Anti-Hollow Execution + Crash-Proof CLOSE + Self-Scan**
- SCAN-003 expanded: BECCA self-scan — monolith (NEO-BECCA.md) included in deep scan rotation
  - 4 acceptance criteria: Anchor Integrity (SS-1), Decision Criteria Inline (SS-2),
    Compound Instruction Detection (SS-3), Monolith Growth Check (SS-4)
- GPS QUICK CHECK: evidence-cited format replaces bare YES/NO
  - Format: `YES (evidence: <path>:<section>)` or `NO (evidence: <path>:<what's missing>)`
  - HARD RULE: uncited YES/NO = INVALID_CHECK = treated as NO
  - Applied to all 8 Quick Check items + CARD COMPLIANCE CHECK in monolith
- Ghost VERDICT card: +Section 2b EVIDENCE-CITATION RULE
  - Ghost MUST flag uncited GPS Quick Check claims as INVALID_CHECK findings
  - CARD_RECEIPT missing added to auto-reject conditions
- CLOSE STATE TRACKING: crash-proof progress marker in STATE.md
  - `CLOSE_PROGRESS: step <N> of 21 | card: <name> | checkpoint: <N>`
  - Updated at every checkpoint (9 total across 3 CLOSE cards)
  - On crash/restart: read STATE.md → resume from recorded step
  - On completion: `CLOSE_PROGRESS: COMPLETE`
- SHOW YOUR WORK RULE: anti-hallucination for all calculations
  - "List each input value, then compute. No formula without listed inputs."
  - Applied to ANALYTICS card header + CLOSE monolith section
- Decision criteria restated inline at CHECKPOINT 7: "the threshold is 70%"
- Origin: Advisor directive — GPS Integrity Hardening (surgical patch for AI execution reliability)
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.21.0] 2026-02-27
- **SYSTEM ATLAS + ROTATING DEEP SCAN + SCAN LOGGING**
- SYSTEM_ATLAS_INDEX.md: pointer-only TOC designating 5 canonical Atlas sources of truth
  (GPS Map, Gates Reference, Hive Contracts, Closure Procedure, Mission Log)
  — no rules or contracts duplicated, just links
- CLOSE step 11e: ROTATING DEEP SCAN — exactly one scan area per closing
  - 8 scan areas cover full system: Ant cards, Ghost+Inspector cards, BECCA cards,
    shared modules, PIPELINE EVAL, pheromone system, templates, GATES reference
  - Over 8 closings: 100% system coverage without overloading any single run
  - Issues → FIX_PROPOSAL (owner approval required), clean → logged for proof
  - Cycle management: SCAN-008 completes → archive cycle → restart SCAN-001
- CLOSE step 11f: GPS SCAN LOG — 3-line entry appended to RUN_INDEX every run
  - GPS_QUICK: CLEAN|FAIL, GPS_DEEP: SCAN-00N CLEAN|ISSUES, COVERAGE: N/8 (cycle_id)
  - Proves every run was audited; enables staleness detection across cycles
- CLOSE step count: 19 → 21 steps + conditional escalation
- BECCA_CLOSE_GOVERNANCE card: +step 11e, +step 11f, +CHECKPOINT 9, steps 12-13 renumbered
- Quick Reference: +11e (rotating deep scan), +11f (scan log), GPS audit updated
- Fix proposals: all 3 locations (GPS Deep Check, Deep Scan, monolith) enforce owner approval
- Origin: System Atlas PDF — proof of coverage + incremental deepening without redundancy
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.20.0] 2026-02-27
- **PROMPT POLISH — Reliable AI Execution for SaaS at Scale**
- BECCA_CLOSE split into 3 focused cards (was 1 card, 289 lines, 100 checkboxes):
  - BECCA_CLOSE_ARCHIVE (Steps 1-5, ~87 lines): mechanical data writes
  - BECCA_CLOSE_ANALYTICS (Steps 6-10, ~129 lines): analytical assessment
  - BECCA_CLOSE_GOVERNANCE (Steps 11-13, ~130 lines): governance decisions + GPS audit
- Handoff chain: VERIFY → CLOSE_ARCHIVE → CLOSE_ANALYTICS → CLOSE_GOVERNANCE → RUN COMPLETE
- 8 CHECKPOINT gates across all 3 cards (every ~12-15 items) to prevent AI attention drift
- GPS INTEGRITY AUDIT redesigned: QUICK CHECK (8 YES/NO items, always) → DEEP CHECK (only on failures)
  - Quick Check at 100% → GPS VERDICT: CLEAN → skip to MERGE (fast path)
  - Quick Check < 100% → Deep Check per failure only (focused, not exhaustive)
- FULL-PROMPT-READ replaced with GPS-TARGETED READ:
  - Step 1: CARD_GPS_MAP.md → find exact line range for skipped card
  - Step 2: Read ONLY that section (50-80 lines, not 1,500+)
  - Step 3: If needed → read card file. Never load full role file.
- SaaS MISSION CONTEXT added to identity box:
  "This pipeline governs SaaS systems for 100K+ clients.
   Every skipped step is a production issue affecting real users."
- Quick Reference: +SaaS context line, +3-card CLOSE reference, version bump
- Vague scan instructions concretized in ANALYTICS card:
  - Pheromone oscillation: "same category + same subsystem within 2 runs"
  - Lesson repetition: "same L-NNN ID or same file pattern in 3+ runs"
  - Feature signals: "new files in src/, changed exports, new API routes, changed schemas"
  - Cross-project relevance: "pheromone affects shared module OR same bug category across projects"
- Origin: AI execution audit — BECCA_CLOSE had ~35-40% predicted clean completion rate. Card split + checkpoints + focused scanning fix this.

### [1.19.0] 2026-02-27
- **GPS INTEGRITY AUDIT & SELF-HEALING** — end-of-run GPS-based audit with skip detection and fix proposals
- CLOSE step 11d: GPS INTEGRITY AUDIT — audits all task artifacts against CARD_GPS_MAP.md routes
  - 4-category check: Card Compliance, Route Correctness, Evidence & Safety, Gate Behavior
  - SKIP_DETECTION: structured block per skip (who, what_skipped, where_detected, evidence, severity, impact)
  - FULL-PROMPT-READ DIAGNOSIS: when a skip is detected, BECCA reads the ENTIRE role prompt of the failing role
    before diagnosing — not just the relevant section, the FULL prompt for complete context understanding
  - System expansion: if broader context needed, BECCA reads shared modules, other role prompts, templates
  - FIX_PROPOSAL: structured format (proposed_change, why_it_prevents_recurrence, minimal_scope_patch, risks, requires_owner_approval: YES)
  - HARD RULE: BECCA suggests, BECCA does NOT apply — every fix requires operator "I AM"
  - INCIDENT LOG: skips and drift appended to cards/TASK_CARD_GPS_LINKING.md for cross-run tracking
  - Recurring incident detection: cross-references with prior runs' incidents
- CLOSEOUT_AUDIT block: mandatory GPS audit header in COMPLETION REPORT (run_id, policy_pack_id, deck_id, gps_map_version, gps_verdict)
- RULE 0: "Before diagnosing any skip, BECCA MUST first understand what already exists" — inventory before enforcement
- GPS AUDIT OUTPUT: summary block with per-category results and GPS VERDICT (CLEAN / SKIPS DETECTED / ROUTE DRIFT)
- CLOSE step count: 18 → 19 steps + conditional escalation
- FRAMEWORK FIX ESCALATION flow updated: "skip to MERGE" → "skip to GPS INTEGRITY AUDIT"
- Origin: SELFHEALING.pdf — end-of-run GPS self-healing protocol
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.18.0] 2026-02-25
- **DATA FLYWHEEL & RLHF-STYLE REINFORCEMENT** — every run makes the next run smarter
- HANDOFF: Task Packet Enrichment step added — BECCA populates HIVE CONTEXT before dispatching every Ant
- HIVE CONTEXT ENRICHMENT: 4-step protocol — file history, active pheromones, top lessons (scored), rejection patterns
- LESSON SCORING FUNCTION: Weighted algorithm for selecting Top 3 lessons per task packet
  - FILE OVERLAP +8, ANT TYPE MATCH +5, GOTCHA/FRAGILE +4, DOMAIN MATCH +3, RECENCY +2/+1, REJECTION PATTERN +2
  - HIT RATE ADJUSTMENT: proven lessons +3 (>80% success), failing lessons -5 (<30% success)
  - Example scoring provided with concrete numbers
- LESSON REINFORCEMENT: CLOSE step 4b — updates Usage Stats (Used/Success/Failure) on injected lessons
  - Success = Ghost approved first try, Failure = Ghost rejected
  - Anomaly detection: HIGH VALUE (>80% hit rate), NOT HELPING (<30% hit rate)
- REJECTION_INDEX enrichment: Rule Triggered (S-NN/V-NN) and Stage fields added to CLOSE step 5
- HIVE INDEX UPDATE output expanded: +lesson reinforcement, +high/low value lessons, +top rejection rules/stages
- PIPELINE EVAL: CLOSE step 6d — 19 pass/fail governance checks (templates/PIPELINE_EVAL.md)
  - EVAL-01 through EVAL-19 covering hive mind, evidence, gates, scope, pheromones, lessons, NUCLEAR, build, tests, self-review, rejections, HIVE CONTEXT, manual, card receipts, policy pack, CORE cards, Ghost card compliance
  - EVAL SCORE recorded in RUN_INDEX, Grade A/B/C/D
  - EVAL SCORE <70% feeds into FRAMEWORK HEALTH ADVISORY (step 11c)
- CLOSE step enumeration updated: 6d added (PIPELINE EVAL)
- Origin: Advisor spec — AI company techniques (data flywheel, RLHF reinforcement, constitutional self-review, pipeline evals)
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.17.0] 2026-02-25
- **HEALTH INTELLIGENCE SYSTEM** — BECCA is now the "eyes and ears" of the pipeline
- Identity updated: "I am the eyes and ears of the pipeline" — health monitoring added to core mission
- DOES section: +5 new health monitoring responsibilities (trends, verification, vitals, band-aids, velocity)
- RECON step 3g: HEALTH TREND DASHBOARD — compare last 3-5 runs' key metrics (first-pass, deficiency, debt, band-aids, rejections)
  - Flags declining trends (2+ consecutive runs worse): quality DOWN, deficiencies UP, chronic debt, band-aids rising
- RECON step 3h: IMPROVEMENT VERIFICATION — did prior run's retro/health suggestions get acted on?
  - FOLLOW-THROUGH SCORE: addressed / total actions = %
  - Flags DEFERRED 2+ runs (stale), IGNORED (no action taken)
- RECON output: SYSTEM VITALS summary — instant health pulse at a glance
  - HEALTHY (all stable + follow-through >80%) / WATCH (1 declining) / CONCERN (2+ declining) / CRITICAL (chronic debt or low quality)
- CLOSE step 6c: BAND-AID DETECTION — 4 pattern scan to catch superficial fixes
  - FILE CHURN: same files touched in 3+ of last 5 runs → instability signal
  - PHEROMONE OSCILLATION: resolve→re-emit same category → symptom-only fix
  - REJECTION RECURRENCE: same rejection category 3+ consecutive runs → root cause missed
  - LESSON REPETITION: same lesson topic 3+ runs → knowledge not transferring
  - BAND-AID SCORE: 0=CLEAN, 1-2=WATCH, 3+=CONCERN
- CLOSE step 6d: IMPROVEMENT VELOCITY — resolution speed + backlog tracking
  - Pheromone lifespan (this run vs all-time), deferred item aging, recurring finding resolution
  - Velocity assessment: IMPROVING / SLOWING / STALLING
  - Flags: deferred >5 items, any item >5 runs old
- CLOSE step 11b: PROTOCOL ADOPTION SCAN (synced from BECCA_CLOSE card)
  - 7 Ant signals + 4 Ghost signals scanned per report
  - Adoption score: signals found / expected = % (≥90% strong, 70-89% moderate, <70% low)
  - Trend vs last 3 runs + record in RUN_INDEX
- CLOSE step 11c: FRAMEWORK FIX ESCALATION (synced from BECCA_CLOSE card)
  - Trigger: Step 11 signals OR Step 11b adoption <70%
  - BECCA presents diagnosis + fix suggestion to operator
  - 9-step escalation flow: Architect → Inspector → BECCA re-scan
  - 4 operator "I AM" gates, Architect can disagree, ONE attempt per run
- RUN COMPLETION REPORT: added HEALTH INTELLIGENCE section (band-aid score, velocity, adoption, vitals)
- Quick Reference: complete rewrite — added health trend, improvement verification, system vitals, band-aid detection, velocity, protocol adoption, escalation flow
- Origin: Operator requirement — "BECCA should be my eyes and ears, not just band-aids"
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.16.0] 2026-02-25
- STRIKE 3 ESCALATION PROTOCOL: new section between HANDOFF and DEBUGGER DISPATCH
- When Ant rejected 3 times → BECCA reactivates to analyze the rejection pattern
- 3 possible decisions: DEBUGGER (diagnosis needed), SPLIT (scope too large), RE-ASSIGN (wrong Ant type)
- BECCA reads all Ghost reviews to determine if deficiencies are same/different/scope/type issues
- Escalation output block with pattern analysis + decision + reason
- BECCA reactivation triggers: added "Strike 3 escalation" as 4th trigger
- Quick Reference: added STRIKE 3 ESCALATION block (7 lines)
- Origin: Ants looped indefinitely on same bug — no diagnostic escalation path existed

### [1.15.0] 2026-02-25
- DEBUGGER DISPATCH PROTOCOL: new section between HANDOFF and VERIFY
- Pre-flight checks: dev server running, Chrome DevTools/Playwright/Sentry/Firebase MCP availability
- Task packet enrichment: bug description, reproduction context, error messages, affected URL, MCP status
- Pipeline difference: Debugger → Ghost (no Inspector for diagnose-only), output is TEST_REPORT not ANT_REPORT
- DEBUGGER → FIX ANT HANDOFF: new section for post-diagnosis task generation
- Reads TEST_REPORT Sections 2/3/7/8/9, auto-generates fix task packet with diagnosis context
- Fix Ant MUST read TEST_REPORT (mandatory input, DO NOT re-investigate)
- Ghost reviews fix Ant against TEST_REPORT reproduction steps
- LOW confidence diagnosis → operator warning before fix dispatch
- VERIFY EXPANDED: task classification (builder/debugger/QA), regression check skips non-code tasks
- Debugger tasks: ✅ across TWO stages (Debugger + Ghost), Inspector optional
- DEBUGGER RESOLUTION CHECK: verifies fix task was dispatched and completed for each diagnosis
- Unresolved diagnoses flagged: "diagnosed but no fix dispatched — intentional?"
- VERIFY output expanded: separate counts for builder/debugger/QA tasks + debugger resolutions
- RUN COMPLETION REPORT: separate counts for ANT_REPORT, TEST_REPORT, QA_REPORT artifacts
- Pipeline summary: builder/debugger/QA task counts + debugger handoff count
- DOES section fixed: "3 indexes" → "all 6 indexes" (MASTER, FILE, PHEROMONE, LESSONS, REJECTION, FINDINGS)
- FRAMEWORK HEALTH CHECK: expanded Prompt Architect reference with full Architect → Inspector flow
- Added prompts/PROMPT_EVOLUTION_INSPECTOR.md to the recommendation chain
- Quick Reference updated: HANDOFF (debugger dispatch + handoff blocks), VERIFY (task classification), CLOSE (separate report counts, framework health flow)
- Cross-reference: NEO-TOOLS.md v1.9.0 Section 4 (Debugger Lab), NEO-OUTPUTS.md v1.10.0 Section 7 (TEST_REPORT 11 sections)
- Origin: BECCA had zero Debugger-awareness — dispatched blind, no handoff protocol, VERIFY checked for nonexistent code changes
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.14.0] 2026-02-25
- REJECTION_INDEX: BECCA writes Ghost/Inspector rejections to .neo/index/REJECTION_INDEX.md during CLOSE
- FINDINGS_INDEX: BECCA aggregates Ghost/Inspector findings to .neo/index/FINDINGS_INDEX.md during CLOSE
- HIVE INDEX UPDATE: expanded from 4 to 6 indexes (added steps 5 + 6 for REJECTION + FINDINGS)
- INIT: seeds REJECTION_INDEX.md and FINDINGS_INDEX.md on first run
- STATE.md: now tracks Last Rejection ID (REJ-NNN)
- RECON Index Health Check: now counts rejections, recurring findings, generates PHEROMONE TRIAGE
- PHEROMONE TRIAGE: priority-sorted active pheromones (🔴 URGENT / 🟡 MODERATE / 🟢 LOW) + debt trend
- If RECURRING findings count >= 5: flagged as PRIORITY FRAMEWORK SIGNAL in RECON
- RECON output: 3 new lines — rejections, recurring findings, pheromone triage status
- RUN_METRICS: new CLOSE step 6b — structured per-run quality metrics
- Metrics: first-pass rate, deficiency density, rejection breakdown, pheromone delta, hive growth
- Trend comparison vs prior run with direction arrows (↑/↓/→)
- Quality alerts: low first-pass (<50%), high deficiency (>3.0), pheromone spike (>+5), zero lessons
- FRAMEWORK HEALTH CHECK: expanded from 5 to 6 signal sources (added FINDINGS_INDEX priority signals)
- FINDINGS_INDEX count >= 5 = 🔴 HIGH severity framework signal
- RUN COMPLETION REPORT: added Rejections, Findings, RUN METRICS section
- Quick Reference: updated RECON + CLOSE with all new features
- File paths tree: added REJECTION_INDEX.md and FINDINGS_INDEX.md
- Origin: deep audit identified rejection patterns and recurring findings as blind spots
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.13.0] 2026-02-25
- FRAMEWORK HEALTH CHECK: new CLOSE step 11 — scans 5 signal sources for framework improvement needs
- 5 sources: Prompt Feedback priority fixes, Ghost rejection patterns, Inspector findings, PROTOCOL-category lessons, Retro framework items
- Signal severity: 🔴 HIGH (priority fix or 2+ Ghost rejections), 🟠 MEDIUM (Inspector or 3+ PROTOCOL lessons), 🟡 LOW (single retro item)
- If signals detected: presents FRAMEWORK HEALTH ADVISORY with signal table and affected files
- Recommends Prompt Architect activation (separate session, not during run)
- If no signals: "Ecosystem healthy" — continues to MERGE
- CLOSE steps renumbered: FRAMEWORK HEALTH CHECK = step 11, MERGE = step 12, Sign off = step 13
- RUN COMPLETION REPORT: "Framework Health" section added (signal count + Architect recommendation)
- Fixed: Leafcutter pipeline reference (was "step 8 Prompt Feedback", now "step 8 Cross-Project Hivemind")
- Fixed: Prompt Feedback section header (was "step 8", now "step 9")
- Framework files are NEVER auto-modified during a project run — advisory only
- Origin: Colony OS Prompt Architect integration — BECCA detects, operator decides, Architect executes
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.12.0] 2026-02-25
- TODO STATE VERIFICATION: new RECON step 4a — verify TODO run number matches STATE.md before Scout dispatch
- If TODO RUN > STATE Last Run: 🛑 STATE MISMATCH — previous run did not CLOSE properly (S-32)
- Prevents Run N+1 TODO from silently overwriting Run N TODO without archival
- MANUAL DRIFT ESCALATION: RECON step 3e enhanced — >=10 runs stale = 🛑 CRITICAL (mandatory dispatch)
- >=5 runs = ⚠️ recommended (unchanged), >=10 runs = NON-NEGOTIABLE dispatch before CLOSE
- GIT FRESHNESS CHECK: new SCOUT step 0 — verify git status is CLEAN before Scout surveys
- If uncommitted changes: ⚠️ present to operator with options (commit/stash or proceed with stale notice)
- Scout must log git status result in DISCOVERY output (CLEAN or STALE with file count)
- RECON output: manual drift now shows CRITICAL level for 10+ runs
- Origin: Ghost findings — Run 113 TODO overwritten by 114 without CLOSE, TASK-381 no-op from stale git
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.11.0] 2026-02-25
- LESSONS_INDEX EXTRACTION: BECCA extracts lessons from Ant Report Section 8 during CLOSE
- HIVE INDEX UPDATE step 4 added: read lessons, determine domain shard, assign L-NNN IDs, append entries
- 6 lesson categories: WHAT_WORKED, GOTCHA, FRAGILE, APPROACH, VERIFICATION, PROTOCOL
- Domain sharding: auth, payments, voice, data, ui, deploy, general (created on demand from template)
- INIT: seeds LESSONS_INDEX_general.md from templates/LESSONS_INDEX.md
- STATE.md: now tracks Last Lesson ID (L-NNN)
- RECON Index Health Check: step 6 added — count total lessons in LESSONS_INDEX
- RECON output: hive index now includes lesson count
- RUN COMPLETION REPORT: "Lessons extracted" line added to HIVE MIND UPDATES section
- Quick Reference updated with LESSONS EXTRACTION in CLOSE + lessons count in RECON
- Origin: Colony OS closed feedback loop — BECCA is the extractor that closes the loop
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.10.0] 2026-02-16
- BRANCH-PER-RUN (MANDATORY): every run works on `run/<NNN>` git branch
- BECCA creates branch at end of RECON, merges to main at CLOSE after VERIFY
- If VERIFY fails: branch stays unmerged until fix Ant resolves regression
- If run abandoned: branch preserved unmerged (evidence)
- RUN RETROSPECTIVE: new CLOSE step 10 — 5-minute retro at end of each run
- 3 questions: What went well? What broke/slow? What should change?
- Retro saved to RUN_INDEX.md under the run entry (institutional memory)
- Suggested changes queued for NEXT run, not applied during CLOSE
- CLOSE steps renumbered: Retro = step 10, Merge = step 11, Sign off = step 12
- Quick Reference updated with branch-per-run + retro in RECON and CLOSE
- Origin: operator investing in proactive framework improvement over reactive incident response
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.9.0] 2026-02-15
- RUN COMPLETION REPORT: mandatory comprehensive summary at CLOSE before sign-off
- BECCA must count and report: Ant reports, Ghost reviews, Inspector audits, pheromones emitted/resolved, files changed, lines +/-, MASTER_INDEX entries, FILE_OWNERSHIP entries, Leafcutter dispatches, cross-project patterns, prompt feedback
- Full summary table format with 6 sections: Pipeline Summary, Artifacts Produced, Hive Mind Updates, Code Impact, Operator Manual, Archive
- Origin: operator requested proof-of-completion metrics showing the job was done as designed
- Quick Reference updated with RUN COMPLETION REPORT in CLOSE section
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.8.0] 2026-02-12
- CROSS-PROJECT HIVEMIND: new shared/NEO-HIVEMIND-GLOBAL.md for cross-project knowledge
- RECON step 3f: reads global hivemind for cross-project pheromones and patterns
- RECON step 3e: MANUAL DRIFT CHECK — auto-queues MANUAL_DRIFT inspection if >= 5 runs since last audit
- RECON output: now includes manual drift status + global hivemind stats
- CLOSE step 8: CROSS-PROJECT HIVEMIND UPDATE — scans pheromones/lessons for cross-project relevance
- CLOSE steps renumbered: Prompt Feedback = step 9, Sign off = step 10
- NEO-HIVEMIND-GLOBAL.md added to shared module load list
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.7.0] 2026-02-11
- PROJECT LOCK (FROZEN): BECCA declares 🔒 PROJECT LOCK at end of RECON
- Lock binds ALL roles to a single project root path for entire run
- All file reads/writes must be within locked root
- Cross-project WRITE is NEVER allowed
- Cross-project READ requires `🔑 CROSS-PROJECT READ: <path>` token
- V-10 violation: file access outside locked project root = auto-REJECTION
- Lock persists from RECON through CLOSE
- RECON output now includes PROJECT LOCK declaration with root path
- Quick Reference updated with PROJECT LOCK in RECON
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.6.0] 2026-02-10
- PROMPT FEEDBACK AGGREGATION: new CLOSE step 8 — system self-improvement loop
- BECCA reads Section 13 from all Ant reports, groups by category
- 3+ Ants same issue = ⚠️ PRIORITY FIX, 2 = 📋 WATCH, 1 = 💬 NOTED
- Priority fixes noted in RUN_INDEX.md for cross-run tracking
- Aggregated feedback summary presented to operator — advisory only
- CLOSE sign-off is now step 9 (was 8)
- Leafcutter pipeline reference updated: continues to step 8 after Ghost
- Quick Reference updated with feedback aggregation flow
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.5.0] 2026-02-10
- Section references updated for LESSONS addition: Pheromones = Section 9 (was 8)
- OPERATOR MANUAL UPDATE: detection method now also scans Section 8 (Lessons) for gotchas
- ALL changes are section number alignment — NO functional changes

### [1.4.0] 2026-02-10
- OPERATOR MANUAL UPDATE: BECCA no longer updates the manual herself during CLOSE
- NEW: Feature signal detection — scans Ant reports for new functions, endpoints, schemas, middleware, env vars, danger zones
- NEW: Auto-dispatches 🌿 Leafcutter Ant when feature signals detected
- Leafcutter follows standard pipeline: Ant → Ghost (Inspector skipped for docs-only changes)
- Leafcutter task gets next sequential ID (part of the run, indexed in HIVE)
- 10 feature signal types: new function, endpoint, middleware, collection, schema, env var, auth role, trigger, danger zone, data model
- CLOSE step 7 changed from self-update to Leafcutter dispatch
- Quick Reference updated with Leafcutter dispatch flow
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.3.0] 2026-02-10
- OPERATOR MANUAL: project-specific knowledge doc for danger zones, safe ops, critical data models
- RECON: reads OPERATOR_MANUAL_<PROJECT>.md (step 3d) to inform Scout
- RECON output: Operator Manual status (found / missing)
- SCOUT: creates OPERATOR_MANUAL from templates/OPERATOR_MANUAL.md if missing
- CLOSE: updates OPERATOR_MANUAL with new patterns/dangers discovered during run
- File paths: OPERATOR_MANUAL_<PROJECT>.md added to .neo/ tree
- NEO-SURGICAL.md added to shared module load list
- Updated Quick Reference with Operator Manual in SCOUT and CLOSE
- Cross-reference: Operator Manual specification in NEO-SURGICAL.md Section 7
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.2.0] 2026-02-10
- HIVE MIND: BECCA is the sole writer to all 3 index files (MASTER_INDEX, FILE_OWNERSHIP, PHEROMONE_REGISTRY)
- RECON: Index Health Check — counts tasks, pheromones, files tracked; flags stale/orphaned entries
- INIT: Seeds .neo/index/ with MASTER_INDEX_001.md + 5 PHEROMONE severity files
- CLOSE: HIVE INDEX UPDATE — appends to all 3 indexes per completed task, computes fingerprints, detects duplicates
- CLOSE: Pheromone resolution tracking — updates ACTIVE → RESOLVED_TASK-NNN
- STATE.md: now tracks Last Pheromone ID (PH-NNN)
- File paths: .neo/index/ added to project tree
- DOES list: "Check index health" + "Update all indexes"
- NEO-HIVE.md added to shared module load list
- Updated Quick Reference with RECON health check + CLOSE index update
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.1.0] 2026-02-09
- RUN_INDEX.md: BECCA's institutional memory — one entry per completed run
- RECON reads RUN_INDEX.md to understand project history and inform Scout
- RECON output now shows run history count + past run summaries
- INIT creates empty RUN_INDEX.md from templates/RUN_INDEX.md on first run
- CLOSE appends run summary + key outcomes to RUN_INDEX.md
- CLOSE updates QUICK STATS in RUN_INDEX.md (total runs, total tasks, ID range)
- Cross-run observations: BECCA notes recurring patterns in RUN_INDEX NOTES section
- File paths updated: RUN_INDEX.md added to .neo/ tree
- DOES list updated: read run history, update run index
- Quick Reference updated with RUN_INDEX info
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.0.0] 2026-02-09
- Initial release
- Inspired by IAMBecca IM-01 SOURCE (BECCA) — adapted for NEO's 4-role tactical team
- RECON state: project state check, prior TODO handling, task ID continuity, run numbering
- INIT state: first-time .neo/ directory setup with STATE.md
- SCOUT state: dispatches 🚁 Flying Scout Ant to survey project and create TODO
- HANDOFF state: activates first Ant from TODO, then goes dormant
- CLOSE state: archives completed TODO, updates STATE.md
- Task ID continuity: global per project, never reset, never reused
- Incomplete run handling: resume or archive (never delete)
- .neo/STATE.md tracks last run, last task ID, status
- ALL decisions require human confirmation — NO AUTOMATION

## NEO-ANT
**Source:** `roles/NEO-ANT.md`


### [1.26.0] 2026-02-27
- **DEVTOOLS ANT PROGRAM — 3 new Ant types (17-19)**
- DevTools Sentinel Ant (🛡️, #17): Chief browser inspector, runs every closeout
- DevTools Perf Ant (⚡, #18): Performance & stress specialist, triggered by perf changes/regressions
- DevTools Network Ant (🌐, #19): Network & state specialist, triggered by API/auth/payment changes
- Ant type registry: 16 → 19 types
- All 3 types are read-only (observe, never fix); produce DEVTOOLS_REPORT
- Specialized prompts in `prompts/DEVTOOLS_SENTINEL_ANT.md`, `DEVTOOLS_PERF_ANT.md`, `DEVTOOLS_NETWORK_ANT.md`
- Card deck: 6 F12 cards (F12-001 through F12-006) in `cards/ant/`

### [1.25.0] 2026-02-25
- Hive Mind Check: added REJECTION_INDEX (step g) and FINDINGS_INDEX (step h) to mandatory index reads
- HIVE EVIDENCE PROOF table: expanded from 5 to 7 rows (+REJECTION_INDEX, +FINDINGS_INDEX)
- Quick Reference: updated index list to include all 6 local indexes + HIVEMIND_GLOBAL
- DEBUGGER_ANT.md: new specialized prompt (prompts/DEBUGGER_ANT.md v1.0.0) — diagnostic protocol, lab tools, Strike 3 handoff
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.24.0] 2026-02-25
- SAAS SAFETY SCAN: New mandatory DISCOVERY step 0c — tenant isolation + secret detection + data classification
- Tenant Isolation Scan: grep for unscoped queries, verify tenant boundary, TENANT ISOLATION SCAN table
- Secret Scan: grep for API key/token/password patterns, NUCLEAR if found in code (report type only, never value)
- Data Classification: T1 Restricted → T4 Public sensitivity tiers for all data fields touched
- FOOTPRINT: TARGET_ENVIRONMENT declaration now mandatory (EMULATOR/STAGING/PRODUCTION)
- FOOTPRINT: PRODUCTION + destructive ops require 🔑 PRODUCTION CONFIRMED + dry-run evidence
- VERIFY: DESTRUCTIVE OPERATION LOG (operation, target, before/after state, reversible flag)
- VERIFY: RESTORE TEST PROOF for DATA_DELETE and MIGRATION (not attestation-only)
- Quick Reference: SAAS SAFETY SCAN block added
- Cross-reference: NEO-SURGICAL.md v1.4.0 Sections 11-15, NEO-GATES.md v1.9.0 S-35→S-37, NEO-EVIDENCE.md v1.7.0 Section 15
- SAAS SAFETY PREFLIGHT: consolidated 10-item checklist at REPORT state (tenant, secrets, PII, env, prod, backup, destruct, NUCLEAR, audit, horsemen)
- Reduces verification fatigue — one pass catches what scattered checks miss
- Origin: SaaS safety audit — Ants had no mandatory scan for tenant isolation, secrets, or PII, no environment gate, no audit trail for destructive ops, and 12+ scattered checks across 4 modules = fatigue risk
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.23.0] 2026-02-25
- STRIKE 3 DEBUGGER ESCALATION: On Rejection section rewritten with automatic Debugger escalation
- Loop 1–2: same Ant retries as before (address deficiencies, re-run pipeline)
- Loop 3 (Strike 3): Ant STOPS fixing — presents DEBUGGER ESCALATION prompt
- Escalation includes full deficiency history (all 3 loops) for Debugger context
- Operator says "I AM" → BECCA activates Debugger Dispatch Protocol
- Quick Reference: Debugger block updated with "Auto-trigger: Strike 3" line
- Origin: gap — Ants looped indefinitely on the same bug with no diagnostic escalation

### [1.22.0] 2026-02-25
- DEBUGGER ANT LAW UPDATED: expanded from 6 capabilities to 12 — full diagnostic lab
- Chrome DevTools: console, network, DOM snapshot, screenshot, performance trace
- Playwright: bug reproduction in isolated browser (same tools as QA Ant)
- Sentry MCP: production errors, stack traces, breadcrumbs (READ ONLY)
- Firebase MCP: Firestore queries, auth users, Cloud Functions logs (READ ONLY)
- Context7 MCP: library documentation lookup
- CI/CD tools: gh run list/view, vercel ls/logs (READ ONLY)
- Diagnostic Protocol: REPRODUCE → OBSERVE → INVESTIGATE → DIAGNOSE → REPORT
- TEST_REPORT expanded: 8 → 11 sections (added Environment Snapshot, Reproduction Steps, Runtime Observations)
- Quick Reference updated: Debugger block expanded with lab tools + protocol
- QA Ant reference updated: both QA and Debugger have Playwright (QA verifies, Debugger reproduces)
- Cross-reference: NEO-TOOLS.md v1.9.0 Section 4, NEO-OUTPUTS.md v1.10.0 Section 7, templates/TEST_REPORT.md
- Origin: Debugger had code + test runner only — couldn't see runtime state, reproduce bugs, or check prod errors
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.21.0] 2026-02-25
- SCOUT ANT LAW (FROZEN): 🚁 Scout Ant gets its own Law defining abbreviated report format
- Scout uses abbreviated ANT_REPORT: Sections 1, 1b, 2, 8, 11, 13 only (skip 3-7, 9-10, 12)
- No FOOTPRINT, PATCH, VERIFY — Scout surveys and plans, never executes
- Primary artifact is TODO_<PROJECT>.md, not the Ant report
- MANDATORY INPUT: git status freshness (CLEAN or pending file list from BECCA)
- If git status STALE: Scout must note pending changes in SURVEY FINDINGS
- Quick Reference updated with Scout Ant block
- Origin: Ghost findings F-001 to F-004 — Scout reports used full deliverable format creating noise
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.20.0] 2026-02-25
- LESSONS READ: New step 0f in Hive Mind Check — search LESSONS_INDEX for prior lessons on target files
- Ant must grep LESSONS_INDEX_*.md for each target filename before reading code
- GOTCHA and FRAGILE lessons get special attention — these are traps prior Ants hit
- Hive Mind Briefing now includes "Prior Lessons on Target Files" section with L-NNN references
- HIVE EVIDENCE PROOF: now 5 indexes (was 4) — LESSONS_INDEX added as mandatory check
- Ghost will reject if LESSONS_INDEX not read (or not noted as "No lessons index yet")
- Quick Reference updated with LESSONS READ block + 5-index proof requirement
- Origin: Colony OS closed feedback loop — lessons from prior Ants feed forward to next Ant on same files
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.19.0] 2026-02-25
- TOKEN NORMALIZATION: All gate-waiting sections now reference NEO-GATES.md Section 3.4
- If operator responds with paraphrase instead of exact token: STOP, quote exact token needed, wait
- V-12 violation reference added (TOKEN PARAPHRASE ACCEPTED = AUTO REJECT)
- NEAREST TRUTH CHECK: New step 7 in DISCOVERY Code Analysis (NEO-EVIDENCE.md Section 14)
- Source priority: Code > Config > Manual > Reports > External Docs
- If sources conflict: REPORT to operator, do NOT silently pick one
- Prevents the Stale Manual Trap (root cause of Sonny feature deletion)
- Quick Reference updated with TOKEN NORMALIZATION + NEAREST TRUTH blocks
- Origin: Colony OS Token Normalization Rule + Nearest Truth Rule
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.18.0] 2026-02-24
- DISCOVERY STRATEGY: Mandatory step -2 before Hive Mind Check — state ONE QUESTION + first file + search plan
- One-question rule forces focus before reading any code (Colony OS proved faster task completion)
- COMMAND PROOF: Hive Mind Briefing (step 0f) now requires actual grep commands + output pasted
- "I checked" is NOT proof — show the grep, show the result
- BUDGET LEDGER: Mandatory table at end of DISCOVERY tracking files/lines/greps used vs budget
- Links back to Discovery Strategy question + answer (closed loop)
- TRUTHY DIFFS PROTOCOL: 7-step pre-commit verification checklist added to PATCH state
- Checks: FOOTPRINT match, no ghost files, diff accuracy, line count, no scope creep, rollback valid, preserves intact
- ANY Truthy Diffs failure = STOP — do not present PATCH with known issues
- PATCH output now includes "TRUTHY DIFFS: 7/7 ✅" (or failures)
- S-35: Commit includes files outside FOOTPRINT → STOP
- S-36: Used `git add .` or `git add -A` without approval → STOP
- Quick Reference updated with Discovery Strategy, Budget Ledger, Command Proof, Truthy Diffs, S-35/S-36
- State flow updated: DISCOVERY now includes Strategy step
- Origin: Colony OS comparison — Budget Ledger, One-Question Rule, Truthy Diffs all proven in Colony OS v1.3.22
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.16.0] 2026-02-16
- MCP DATA CONTEXT: New optional step 0a in DISCOVERY — query Firebase, Sentry, Context7 before code analysis
- Sentry check: search for recent production errors related to target area before making changes
- Firebase check: query Firestore data state, verify auth claims, understand current data shape
- Context7 check: fetch current library docs to prevent hallucinated/outdated API usage
- MCP checks do NOT count against the Evidence Budget (separate from code analysis)
- SENTRY POST-DEPLOY CHECK: Optional step 12 in VERIFY — check for new errors after deploy
- Quick Reference updated with MCP DATA SERVERS block referencing NEO-TOOLS.md Section 8
- If MCP servers unavailable: skip and note — these are OPTIONAL enhancements
- Origin: 3 MCP servers installed (firebase, sentry, context7) — Ants now have direct data access

### [1.15.0] 2026-02-16
- CI/CD VERIFICATION: MANDATORY at VERIFY for all Ants
- VERIFY step now has 2 phases: LOCAL (tests, build, lint) + CI/CD (gh run list, vercel ls)
- Ants must check GitHub Actions AND Vercel after every push
- If CI/CD fails: read logs (`gh run view --log-failed`), fix, re-push, verify green
- CI/CD STATUS TABLE required in VERIFY output (Platform, Status, Run ID, Evidence)
- 2 new STOP conditions: S-31 (CI failing but reporting passed), S-32 (skipping CI check)
- Quick Reference updated with CI/CD verification block
- Origin: Ants reporting "everything went well" while Vercel showed deployment failures

### [1.14.0] 2026-02-16
- QA ANT: 16th Ant type added — 🔍 QA Ant (🟡 STANDARD risk, Browser Verification domain)
- QA Ant Law (FROZEN): browser first, read Ant report, click like user, inspect like dev, screenshot everything, no code changes, QA_REPORT output
- Specialized prompt pattern: `prompts/QA_ANT.md` loaded alongside NEO-ANT.md
- Requires: Playwright MCP server (@playwright/mcp)
- QA Ant uses Playwright MCP to: navigate, click, fill forms, take screenshots, inspect a11y tree, check network
- QA Ant is READ-ONLY — same file permissions as Debugger Ant + Playwright MCP (both have Playwright; QA verifies, Debugger reproduces)
- BECCA can dispatch QA Ant after builder Ant pipeline completes (pre-CLOSE verification)
- Standard builder Ants can also use Playwright MCP during VERIFY for complex features (Option C)
- Keywords: test, verify, qa, browser, click, navigate, screenshot, network, console, f12, inspect, e2e, smoke
- Quick Reference updated with QA Ant (16 Ant Types)
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.13.0] 2026-02-16
- HIVE EVIDENCE PROOF ("Prove Not Vibe"): DISCOVERY output now requires mandatory index check proof
- Ant must cite specific findings from all 4 indexes (MASTER_INDEX, FILE_OWNERSHIP, PHEROMONE_REGISTRY, HIVEMIND_GLOBAL)
- "I checked" is NOT proof — Ant must state what was found (prior task IDs, pheromone IDs, or "0 entries")
- PRIOR WORK PRESERVED: Ant must name every prior task on target files and attest their changes survive
- DEPENDS_ON and PRESERVES header fields added to report output
- DISCOVERY output expanded: hive evidence table, prior work list, dependencies
- Origin: Colony OS comparison showed its D0/H2 system forces proof of index checks. NEO Ants were skipping evidence. "Prove not vibe."
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.12.0] 2026-02-15
- PRE-BUILD VERIFICATION: New mandatory step 0b in DISCOVERY — search before building
- Ants must Glob + Grep for existing implementations before creating ANY new file
- If existing code found: AUDIT and FIX, do NOT rebuild from scratch
- DISCOVERY output now requires Pre-Build Search results (patterns used, findings, decision)
- 2 new STOP conditions: S-29 (new file without Pre-Build Search), S-30 (existing code found for "new" feature)
- Quick Reference updated with PRE-BUILD SEARCH section
- Origin: Run 007 post-mortem — "plain Claude" rebuilt 6,000+ LoC duplicate app instead of auditing existing code
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.11.0] 2026-02-12
- FIGMA ANT: 15th Ant type added — 🖌️ Figma Ant (🟡 STANDARD risk, Design-to-Code domain)
- Figma Ant Law (FROZEN): EXTRACTION first, tokens first, pixel accurate, compare at VERIFY, UI only
- Specialized prompt pattern: `prompts/FIGMA_ANT.md` loaded alongside NEO-ANT.md
- EXTRACTION state: pre-DISCOVERY Figma spec reading via Figma MCP server
- Figma MCP tools: get_file, get_node, get_styles, get_components, get_images, search
- Requires Figma MCP server configured (see NEO-TOOLS.md Section 5)
- Keywords: figma, design, component, ui, prototype, mockup, wireframe, layout, design-tokens, pixel-perfect
- Quick Reference updated with Figma Ant + prompts reference (15 Ant Types)
- Critical Surface reference updated: Section 5 → Section 6 (NEO-TOOLS.md renumbered)
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.10.0] 2026-02-12
- GLOBAL HIVEMIND: Ant reads shared/NEO-HIVEMIND-GLOBAL.md during DISCOVERY step 0
- Hive Mind Check step 0e: scan cross-project pheromones, anti-patterns, safe patterns, lessons
- GP-NNN pheromones treated same as local pheromones (NUCLEAR STOP applies)
- Hive Mind Briefing now includes relevant global hivemind entries
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.9.0] 2026-02-11
- PROJECT LOCK VALIDATION: Mandatory path check before EVERY file read/write
- CHECKPOINT FIRST (FROZEN): Every Ant creates git checkpoint before ANY work
- Checkpoint includes: git stash, record HEAD hash, present proof to operator
- New state: CHECKPOINT (between activation and DISCOVERY)
- Project Lock Check added to DISCOVERY step -1 (before Hive Mind Check)
- 4 new STOP conditions: S-25 (outside project lock), S-26 (missing checkpoint), S-27 (outside scope boundary), S-28 (wrong project files)
- On Activation sequence expanded: 11 steps (was 7) — includes checkpoint + project lock
- Quick Reference updated with CHECKPOINT FIRST + PROJECT LOCK sections
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.8.0] 2026-02-11
- COLOR EXPERT ANT: 14th Ant type added — 🎨 Color Expert Ant (🔴 HIGH risk, Styling domain)
- Color Expert Ant Law (FROZEN): LAB first, CSS only, max 3 changes, checkpoint first, both modes, blast radius, precedence proof
- Specialized prompt pattern: `prompts/COLOR_EXPERT_ANT.md` loaded alongside NEO-ANT.md
- LAB state: pre-DISCOVERY experimentation (Color Expert only, no gate)
- Operator Manual Section 9 (Theme/Styling) required before Color Expert can start
- Risk table updated: Color Expert joins Fire Ant + Financial Ant at 🔴 HIGH
- Keywords: theme, css, color, contrast, accessibility, dark mode, light mode, palette, gradient, wcag
- Quick Reference updated with Color Expert + prompts reference
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.7.0] 2026-02-10
- PROMPT FEEDBACK: new Section 13 in Ant Report — system self-improvement loop
- REPORT state: step 5 added — "Complete PROMPT FEEDBACK (Section 13)"
- 4 feedback categories: clarity issues, missing rules, false positives, suggestions
- Feedback does NOT affect task PASS/FAIL — Ghost validates presence, not content
- Quick Reference updated with S13:FEEDBACK reference
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.6.0] 2026-02-10
- LESSONS FOR FUTURE ANTS: new Section 8 in Ant Report — knowledge transfer
- REPORT state: step 4 added — "Complete LESSONS FOR FUTURE ANTS (Section 8)"
- 5 lesson categories: what worked, fragile/surprising, approach advice, verification pattern, protocol tip
- Section renumbering: Risks=9, Gate Log=10, Hive Context=11, Handoff=12
- Quick Reference updated with Section 8 LESSONS reference
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.5.0] 2026-02-10
- SURGICAL PROTOCOL integration (NEO-SURGICAL.md v1.0.0)
- NEO-SURGICAL.md added to shared module load list
- DISCOVERY: Understanding Proof (LAW 1) — 4-check evidence requirement before any change
- DISCOVERY: Operator Manual check (danger zones, safe patterns, intentional patterns)
- FOOTPRINT: Data Operation Classification table required for each file
- FOOTPRINT: Write semantics (PATCH default, PUT/DELETE require justification)
- STATE: BACKUP added (conditional, between FOOTPRINT and PATCH, LAW 2)
- BACKUP: Backup proof format (timestamp, location, scope, restore, verification)
- BACKUP: Skipped for CODE_ONLY / READ_ONLY tasks
- STOP conditions S-19 → S-24 added (assumption, rebuild, seed/live, backup, PUT)
- Updated Quick Reference with BACKUP gate, surgical protocol, data op classification
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.4.0] 2026-02-10
- HIVE MIND CHECK: mandatory at start of DISCOVERY, before reading any code
- Ant reads MASTER_INDEX, FILE_OWNERSHIP, PHEROMONE_REGISTRY for target files
- HIVE MIND BRIEFING: presents previous tasks, active pheromones, traffic assessment
- ⚫ NUCLEAR STOP RULE: if target file has active NUCLEAR pheromone → STOP, request clearance
- S-18 STOP condition: NUCLEAR pheromone active on target file (from Hive)
- NEO-HIVE.md added to shared module load list
- Section 11: HIVE CONTEXT added to ANT_REPORT (see templates/ANT_REPORT.md) *(was Section 10, renumbered in v1.6.0)*
- First-run graceful: skips hive check if .neo/index/ doesn't exist yet
- Updated Quick Reference with Hive Mind Check + Section 11
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.3.0] 2026-02-09
- TODO coordination: Ant reads project TODO on activation, updates it on completion
- "I AM" protocol: activation via operator trigger, handoff prompt to Ghost
- Rejection loop handling: reads deficiency list from TODO NOTES, increments loop counter
- 3-loop flag: warns operator if task has looped 3 times
- NEO-ACTIVATION.md added to shared module load list
- Updated activation response to be TODO-aware (reads TODO, shows current task)
- Updated Quick Reference with activation/handoff/TODO info
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.2.0] 2026-02-09
- 🐛 Debugger Ant added as 13th type (🟡 STANDARD risk, diagnose-only, TEST_REPORT output)
- Debugger Ant Law (FROZEN): diagnose only, never fix, hand off to appropriate Ant
- Anti-Drowning Protocol: evidence budget in DISCOVERY (5 files / 200 lines / 10 greps)
- Snapshot Summary: mandatory 5-line summary at end of DISCOVERY
- Critical Surface flagging in FOOTPRINT state
- Pheromone emission requirement in FOOTPRINT state
- Expanded STOP conditions: 17 triggers (up from 7) including ⚫ NUCLEAR
- STOP MEANS STOP enforcement: acknowledge+continue = NON-COMPLIANT
- Permission awareness: DISCOVERY APPROVED token for L1 escalation
- Updated Quick Reference with all new systems
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.1.0] 2026-02-09
- Added 12 Canonical Ant Types from Colony OS classification system
- 4 risk levels: HIGH (🔴), MEDIUM (🟠), STANDARD (🟡), LOW (🟢)
- Risk-based gate behavior: HIGH → security/payment impact at FOOTPRINT, domain tests at VERIFY
- Ant Type now required input (alongside Task ID, Objective, Target files, Success criteria)
- Classification flows through entire pipeline: task packet → report → index → Ghost review
- Updated Quick Reference with Ant Type taxonomy

### [1.0.0] 2026-02-09
- Initial release
- Adapted from IAMBecca IM-05 Neo (Ant-Coder)
- Stripped automation mode — manual-only operation
- 5-state lifecycle: DISCOVERY → FOOTPRINT → PATCH → VERIFY → REPORT
- 4 mandatory gates with 🔑 approval tokens
- Evidence requirements per state
- Hard limits and scope enforcement
- Rollback plan template

## NEO-GHOST
**Source:** `roles/NEO-GHOST.md`


### [1.20.0] 2026-02-27
- CDEX GHOST GATE: Card compliance enforcement added to Review Checklist
- Ghost MUST verify CARD_RECEIPT present in Ant report with: deck_id, cards_executed, card outputs
- Ghost MUST block if: required CORE cards missing, cards skipped without waiver, freeform work without card citation
- Self-Healing output: on card block, Ghost states which card(s) missing + next card to run + expected artifact
- FAIL_BLOCKING if CARD_RECEIPT absent or CORE cards missing without valid CARD_WAIVER
- Prime directives: "If it isn't on a card, it didn't happen." / "If it didn't produce a receipt, it isn't accepted."
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.19.0] 2026-02-26
- PRE-SUBMIT SELF-REVIEW VERIFICATION: Step 23 added to REVIEW process
  - Verify 5-question Pre-Submit table present in Ant report Section 7
  - Missing table = MEDIUM finding, any NO answer = HIGH finding
  - YES but Ghost finds contradiction = HIGH (dishonest self-assessment)
- RULE CITATION IN DEFICIENCIES: Ghost now cites specific Rule Triggered (S-NN/V-NN) and Stage in every deficiency
  - Enables BECCA to track rejection patterns in REJECTION_INDEX
  - Format: `[Rule: S-NN/V-NN/NONE] [Stage: DISCOVERY/FOOTPRINT/BACKUP/PATCH/VERIFY/REPORT]`
- OUTPUT list updated: +Pre-Submit Self-Review PASS/FAIL
- Origin: Deep dive consistency check - Ghost had no awareness of Ant Pre-Submit Self-Review or rule citation
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.18.0] 2026-02-25
- Hive Mind Compliance: INDEX CHECK PROOF expanded from 5 to 7 indexes (+REJECTION_INDEX, +FINDINGS_INDEX)
- Quick Reference: updated "5 indexes" → "7 indexes" in HIVE EVIDENCE PROOF references
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.17.0] 2026-02-25
- SAAS SAFETY COMPLIANCE: New review checklist section — 7 checks for SaaS data protection
- Tenant Isolation Scan: verify Ant performed scan in DISCOVERY (multi-tenant projects)
- Secret Scan: verify Ant ran grep patterns for secrets (all projects)
- Data Classification: verify T1-T4 tiers present for data operations
- TARGET_ENVIRONMENT: verify declared in FOOTPRINT — AUTO REJECT if missing (S-35)
- PRODUCTION + destructive: verify 🔑 PRODUCTION CONFIRMED + dry-run evidence
- Destructive Operation Log: verify before/after state documented in VERIFY
- Restore Test Proof: verify for DATA_DELETE/MIGRATION (not attestation-only)
- NUCLEAR = HALT enforcement: V-13 if Ant continued after NUCLEAR without resolution
- Violation Detection: V-13 added (NUCLEAR VIOLATION — continued past NUCLEAR)
- Section 6: Violation scan range updated V-01→V-13 (was V-01→V-09)
- Quick Reference: NEW CHECKS v1.17.0 SAAS SAFETY block + S-35 and V-13 auto-reject triggers
- Cross-reference: NEO-SURGICAL.md v1.4.0 Sections 11-15, NEO-GATES.md v1.9.0, NEO-EVIDENCE.md v1.7.0
- Origin: SaaS safety audit — Ghost had no verification for tenant isolation, secrets, PII, environment, or destructive op audit trails
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.16.0] 2026-02-25
- STRIKE 3 ESCALATION: On Rejection section rewritten with loop-aware behavior
- Loop 1–2: standard rejection prompt ("Send back to Ant? → I AM")
- Loop 3 (Strike 3): Ghost presents STRIKE 3 prompt with full rejection history
- Strike 3 prompt includes deficiency summaries from all 3 Ghost reviews
- Recommends 🐛 Debugger Ant escalation → reactivates BECCA (not Ant)
- Quick Reference: added STRIKE 3 block (3 lines) after REJECTION line
- Origin: Ghost had no awareness of loop count — treated rejection 1 same as rejection 10

### [1.15.0] 2026-02-25
- LESSONS READ VERIFICATION: Ghost checks Ant read LESSONS_INDEX during Hive Mind Check (NEO-HIVE.md Section 9)
- HIVE EVIDENCE PROOF: now validates 5 indexes (was 4) — LESSONS_INDEX added as mandatory check
- If LESSONS_INDEX row missing from proof table: AUTO REJECT (for v1.20.0+ Ants)
- If prior GOTCHA/FRAGILE lessons exist but Ant didn't acknowledge: MEDIUM finding
- If Ant repeated a problem that a prior lesson warned about: HIGH finding — "known GOTCHA repeated"
- "No lessons index yet" acceptable only when .neo/index/LESSONS_INDEX_*.md doesn't exist
- REVIEW state gains step 22 (Lessons Read verification)
- New Review Checklist subsection: Lessons Read Verification (6 items)
- Quick Reference updated with NEW CHECKS v1.15.0 block + 2 new auto-reject triggers
- Origin: Colony OS closed feedback loop — Ghost enforces that Ants actually read prior lessons
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.14.0] 2026-02-25
- TOKEN NORMALIZATION VERIFICATION: Ghost checks gate log for exact token usage (NEO-GATES.md Section 3.4)
- If Ant accepted paraphrased approval ("looks good", "LGTM") instead of exact token → V-12 → AUTO REJECT
- NEAREST TRUTH COMPLIANCE: Ghost verifies source conflicts were REPORTED, not silently resolved (NEO-EVIDENCE.md Section 14)
- Stale Manual Trap check: if Ant deleted/modified code based on stale manual contradicting live code → HIGH finding
- If no source conflicts encountered: N/A (not a failure)
- REVIEW state gains steps 20-21 (Token Normalization, Nearest Truth)
- Violation Detection checklist gains V-12 (paraphrased approval)
- 2 new Review Checklist subsections: Token Normalization Compliance, Nearest Truth Compliance
- Quick Reference updated with NEW CHECKS v1.14.0 block + V-12 auto-reject trigger
- Origin: Colony OS Token Normalization Rule + Nearest Truth Rule — both prevent the root causes of the Sonny feature deletion
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.13.0] 2026-02-24
- DISCOVERY STRATEGY VERIFICATION: Ghost checks Ant stated ONE QUESTION, identified first file, and answered the question
- Missing Discovery Strategy = AUTO REJECT
- BUDGET LEDGER VERIFICATION: Ghost checks resource tracking table present with real numbers
- Spot-check: files-read count must match files actually cited in DISCOVERY
- Missing Budget Ledger or numbers that don't add up = AUTO REJECT
- COMMAND PROOF / GREP PROOF: Ghost spot-checks 2 grep claims from Hive Mind Briefing
- "I checked" without actual grep commands + output = HIGH finding
- TRUTHY DIFFS VERIFICATION: Ghost checks 7/7 checklist present in PATCH output
- Cross-checks: FOOTPRINT file match + ghost file detection
- Missing Truthy Diffs or ghost files found = AUTO REJECT
- OPERATOR MANUAL CURRENCY: Ghost flags if Operator Manual > 5 runs stale
- Does NOT auto-reject — but MUST flag so BECCA addresses during CLOSE
- REVIEW state gains steps 15-19 (Discovery Strategy, Budget Ledger, Command Proof, Truthy Diffs, Manual Currency)
- Anti-Assumption Rules reference updated: A-01 → A-14 (was A-01 → A-08)
- 5 new AUTO-REJECT triggers added to Quick Reference
- Quick Reference updated with NEW CHECKS v1.13.0 block
- Origin: Colony OS comparison — Budget Ledger, One-Question Rule, Truthy Diffs all proven in Colony OS v1.3.22
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.12.0] 2026-02-16
- SENTRY CROSS-CHECK: Ghost can now check Sentry MCP for new errors after Ant's deploy (Section 4d)
- If new errors correlate with Ant's changes → HIGH finding
- If Ant claimed "Sentry: CLEAN" but errors exist → MEDIUM finding
- OPTIONAL: only when Sentry MCP connected and SENTRY_DSN configured
- Ghost reads Sentry data via MCP — no write permissions needed
- Origin: 3 MCP data servers installed (firebase, sentry, context7)

### [1.11.0] 2026-02-16
- CI/CD VERIFICATION: Ghost cross-check of external CI/CD status (Section 4c)
- Ghost can run `gh run list` and `vercel ls` to independently verify Ant's claims
- If Ant says PASS but CI/CD shows FAIL → AUTO REJECT
- If Ant report missing CI/CD status table → AUTO REJECT
- 2 new AUTO-REJECT triggers added to Quick Reference
- Ghost uses read-only CLI commands (no write permissions needed)
- Origin: Ants reporting "everything went well" while Vercel deployments showed failures

### [1.10.0] 2026-02-16
- HIVE EVIDENCE ENFORCEMENT ("Prove Not Vibe"): Ghost now enforces mandatory proof in Section 11
- Section 11 renamed: HIVE CONTEXT → HIVE EVIDENCE (stronger name, mandatory subsections)
- 11a INDEX CHECK PROOF: All 4 indexes must show YES with specific evidence — AUTO REJECT if NO or generic
- 11b PRIOR TASK CROSS-REFERENCE: Every target file must list prior tasks and what they did
- 11c PRIOR WORK PRESERVED: Every prior task must have preservation attestation — AUTO REJECT if missing
- Ghost validates DEPENDS_ON and PRESERVES header fields in Ant report
- Ghost validates Pre-Build Search evidence when new files are created
- 5 new AUTO-REJECT triggers added to Quick Reference (index check=NO, missing attestation, missing headers, no Pre-Build Search for new files)
- Origin: Colony OS comparison showed its Ants do MORE cross-referencing than NEO Ants. Colony OS's D0/H2 forcing functions prevent Ants from walking over each other's work. NEO now matches.
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.9.0] 2026-02-12
- EVIDENCE RE-EXECUTION: new Section 4b in 8-section review
- Ghost requests operator to re-run test/build/lint commands from Ant VERIFY section
- Mismatch between Ant's claimed results and actual re-run = AUTO REJECT (score 0%)
- Operator can skip re-execution (S) → UNVERIFIED finding (INFO, not blocking)
- All matches (Y) → adds confidence to evidence score
- Conditional: skipped for Leafcutter (docs), Scout (research), Board (planning)
- Section Index updated: 4b between 4 and 5
- Quick Reference updated: Evidence re-execution mismatch added to auto-reject triggers
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.8.0] 2026-02-10
- PROMPT FEEDBACK VALIDATION: new subsection in Review Checklist
- Ghost checks Section 13: PROMPT FEEDBACK is present
- Ghost validates feedback is real (not copy-paste filler)
- Ghost does NOT reject based on feedback content — only section presence
- Missing PROMPT FEEDBACK section = AUTO REJECT
- Report Completeness: now 13 main sections (was 12)
- Quick Reference updated with prompt feedback auto-reject trigger
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.7.0] 2026-02-10
- LESSONS VALIDATION: new subsection in Review Checklist
- Ghost checks Section 8: LESSONS FOR FUTURE ANTS is present
- Ghost validates lessons are substantive (not all N/A for non-trivial tasks)
- Ghost validates lessons are specific to files/area (not generic boilerplate)
- Missing LESSONS section = AUTO REJECT (added to Quick Reference)
- Section references updated: HIVE CONTEXT = Section 11 (was 10)
- Quick Reference updated with lessons auto-reject trigger
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.6.0] 2026-02-10
- SURGICAL PROTOCOL COMPLIANCE: new subsection in Review Checklist
- Ghost validates LAW 1 Understanding Proof (4-check evidence in DISCOVERY)
- Ghost validates LAW 2 Backup proof (if data operations present)
- Ghost validates LAW 3 Data Operation Classification + write semantics
- Ghost checks for assumption patterns (A-01 → A-08 violations)
- Ghost checks for dry-run evidence (if destructive operations)
- Ghost validates 🔑 BACKUP APPROVED token in gate log (if data ops)
- Ghost checks Operator Manual was consulted (if exists)
- V-09 BACKUP SKIP added to Violation Detection checklist
- NEO-SURGICAL.md added to shared module load list
- REVIEW state step 14: Surgical Protocol compliance check (7 sub-checks)
- Section 5 expanded: now includes surgical protocol validation
- Section 6: Violation scan expanded to V-01 → V-09
- Updated Quick Reference with surgical auto-reject triggers
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.5.0] 2026-02-10
- HIVE MIND COMPLIANCE: new subsection in Review Checklist (Section 5)
- Ghost validates Ant's Section 11: HIVE CONTEXT is present and accurate *(was Section 10, renumbered in v1.7.0)*
- Ghost spot-checks 2 hive context claims against actual .neo/index/ files
- Ghost verifies NUCLEAR pheromones acknowledged on target files
- Ghost flags high-traffic files (>5 previous tasks)
- NEO-HIVE.md added to shared module load list
- Section Index table updated: Section 5 now includes hive mind validation
- Updated Quick Reference with hive mind auto-reject trigger
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.4.0] 2026-02-09
- 8-SECTION STRUCTURED OUTPUT: Ghost review now has 8 clean numbered sections (inspired by Colony OS Ghost Archivist)
- Section 1: REVIEW HEADER — task ID, Ant type, risk level, paths, overview
- Section 2: REPORT COMPLETENESS — 10-row check + Snapshot Summary 5-field sub-check
- Section 3: DEFINITION OF DONE — each criterion vs evidence
- Section 4: EVIDENCE VALIDATION — 6 checks + score (< 50% = AUTO REJECT)
- Section 5: COMPLIANCE CHECK — Ant type validation + critical surfaces + gate log verification
- Section 6: NUCLEAR & PHEROMONE AUDIT — NUCLEAR check + pheromone validation + violation scan (V-01→V-08)
- Section 7: FINDINGS — catalog with severity + finding details + severity summary table
- Section 8: VERDICT & HANDOFF — decision + rationale + score card + deficiency list + handoff prompt
- ALL 8 sections ALWAYS appear (no skipping, even if CLEAR/NONE)
- Eliminated messy sub-numbering (4, 4b, 4c, 4d, 4e → clean 1-8)
- Section Index table added to output format for quick reference
- Template updated: templates/GHOST_REVIEW.md matches new 8-section structure
- Quick Reference updated with 8-section list + auto-reject triggers
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.3.0] 2026-02-09
- TODO coordination: Ghost reads project TODO on activation, finds Ant report path
- "I AM" protocol: activation via operator trigger, handoff prompt to Inspector
- Rejection handling: marks TODO ❌, adds deficiency list to NOTES, prompts loop-back to Ant
- NEO-ACTIVATION.md added to shared module load list
- Updated activation response to be TODO-aware (reads TODO, shows task + report path)
- Updated Quick Reference with activation/handoff/rejection info
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.2.0] 2026-02-09
- ⚫ NUCLEAR awareness: Ghost checks for tenant breach, credentials, isolation violations
- Pheromone validation: all risks must have corresponding pheromones, missing = REJECT
- Violation detection: 8 named violations (V-01 to V-08) checked during review
- Snapshot summary verification: checks 5-field summary present from DISCOVERY
- Critical surface verification: checks all critical surface edits had OVERRIDE tokens
- REVIEW state expanded with steps 9-13 (NUCLEAR, pheromones, violations, snapshot, critical surfaces)
- Output format gains 4 new sections: PHEROMONE VALIDATION, VIOLATION CHECK, SNAPSHOT SUMMARY CHECK, critical surfaces
- Updated Quick Reference with all new mandatory checks
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.1.0] 2026-02-09
- Added Ant Type validation to REVIEW state (steps 2-4)
- Risk-based review requirements: HIGH needs impact assessment + domain tests, MEDIUM needs edge-case tests
- New "Ant Type Validation" section in Review Checklist
- Ghost output format now includes ANT_TYPE and RISK_LEVEL in header
- ANT TYPE VALIDATION section added to output format
- Updated Quick Reference with Ant Type validation block

### [1.0.0] 2026-02-09
- Initial release
- Adapted from IAMBecca IM-12 Ghost Twins
- 4-state lifecycle: REVIEW → VALIDATE_EVIDENCE → ARCHIVE → VERDICT
- Evidence validation checklist
- Ghost verdict tokens
- Review checklist (completeness, code quality, evidence quality, DoD)
- Read-only enforcement — Ghost never fixes

## NEO-INSPECTOR
**Source:** `roles/NEO-INSPECTOR.md`


### [1.8.0] 2026-02-27
- GATE_COMPLIANCE inspection type: 8-point audit verifying all pipeline gates were followed
- Checks: task coverage, discovery gate, footprint gate, patch gate, ghost review, production gate, ungoverned commits, gate order
- Severity: checks 1-5 = BLOCKER, 6-7 = HIGH, 8 = MEDIUM
- CARD_COMPLIANCE inspection type: 7-point audit for CDEX card discipline
- Checks: deck generated, receipt present, core cards executed, waivers valid, outputs match, no freeform, ghost verified
- Severity: checks 1-4 = BLOCKER, 5-6 = HIGH, 7 = MEDIUM
- Inputs table: GATE_COMPLIANCE + CARD_COMPLIANCE added (now 11 types)
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.7.0] 2026-02-25
- SAAS_SAFETY inspection type: 12-point audit for SaaS data safety
- Checks: tenant isolation scan, secret scan, data classification, TARGET_ENVIRONMENT, PRODUCTION CONFIRMED, destructive op log, restore test, NUCLEAR enforcement, audit trail, PII protection, secret protection, backup scope
- Severity mapping: checks 1-5 = BLOCKER, 6-9 = HIGH, 10-12 = MEDIUM
- Inputs table: SAAS_SAFETY added as inspection type option
- Cross-reference: NEO-SURGICAL.md v1.4.0 Sections 11-15, NEO-EVIDENCE.md v1.7.0 Section 15
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.6.0] 2026-02-25
- HIVE audit upgraded from 8-point to 9-point: added LESSONS_INDEX consistency check (entries match Ant report Section 8 lessons, correct domain sharding)
- NEO-HIVEMIND-GLOBAL.md added to shared modules load list (was missing — Inspector needs it for cross-project audit)
- COMPLIANCE inspection: added Token Normalization (V-12) check and Nearest Truth Rule check
- Quick Reference updated with 9-point HIVE audit
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.5.0] 2026-02-12
- MANUAL_DRIFT inspection type: 10-point audit comparing Operator Manual against actual codebase
- Checks: function count, collection count, route count, env vars, test files, middleware, services, danger zone paths, KIP patterns, nuclear invariants
- Severity: 0 drift = INFO, 1-2 = MEDIUM, 3-5 = HIGH, 6+ = BLOCKER
- Drift found → emit MEDIUM pheromone per drifted section → recommend Leafcutter dispatch
- BECCA auto-triggers MANUAL_DRIFT if >= 5 runs since last audit (RECON step 3e)
- Template: templates/MANUAL_DRIFT_REPORT.md (10-check table + details)
- Inputs table: MANUAL_DRIFT added as inspection type option
- Updated Quick Reference with MANUAL_DRIFT inspection type
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.4.0] 2026-02-10
- SURGICAL inspection type: 10-point audit against NEO-SURGICAL.md
- Checks: Understanding Proof (LAW 1), Operator Manual, Data Op Classification (LAW 2), Backup proof, BACKUP APPROVED token, Write semantics (LAW 3), Anti-assumption rules, Minimum delta, Dry-run evidence, Demo/live separation
- Severity mapping: LAW 1-2 failures = BLOCKER, LAW 3 failures = HIGH, dry-run/demo-live = MEDIUM
- NEO-SURGICAL.md added to shared module load list
- Inputs table: SURGICAL added as inspection type option
- Updated Quick Reference with SURGICAL inspection type
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.3.0] 2026-02-10
- HIVE inspection type: 8-point index consistency audit
- Checks: entry count, cross-index consistency, duplicate fingerprints, resolved pheromone validity, shard limits, orphaned entries, format compliance
- Missing NUCLEAR pheromone in index = BLOCKER; other index issues = MEDIUM
- NEO-HIVE.md added to shared module load list
- Inputs table: HIVE added as inspection type option
- Updated Quick Reference with HIVE inspection type
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.2.0] 2026-02-09
- TODO coordination: Inspector reads project TODO on activation, finds both Ant + Ghost artifacts
- "I AM" protocol: activation via operator trigger, handoff to next Ant or BECCA
- PASS handling: checks for remaining tasks, prompts next Ant; when all done → hands off to BECCA
- FAIL handling: marks TODO ❌, adds blocker list to NOTES, prompts loop-back to Ant
- Archival moved to BECCA: Inspector no longer archives directly — BECCA owns VERIFY + CLOSE
- NEO-ACTIVATION.md added to shared module load list
- Updated activation response to be TODO-aware (reads TODO, shows task + both artifact paths)
- Updated Quick Reference with activation/handoff/BECCA info
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.1.0] 2026-02-09
- 2 new inspection types: NUCLEAR (tenant/security boundary) and PHEROMONE (risk marker validation)
- ⚫ NUCLEAR severity added above BLOCKER — no override, always FAIL
- NUCLEAR inspection checks: cross-tenant data, isolation breaches, credential exposure, security bypass, unsafe deletion
- PHEROMONE inspection checks: risk-pheromone matching, suppression detection, format compliance
- Updated Quick Reference with NUCLEAR and PHEROMONE types
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.0.0] 2026-02-09
- Initial release
- Adapted from IAMBecca EXT-02 Keymaker (Prompt Inspector)
- 3 inspection types: DRIFT, COMPLIANCE, QUALITY
- 5 severity levels: BLOCKER, HIGH, MEDIUM, LOW, INFO
- Structured findings format
- Read-only enforcement — Inspector never fixes
- Verdict tokens: INSPECTOR PASS / INSPECTOR FAIL

## NEO-GATES
**Source:** `shared/NEO-GATES.md`


### [1.13.0] 2026-02-27
- 3 new DEVTOOLS gate tokens: DEVTOOLS_CHIEF COMPLETE, DEVTOOLS_SPECIALISTS COMPLETE, DEVTOOLS VERIFICATION APPROVED
- Added to Section 3.2 (gate tokens table) and Appendix A (master token reference)
- S-40: DevTools verification skipped during closeout — STOP (operator override with justification)
- Ant type taxonomy: 16 → 19 types (3 DevTools Ants)

### [1.12.0] 2026-02-27
- Appendix B: CDEX (Card-Deck Execution System) — CARD_WAIVER protocol, CDEX tokens
- S-38: CARD_RECEIPT missing from agent output — STOP
- S-39: CORE card skipped without CARD_WAIVER — STOP (NUCLEAR severity)
- 3 CDEX tokens: OUTPUT_INVALID, CARD_WAIVER, FAIL_BLOCKING
- CARD_WAIVER: 5-field format (card_id, reason, risk, mitigation, approved_by)
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.11.0] 2026-02-25
- Header version corrected: v1.9.0 → v1.11.0 (was behind changelog)
- Ant type taxonomy count corrected: "12-type" → "16-type" in Section 8 and changelog

### [1.10.0] 2026-02-25
- Appendix A: MASTER REFERENCE — consolidated all S-01→S-37, V-01→V-13, all tokens in one appendix
- Three tables: STOP conditions (37 entries), Violations (13 entries), Tokens (pipeline + override + rejection)
- One-stop lookup for every numbered rule — roles no longer need to hunt across sections
- Origin: Deep dive audit — S-numbers, V-numbers, and tokens scattered across 6+ files with no consolidated view
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.9.0] 2026-02-25
- NUCLEAR ENFORCEMENT: NUCLEAR upgraded from STOP to HARD HALT — pipeline transitions to HALTED state
- NUCLEAR INCIDENT REPORT: mandatory structured report (task, trigger, file, evidence, blast radius, immediate risk, recommended action)
- 🔑 NUCLEAR RESOLVED: <action> — new token to clear NUCLEAR HALT (operator-only)
- 🔑 PRODUCTION CONFIRMED — new token for destructive operations targeting production environment
- V-13 NUCLEAR VIOLATION: continuing work after NUCLEAR detection without resolution = auto-reject + compliance fail
- S-35: TARGET_ENVIRONMENT missing from FOOTPRINT — BLOCKER (every FOOTPRINT must declare environment)
- S-36: Destructive operation targeting PRODUCTION without 🔑 PRODUCTION CONFIRMED — ⚫ NUCLEAR severity
- S-37: Ant continued working after NUCLEAR detection — ⚫ NUCLEAR severity (V-13)
- Quick Reference: NUCLEAR upgraded to HARD HALT, SAAS SAFETY block, V-13, S-35→S-37, new tokens
- Origin: SaaS safety audit — NUCLEAR was a pheromone with no HALT, no environment gate, no production confirmation
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.8.0] 2026-02-25
- S-32: TODO state mismatch (TODO run# ahead of STATE.md last run) — BLOCKER, prevents overwriting prior run without CLOSE
- S-33: Scout survey without git freshness check — HIGH, Scout must verify git is CLEAN before surveying
- S-34: Manual drift >10 runs since last audit — HIGH, BECCA must dispatch mandatory MANUAL_DRIFT inspection
- Quick Reference updated with S-32→S-34 range
- Origin: Ghost findings — Run 113 TODO overwritten by 114 without CLOSE, TASK-381 no-op from stale git, Manual >10 runs stale
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.7.0] 2026-02-25
- Section 3.4: TOKEN NORMALIZATION RULE (FROZEN) — gate tokens must be EXACT VERBATIM
- Paraphrases ("looks good", "LGTM", "ok") are INVALID — Ant must STOP and request exact token
- Section 3.5: Normalization Exceptions — `🔑 CONTINUE`/`🔑 GO` both valid, freeform `<reason>` portions exempt
- Token Rules (3.3): "Exact verbatim" rule added to table
- V-12: TOKEN PARAPHRASE ACCEPTED — Ant proceeded on paraphrased approval = AUTOMATIC REJECTION
- Quick Reference updated with TOKEN NORMALIZATION block + V-12
- Origin: Colony OS Token Normalization Rule — loose approvals caused Ants to proceed through unintended gates
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.6.0] 2026-02-24
- Section 12b: FEATURE IMPACT ANALYSIS — mandatory FOOTPRINT + VERIFY requirements
- FOOTPRINT: Feature Impact table (feature, current state, after task, impact level, override needed)
- Impact levels: ✅ NONE, 🟡 REDUCED, 🟠 RELOCATED, 🔴 REMOVAL
- VERIFY: Feature Inventory table (files/exports before vs after, delta, status)
- Negative delta without `🔑 FEATURE REMOVAL OVERRIDE` triggers S-29 STOP
- S-29 → S-31: Feature count decreased, non-existence claim without evidence, scope contraction
- V-11: FEATURE REMOVAL WITHOUT OVERRIDE — auto-rejection for deleting protected features
- `🔑 FEATURE REMOVAL OVERRIDE: <feature>` token added to override vocabulary
- State Ownership: FOOTPRINT gains "feature impact analysis", VERIFY gains "feature inventory"
- Quick Reference updated with Feature Impact, V-11, S-29→S-31
- Cross-reference: Protected Features defined in NEO-SURGICAL.md v1.2.0 Section 6b
- Origin: CODE_ONLY classification allowed 3,288-line feature deletion with no safety net
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.5.0] 2026-02-11
- PROJECT LOCK enforcement: S-25 (outside lock), S-26 (no checkpoint), S-27 (outside scope), S-28 (wrong project)
- V-10 PROJECT LOCK VIOLATION: file access outside locked project root — auto-reject + compliance fail
- Quick Reference: PROJECT LOCK + CHECKPOINT FIRST sections added
- Quick Reference: S-25→S-28 range added, V-10 added to violations list
- Cross-reference: PROJECT LOCK defined in NEO-BECCA.md v1.7.0, CHECKPOINT defined in NEO-ANT.md v1.9.0
- ALL additions are MANUAL ONLY — no automation

### [1.4.0] 2026-02-11
- LAB state added to pipeline (optional, before DISCOVERY, 🎨 Color Expert Ant only)
- LAB has NO gate — it's experimentation, not committed work
- LAB output (Lab Proof Pack) feeds into DISCOVERY as evidence
- State Ownership table: LAB row added
- Pipeline diagram updated with LAB
- Section 8.1 Risk Levels: Color Expert Ant added to 🔴 HIGH
- Quick Reference updated with LAB state and Color Expert
- ALL additions are MANUAL ONLY — no automation

### [1.3.0] 2026-02-10
- Section 1: BACKUP state added to pipeline (conditional, between FOOTPRINT and PATCH)
- Section 2: BACKUP state ownership (Ant, create+document+verify backup)
- Section 3.2: `🔑 BACKUP APPROVED` token added
- Section 4: Skip BACKUP invalid transition (when data ops present)
- Section 5: STOP conditions S-19 → S-24 added (surgical protocol)
- Section 6: BACKUP row added to gate log
- Section 13.1: `🔑 BACKUP APPROVED` in pipeline tokens
- Section 13.2: `🔑 WIPE OVERRIDE: <collection>` in override tokens
- Section 14: V-09 BACKUP SKIP violation added
- Quick Reference updated with BACKUP gate, WIPE OVERRIDE, surgical protocol summary
- Cross-reference: All surgical rules defined in `NEO-SURGICAL.md` v1.0.0
- ALL additions are MANUAL ONLY — no automation

### [1.2.0] 2026-02-09
- Section 9: ⚫ NUCLEAR Severity (FROZEN) — above CRITICAL, no override, task BLOCKED
- Section 10: STOP MEANS STOP Doctrine (FROZEN) — acknowledge+continue = NON-COMPLIANT
- Section 11: Permission Hierarchy (L0-L3) — THINK ONLY → READ+VERIFY → WRITE+CHANGE → FORBIDDEN
- Section 12: Critical Surfaces — protected files require CRITICAL SURFACE OVERRIDE token
- Section 13: Guardian Control Words — complete token vocabulary (pipeline + override + rejection)
- Section 14: Violations Warning Box (FROZEN) — 8 named violations that auto-reject
- Section 5 expanded: 17 STOP conditions (up from 6) with severity ratings including ⚫ NUCLEAR
- New tokens: DISCOVERY APPROVED, DISCOVERY EXPANSION APPROVED, CRITICAL SURFACE OVERRIDE, CONTINUE, GO, ROLLBACK
- Quick Reference updated with all new systems
- ALL additions are MANUAL ONLY — no automation

### [1.1.0] 2026-02-09
- Added Section 8: Risk-Based Gate Behavior
- 4 risk levels (HIGH, MEDIUM, STANDARD, LOW) tied to 16 Ant Types
- HIGH risk gates require impact assessment, line-by-line review, domain tests
- MEDIUM risk gates require edge-case plan and validation tests
- Ghost review validates risk-specific requirements (Section 4b)
- Updated Quick Reference with risk-based gate summary

### [1.0.0] 2026-02-09
- Initial release
- Adapted from IAMBecca IAMBECCA-GATES.md v1.7.0
- Simplified to 3-role pipeline (Ant, Ghost, Inspector)
- 7 gate tokens, all human-issued
- Removed automation mode — manual-only
- Gate log for audit trail
- HALTED state for human intervention

## NEO-EVIDENCE
**Source:** `shared/NEO-EVIDENCE.md`


### [1.9.0] 2026-02-25
- Quick Reference header version corrected: v1.7.0 → v1.8.0 (now v1.9.0)

### [1.8.0] 2026-02-25
- Section 13.7: 2 new scope contraction euphemism patterns — "refactored/cleaned up/optimized" and "merged/deduplicated/unified"
- Cross-reference fix: "Section 10: HIVE CONTEXT" → "Section 11: HIVE CONTEXT" (correct numbering)
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.7.0] 2026-02-25
- Section 2: 7 new finding types — tenant isolation scan, secret scan, data classification, environment declaration, destructive op log, restore test, NUCLEAR incident report
- Section 5 (Ant checklist): 11 new SaaS safety checks (tenant, secrets, data classification, environment, production confirmation, destructive ops, restore test, PII)
- Section 5 (Ghost checklist): 12 new SaaS safety checks (tenant verification, secret scan, environment, production ops, data classification, destructive op log, restore test, PII leak, NUCLEAR HALT enforcement)
- Section 15: SAAS SAFETY EVIDENCE — tenant isolation evidence, environment gate evidence, audit trail evidence (destructive op log + restore test), secret & PII evidence
- Quick Reference: SAAS SAFETY block added (tenant, environment, secrets, PII, destructive ops, NUCLEAR HALT)
- Cross-reference: NEO-SURGICAL.md v1.4.0 Sections 11-15 (source of all SaaS safety rules)
- Cross-reference: NEO-GATES.md v1.9.0 (S-35 to S-37, V-13, new tokens)
- Origin: SaaS safety audit — no tenant isolation enforcement, no audit trail for destructive ops, no PII classification, no environment gate evidence
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.6.0] 2026-02-25
- Section 14: NEAREST TRUTH RULE — source priority hierarchy when information conflicts
- Priority: Code > Config/Rules > Operator Manual > Hive Mind Reports > External Docs
- CARDINAL RULE: If sources conflict, REPORT the conflict — do NOT silently pick a side
- Conflict Resolution Protocol: 5-step process (Identify, Cite Both, State Priority, Report, Wait)
- Common conflict scenarios table with correct actions
- THE STALE MANUAL TRAP: explicit warning based on Sonny feature deletion root cause
- Origin: Colony OS Nearest Truth Rule — Ants that silently resolve conflicts cause the worst bugs
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.5.0] 2026-02-24
- Section 2: New finding types — budget ledger, command proof, discovery strategy, truthy diffs
- Section 5 (Ant checklist): Discovery Strategy + Budget Ledger + Command Proof + Truthy Diffs evidence checks
- Section 5 (Ghost checklist): Budget Ledger spot-check, Command Proof verification, Truthy Diffs cross-check, Manual Currency
- Quick Reference: COLONY OS PROOF-FORCING EVIDENCE block added
- Origin: Colony OS comparison — these evidence types force proof at more steps, preventing self-attestation without verification
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.4.0] 2026-02-24
- Section 2: New finding types — feature impact, feature inventory, non-existence claim
- Section 5 (Ant checklist): Feature Impact + Feature Inventory + non-existence evidence checks
- Section 5 (Ghost checklist): Feature verification, independent non-existence check, scope contraction check
- Section 13.5: NON-EXISTENCE VERIFICATION — Ghost must independently verify "doesn't exist" claims
- Section 13.6: FEATURE PROTECTION EVIDENCE — evidence requirements for protected features
- Section 13.7: SCOPE CONTRACTION DETECTION — Ghost checks for euphemistic feature removal
- Euphemism detection: "consolidated," "simplified," "streamlined" flagged alongside "rebuilt," "recreated"
- Cross-reference: Protected Features defined in NEO-SURGICAL.md v1.2.0 Section 6b
- Cross-reference: Feature Impact Analysis defined in NEO-GATES.md v1.6.0 Section 12b
- Origin: Ghost reviewed documents but never verified non-existence claims or feature survival
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.3.0] 2026-02-10
- Section 2: New finding types — backup proof, dry-run result, data op classification, understanding proof
- Section 5: Ant checklist gains 4 surgical checks (understanding, data ops, backup, dry-run)
- Section 5: Ghost checklist gains 4 surgical checks (understanding, backup, anti-assumption, write semantics)
- Section 13: Surgical Protocol Evidence — LAW 1 understanding proof, LAW 2 backup proof, dry-run evidence, anti-assumption detection
- Quick Reference updated with surgical evidence summary
- Cross-reference: All surgical rules defined in `NEO-SURGICAL.md` v1.0.0
- ALL additions are MANUAL ONLY — no automation

### [1.2.0] 2026-02-10
- Section 12: Hive Mind Evidence Requirements — required evidence for Section 10: HIVE CONTEXT
- Hive context claims: previous tasks, file history, active pheromones, high-traffic flags, NUCLEAR clearance
- Ghost validation rules for hive context (spot-check 2 claims)
- Evidence budget exemption for hive mind greps (pre-DISCOVERY)
- ALL additions are MANUAL ONLY — no automation

### [1.1.0] 2026-02-09
- Section 8: Pheromone System — structured warning markers with 5 severity levels
- Section 9: Tenant Isolation Pheromones — TENANT_BOUNDARY, CROSS_TENANT_QUERY (⚫ NUCLEAR), TENANT_CONTEXT (🔴 HIGH), SHARED_COMPONENT (🟠 MEDIUM)
- Section 10: Evidence Budget (Anti-Drowning Protocol) — hard caps per state, two-pass workflow, one-question rule
- Updated Quick Reference with pheromone levels and evidence budget
- ALL additions are MANUAL ONLY — no automation

### [1.0.0] 2026-02-09
- Initial release
- Adapted from IAMBecca IAMBECCA-EVIDENCE.md v1.1.0
- Core evidence doctrine (frozen)
- Rejected patterns (placeholder paths, generic text, fabricated evidence)
- Evidence scoring rubric (5 dimensions)
- Role-specific checklists (Ant, Ghost, Inspector)
- Evidence categories and storage structure

## NEO-SURGICAL
**Source:** `shared/NEO-SURGICAL.md`


### [1.4.0] 2026-02-25
- SAAS DATA SAFETY: 5 new sections for production SaaS system protection
- Section 11: SECRET HANDLING — secret detection patterns, grep rules, where secrets belong, ⚫ NUCLEAR on exposure
- Section 12: TENANT ISOLATION ENFORCEMENT — mandatory scan in DISCOVERY, query scoping verification, breach = NUCLEAR
- Section 13: PII & PAYMENT DATA CLASSIFICATION — 4 data sensitivity tiers (T1 Restricted → T4 Public), PII handling rules for reports/code/backups
- Section 14: ENVIRONMENT GATE — TARGET_ENVIRONMENT mandatory in FOOTPRINT, 🔑 PRODUCTION CONFIRMED for destructive ops on prod, dry-run in emulator/staging required first
- Section 10b: SAFE FEATURE DEPRECATION PROTOCOL — 6-step checklist for intentional feature removal (inventory, dependency scan, data impact, user impact, FOOTPRINT, verify)
- Feature removal is ALWAYS its own task — never a side effect of bug fix, refactor, or cleanup
- Section 16: DESTRUCTIVE OPERATION REGISTRY — 10 operation types with required evidence and gates, DESTRUCTIVE OPERATION LOG format
- LAW 2 upgrade: Backup Scope Requirements table (minimum scope per task type)
- LAW 2 upgrade: Restore Test Protocol (mandatory for DATA_DELETE and MIGRATION — not attestation-only)
- Restore Test Proof format: test environment, records backed up/restored, sample verified, restore time, result
- Quick Reference: SAAS DATA SAFETY block added (secrets, tenant isolation, PII tiers, environment gate, destructive ops)
- New token: 🔑 PRODUCTION CONFIRMED (for prod destructive operations)
- Origin: SaaS safety audit — backups were attestation-only, no tenant isolation enforcement, no secret detection, no environment gate, PII unclassified
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.3.0] 2026-02-24
- DESKTOP BACKUP (Two-Layer Safety): HIGH risk tasks now require filesystem copy outside the repo
- Layer 1: Git checkpoint (standard, all Ants). Layer 2: Desktop copy to `<Desktop>/neo-backup/<TASK_ID>/`
- Desktop Backup Proof format (location, files, verified)
- Only applies to 🔴 HIGH risk (Fire Ant, Financial Ant, Color Expert Ant)
- 🟡🟢🟠 STANDARD/MEDIUM/LOW: Git checkpoint only (unchanged)
- Quick Reference updated with Desktop Backup block
- Origin: Colony OS Two-Layer Backup system — git can be lost to force-push; filesystem copy is the ultimate safety net
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.2.0] 2026-02-24
- Section 2b: ANTI-ASSUMPTION RULES FOR CODE FEATURES (FROZEN) — A-09 → A-14
- A-09: No removing features because they "seem unused"
- A-10: No replacing implementations in different file locations
- A-11: No deleting components/hooks/utilities outside task scope
- A-12: No claiming "doesn't exist" without grep evidence
- A-13: No "consolidating" by reducing feature count
- A-14: No reclassifying feature removal as "refactoring"
- Section 6b: PROTECTED FEATURES — code feature protection analogous to Protected Data Collections
- Protected Feature Registry: `.neo/PROTECTED_FEATURES.md` per project
- 3-file threshold: any 3+ related files = automatically protected
- Count before/after: file + export count verification at VERIFY
- Feature Removal Override Protocol: `🔑 FEATURE REMOVAL OVERRIDE: <Feature ID>`
- Feature Inventory table required in VERIFY section
- S-29: Feature file/export count decreased → STOP
- S-30: Non-existence claim without evidence → STOP
- S-31: Feature removed or disabled as side effect → STOP (scope contraction)
- Quick Reference updated with Protected Features + S-29→S-31
- Origin: Investigation revealed CODE_ONLY bypassed ALL data protections — features deleted with no safety net
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.1.0] 2026-02-11
- CHECKPOINT FIRST (FROZEN): Every Ant creates git checkpoint before ANY work
- Checkpoint Proof Format: project lock, HEAD hash, stash, branch, timestamp
- PROJECT ISOLATION (FROZEN): One project per run, no cross-project work
- Path Validation Rule: every file op must verify path is within locked root
- V-10 reference: PROJECT LOCK VIOLATION (defined in NEO-GATES.md v1.5.0)
- S-25→S-28 reference: project lock stops (defined in NEO-GATES.md v1.5.0)
- Quick Reference: CHECKPOINT FIRST + PROJECT LOCK sections added
- Section numbering: Quick Reference is now Section 11 (was 9)
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.0.0] 2026-02-10
- Initial release — Surgical Change Protocol
- LAW 1: NO-GUESS (understanding before action, 4-check proof table)
- LAW 2: BACKUP (mandatory for data operations, backup proof format, backup gate)
- LAW 3: SURGICAL (minimum delta, PATCH default, no rebuilds)
- Anti-Assumption Rules (A-01 → A-08, FROZEN)
- Data Operation Classification (7 types, FOOTPRINT table format)
- Write Semantics (PATCH/PUT/DELETE with defaults)
- Backup Gate (between FOOTPRINT and PATCH, conditional on data ops)
- Dry-Run Requirement (for destructive operations)
- Wipe Protection (protected patterns, demo/live separation)
- STOP Conditions (S-19 → S-24)
- Operator Manual reference
- ALL rules are MANUAL ONLY — NO AUTOMATION

## NEO-HIVE
**Source:** `shared/NEO-HIVE.md`


### [1.5.0] 2026-02-25
- LESSONS_INDEX: Added Usage Stats reinforcement fields (Used, Success, Failure) to entry format
- LESSONS_INDEX: Added Reinforcement Fields section explaining tracking rules and hit rate calculation
- LESSONS_INDEX: HIGH VALUE (>80% hit rate) and NOT HELPING (<30% hit rate) threshold rules
- LESSONS_INDEX: Updated examples with Usage Stats fields
- LESSONS_INDEX: Added high-value lesson search pattern
- REJECTION_INDEX: Added Rule Triggered field (S-NN / V-NN) to entry format
- REJECTION_INDEX: Added Stage field (DISCOVERY/FOOTPRINT/BACKUP/PATCH/VERIFY/REPORT)
- REJECTION_INDEX: Added Rule and Stage Fields explanation table
- REJECTION_INDEX: Updated examples with Rule Triggered + Stage fields
- REJECTION_INDEX: Added rule and stage search patterns
- Origin: Advisor spec — RLHF-style reinforcement for lessons + measurable rejection tracking
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.4.0] 2026-02-25
- Section 1 overview corrected: "four index files" → "six index files"

### [1.3.0] 2026-02-25
- Pheromone Resolution Protocol: explicit step-by-step for how Ants declare resolved pheromones
- Step 1: Find active pheromone during Hive Mind Check (DISCOVERY)
- Step 2: Fix the issue during PATCH (diff must address pheromone description)
- Step 3: Add "Pheromones Resolved" table in Ant Report Section 9 (PH-ID, original issue, how resolved, evidence)
- Step 4: BECCA CLOSE updates PHEROMONE_REGISTRY status from ACTIVE to RESOLVED_TASK-NNN
- Ghost verification: confirms Ant's claimed resolution actually fixes the original pheromone issue
- Cross-reference fix: Integration Points "Section 10: HIVE CONTEXT" → "Section 11: HIVE CONTEXT"
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.2.0] 2026-02-25
- REJECTION_INDEX: 5th index type — tracks all Ghost/Inspector rejections across runs
- 7 rejection categories: EVIDENCE, COMPLIANCE, SURGICAL, NUCLEAR, HIVE, QUALITY, DOD
- Rejection IDs: REJ-NNN (global sequential, never reused)
- 3 resolution statuses: FIXED_TASK-NNN, UNRESOLVED, DEFERRED
- Loops tracking: how many times a task was rejected before passing
- FINDINGS_INDEX: 6th index type — aggregates Ghost/Inspector findings across runs
- Finding types tracked with running counts (increment on each occurrence, not individual entries)
- 3 finding statuses: RECURRING (seen in last 3 runs), RESOLVED (absent 5+ runs), IMPROVING (50%+ drop)
- Threshold alerts: count >= 3 = FRAMEWORK SIGNAL, count >= 5 = PRIORITY FRAMEWORK SIGNAL
- BECCA CLOSE: steps 5-6 added — write REJECTION_INDEX + FINDINGS_INDEX
- Read/Write Contracts: 2 new columns (REJECTION_INDEX, FINDINGS_INDEX) + Prompt Architect row
- PHEROMONE TRIAGE: new RECON output — priority-sorted active pheromones with debt trend
- Priority rules: URGENT (NUCLEAR or >30d or >10 tasks), MODERATE (HIGH or >14d or >5 tasks), LOW
- Debt trend: net active pheromones per run over last 5 runs (GROWING/STABLE/SHRINKING)
- Index Health Check: expanded to 10 steps (was 7) — +rejection count, +recurring findings, +triage
- Health Report: 4 new metrics (total rejections, top rejection category, recurring findings, priority findings)
- Scale Projections: 2 new columns (REJECTION=1, FINDINGS=1 — no sharding)
- Section renumbering: 7→9 (Sharding), 8→10 (Contracts), 9→11 (Ant Check), 10→12 (Fingerprint), 11→13 (Pheromone), 12→14 (Health), 13→15 (Integration)
- Integration Points: +BECCA (rejection+finding writes, RUN_METRICS, triage), +Inspector (10-point audit), +Prompt Architect (rejection+finding mining)
- Origin: Framework audit — rejections and findings were scattered in individual review files with no pattern detection
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.1.0] 2026-02-25
- LESSONS_INDEX: 4th index type — lessons learned by domain, searchable by file path
- 7 domain shards: auth, payments, voice, data, ui, deploy, general (on demand)
- 6 lesson categories: WHAT_WORKED, GOTCHA, FRAGILE, APPROACH, VERIFICATION, PROTOCOL
- Lesson IDs: L-NNN (global sequential, never reused)
- Ant Hive Mind Check: step 5 added — search LESSONS_INDEX for target files
- Hive Mind Briefing: "Prior Lessons on Target Files" section added
- BECCA CLOSE: step 4 added — extract lessons from Ant Report Section 8, write to LESSONS_INDEX
- Read/Write Contracts: LESSONS_INDEX column added (Ant reads, Ghost validates, BECCA writes)
- Index Health Check: step 6 added — count total lessons
- Health Report: lessons stored count added
- Integration Points: updated for all 4 roles
- Scale Projections: LESSONS Shards column added
- Section renumbering: 7→8 (Contracts), 8→9 (Ant Check), 9→10 (Fingerprint), 10→11 (Pheromone), 11→12 (Health), 12→13 (Integration)
- Origin: Colony OS closed feedback loop — lessons from one Ant fed forward to next Ant on same files
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.0.0] 2026-02-10
- Initial release
- 3 index types: MASTER_INDEX, FILE_OWNERSHIP, PHEROMONE_REGISTRY
- Sharding strategy: 500/shard for MASTER, directory-based for FILE, severity-based for PHEROMONE
- Scale target: 10,000 ANTs per project
- Read/write contracts: BECCA writes all indexes during CLOSE
- Ant Hive Mind Check: mandatory at DISCOVERY start, NUCLEAR stop rule
- Fingerprint deduplication: SHA256 first 8 chars
- Pheromone lifecycle: EMITTED → INDEXED → READ → RESOLVED → ARCHIVED
- Index health check: BECCA runs during RECON
- 8 pheromone categories: ISOLATION, CREDENTIAL, SECURITY, VALIDATION, PERFORMANCE, DATA_INTEGRITY, DEPENDENCY, ARCHITECTURE
- 2 pheromone statuses: ACTIVE, RESOLVED_TASK-NNN
- ALL operations MANUAL ONLY — NO AUTOMATION

## NEO-TOOLS
**Source:** `shared/NEO-TOOLS.md`


### [1.10.0] 2026-02-27
- Section 6b: DEVTOOLS ANT TOOL PERMISSIONS — 3 new types (Sentinel, Perf, Network)
- Common permissions: full Chrome DevTools MCP read-only access (18 tools)
- Type-specific permissions table: which tools each type uses as PRIMARY
- FORBIDDEN rules: no file edits, no DOM mutation, no real payments, no state modification
- Output: all 3 types produce DEVTOOLS_REPORT (see templates/DEVTOOLS_REPORT.md)

### [1.9.0] 2026-02-25
- Section 4: DEBUGGER ANT COMPLETE LAB UPGRADE — full diagnostic toolkit
- Chrome DevTools MCP: take_snapshot, take_screenshot, list_console_messages, get_console_message, list_network_requests, get_network_request, evaluate_script, navigate_page, click, fill, press_key, hover, wait_for, list_pages, select_page, emulate, performance_start_trace
- Playwright MCP: full browser automation for bug reproduction (same tools as QA Ant)
- Sentry MCP: explicit READ access — issue search, error events, stack traces, breadcrumbs, Seer AI root cause analysis
- Firebase MCP: explicit READ access — Firestore queries, auth user lookup, Cloud Functions logs, Storage, Hosting
- Context7 MCP: explicit access — library documentation lookup
- CI/CD tools: explicit READ access — gh run list/view, vercel ls/logs
- Section 4a: DEBUGGER DIAGNOSTIC PROTOCOL — 5-phase workflow: REPRODUCE → OBSERVE → INVESTIGATE → DIAGNOSE → REPORT
- Section 4b: DEBUGGER STOP CONDITIONS — graceful degradation when MCPs unavailable
- FORBIDDEN expanded: Firebase write, Chrome DevTools DOM mutation via scripts
- Quick Reference updated: Debugger line expanded with lab tools, new DEBUGGER LAB block
- Playwright MCP Quick Reference: added Debugger Ant alongside QA Ant
- Origin: Debugger had code-reading + test-running only — couldn't see runtime state, reproduce bugs, check production errors, or inspect backend data
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.8.0] 2026-02-24
- Section 10: ERROR RECOVERY CHEAT SHEET — 12 common failure scenarios with recovery steps
- E-01→E-12: Build fail, test fail, CI/CD fail, lint errors, wrong file, git conflict, MCP down, budget exhausted, STOP triggered, bad data, prior work conflict
- Recovery Priority Order: Understand → Check causation → Fix → Rollback → Escalate
- "What NOT to Do" table: no @ts-ignore, no deleting tests, no --force, no scope expansion, no fabrication
- Quick Reference updated with Error Recovery block
- Section renumbered: Quick Reference 10→11
- Origin: Colony OS Error Recovery Cheat Sheet — Ants often improvise bad fixes instead of following recovery protocol
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.7.0] 2026-02-24
- Section 9b: PROTECTED FEATURE SURFACES — extends Critical Surfaces to code feature groups
- Protected Feature Surfaces protect groups of 3+ files implementing user-facing capabilities
- Comparison table: Critical Surface (single file, auth/deploy) vs Feature Surface (file group, capabilities)
- Role responsibilities: Ant (Feature Impact + Inventory), Ghost (independent count verification + non-existence verification), Inspector (V-11 audit)
- Enforcement: V-11 rejection for feature removal without `🔑 FEATURE REMOVAL OVERRIDE`
- Quick Reference updated with Protected Feature Surfaces block
- Cross-reference: NEO-SURGICAL.md v1.2.0 Section 6b, NEO-GATES.md v1.6.0 Section 12b
- Origin: Critical Surfaces protected individual sensitive files but had no mechanism for protecting feature groups
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.6.0] 2026-02-16
- Section 8: MCP DATA & DOCUMENTATION SERVERS — Firebase, Sentry, Context7
- Firebase MCP: Firestore queries, auth user lookup, Cloud Functions logs, Storage, Hosting
- Uses existing Firebase CLI auth (no extra token needed)
- Sentry MCP: issue search, error events, stack traces, releases, Seer AI analysis
- Remote server at https://mcp.sentry.dev/mcp with OAuth (browser login)
- Context7 MCP: up-to-date library documentation for any framework/library
- Prevents hallucinated API calls by fetching current docs
- Permission matrix: all roles READ, only Ant writes (Firebase, with approval)
- "When to Use" table for each server with concrete examples
- STOP conditions for each server (auth, project selection, API key)
- MCP config in ~/.claude/mcp.json (6 servers total: figma x2, playwright, firebase, sentry, context7)
- Critical Surface sections renumbered: 8→9. Quick Reference: 9→10
- Quick Reference updated with MCP Data Servers block

### [1.5.0] 2026-02-16
- Section 7: CI/CD VERIFICATION TOOLS — MANDATORY at VERIFY for all Ants
- GitHub Actions: `gh run list`, `gh run view`, `gh run view --log-failed`
- Vercel: `vercel ls --yes`, `vercel inspect`, `vercel logs`
- CI/CD Check Protocol: 5-step mandatory process after every push
- All roles can READ CI/CD status. Only Ants can push code.
- ANT_REPORT Section 5 must include CI/CD status table
- If CI/CD fails: Ant must READ logs, FIX issue, re-push, verify green
- Origin: Ants reporting "everything went well" while Vercel/GitHub Actions showed failures
- Critical Surface sections renumbered: 7→8. Quick Reference: 8→9
- Quick Reference updated with CI/CD verification block

### [1.4.0] 2026-02-16
- Section 6: QA ANT TOOL PERMISSIONS — 🔍 QA Ant (read-only + Playwright MCP)
- QA Ant: same file permissions as Debugger Ant + full Playwright MCP browser automation
- Playwright MCP tools: browser_navigate, browser_click, browser_type, browser_screenshot, browser_snapshot, browser_console_messages, browser_network_requests, etc.
- Section 6b: PLAYWRIGHT FOR ALL ANTS — optional Playwright at VERIFY step for builder Ants
- Any builder Ant can use Playwright MCP during VERIFY for UI/API feature verification
- Playwright MCP server: Microsoft's official @playwright/mcp (uses a11y tree, opens visible Chromium)
- Setup: already in ~/.claude/mcp.json — `npx -y @playwright/mcp@latest`
- STOP conditions: MCP unavailable, app not running, auth required
- Critical Surface sections renumbered 6→7
- Quick Reference section renumbered 7→8
- Quick Reference updated with QA Ant + Playwright MCP section
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.3.0] 2026-02-12
- Section 5 UPDATED: DUAL-SERVER Figma setup (matching IAMBecca architecture)
- Server 1: figma-official — Figma's remote MCP server (https://mcp.figma.com/mcp)
  - HTTP transport with OAuth (browser login, no API token)
  - 11 tools: get_design_context, get_variable_defs, get_code_connect_map,
    add_code_connect_map, get_screenshot, create_design_system_rules,
    get_metadata, get_figjam, whoami, get_code_connect_suggestions,
    send_code_connect_mappings
- Server 2: figma-edit — Claude Talk to Figma WebSocket bridge (unchanged from 1.2.1)
- MCP config updated: both servers in `~/.claude/mcp.json`
- Setup sections split: Server 1 (remote, no setup) + Server 2 (WebSocket + plugin)
- Quick Reference updated with dual-server layout
- ALL additions are MANUAL ONLY — no automation

### [1.2.1] 2026-02-12
- Section 5 UPDATED: Figma MCP tools corrected — TWO-WAY bridge (not read-only)
- Uses Claude Talk to Figma plugin (WebSocket bridge on port 3055)
- 4 tool categories: READ (11 tools), CREATE (12 tools), MODIFY (10 tools), TEXT (12 tools)
- Full tool list: join_channel, get_document_info, get_node_info, get_styles, get_components,
  create_frame, create_rectangle, create_text, set_fill_color, set_auto_layout, etc.
- Setup: WebSocket server + Figma plugin + channel ID (no API token needed)
- MCP config: `claude mcp add -s user ClaudeTalkToFigma` or `.mcp.json`
- STOP conditions: server not running, plugin not connected, channel join failed
- Quick Reference updated with two-way tool categories
- ALL additions are MANUAL ONLY — no automation

### [1.2.0] 2026-02-12
- Section 5: Figma Ant Tool Permissions — initial version (read-only, corrected in 1.2.1)
- Chrome DevTools MCP access for live UI comparison (screenshot, snapshot, evaluate)
- Critical Surface sections renumbered 5→6
- Quick Reference section renumbered 6→7
- ALL additions are MANUAL ONLY — no automation

### [1.1.0] 2026-02-09
- Section 4: Debugger Ant tool permissions (read-only, same as Ghost)
- Section 5: Critical Surface Protections — auth, data, deploy, env, tenant isolation
- Section 5.4: Multi-Tenant Critical Surfaces — tenant middleware, data access, API boundary
- Section 5.5: Project-Specific Configuration — `.neo/CRITICAL_SURFACES.md`
- Updated Quick Reference with Debugger Ant and critical surfaces
- ALL additions are MANUAL ONLY — no automation

### [1.0.0] 2026-02-09
- Initial release
- Adapted from IAMBecca IAMBECCA-TOOLS.md v2.1.0
- Simplified 3-role permission matrix
- ✅ Full / 🔒 Read-Only / ❌ Forbidden system
- Per-role tool authority blocks
- Violation detection and response

## NEO-OUTPUTS
**Source:** `shared/NEO-OUTPUTS.md`


### [1.12.0] 2026-02-27
- CDEX: Card-Deck Execution System — CARD_RECEIPT mandatory in every agent output
- Section 1b: CDEX overview (3 card layers, Sentry Gate, Ghost Gate, self-healing)
- Universal Output Skeleton: CARD RECEIPT added as mandatory section
- Quick Reference: +CARD RECEIPT, +CDEX section
- Missing CARD_RECEIPT = OUTPUT_INVALID: CARD_COMPLIANCE_FAILED
- CARD_WAIVER protocol for controlled card skipping
- "If it isn't on a card, it didn't happen." / "If it didn't produce a receipt, it isn't accepted."
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.11.0] 2026-02-25
- Ant type count corrected: "12 Ant Types" → "16 Ant Types" in task packet metadata
- Ghost Review required sections table: added Section 6 (Nuclear & Pheromone Audit), renumbered 7→Findings, 8→Verdict & Handoff

### [1.10.0] 2026-02-25
- Section 7: TEST_REPORT EXPANDED — Debugger Ant complete lab upgrade
- NEW Section 2: Environment Snapshot — Node/npm versions, framework, browser, OS, Firebase project, Sentry DSN
- NEW Section 3: Reproduction Steps — exact steps to trigger bug + evidence table (screenshot, console, network, Sentry)
- Section 6 EXPANDED: Runtime Observations table — console, network, DOM state, performance, Sentry, Firebase logs
- Section 9 EXPANDED: Evidence Index now includes Source column (DevTools, Playwright, Sentry, Firebase, etc.)
- Section 11 EXPANDED: Handoff includes diagnostic tools used
- Section count: 8 → 11 (renumbered: old 2→4, old 3→5, old 4→6, old 5→7, old 6→8, old 7→9, old 8→10, old 9→11)
- Detailed explanations for each new/expanded section in NEO-OUTPUTS
- Cross-reference: NEO-TOOLS.md v1.9.0 Section 4 (Debugger Lab), templates/TEST_REPORT.md
- Origin: Debugger only had code-level inspection — couldn't capture runtime state, reproduce bugs, or trace production errors
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.9.0] 2026-02-24
- NEW Section 7h: DISCOVERY STRATEGY OUTPUT — ONE QUESTION + first file + search plan format
- NEW Section 7i: BUDGET LEDGER OUTPUT — resource tracking table (files/lines/greps, ✅/⚠️/🛑 status)
- NEW Section 7j: TRUTHY DIFFS OUTPUT — 7-step pre-commit checklist with evidence per check
- 4 new rejection triggers: missing Discovery Strategy, Budget Ledger, Truthy Diffs, Command Proof
- Quick Reference updated with PROOF-FORCING OUTPUTS block
- Origin: Colony OS comparison — Budget Ledger, One-Question Rule, Truthy Diffs all proven in Colony OS v1.3.22
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.8.0] 2026-02-11
- NEW Section 7g: Color Expert Output Requirements — specialized formats for 🎨 Color Expert Ant
- Lab Proof Pack format (validation surface, modes, golden pages, issues)
- Prescription format (element, mode, source, precedence, ratios, change, blast radius, rollback)
- CSS Precedence Proof format (computed styles evidence)
- Color Fix Applied format (files, change, proof, rollback)
- THEME_COLORS pheromone format (MEDIUM for theme files, HIGH for main theme)
- Max 3 changes per run enforced in output contract
- Quick Reference updated with Color Expert section
- ALL additions are MANUAL ONLY — no automation

### [1.7.0] 2026-02-10
- NEW Section 13: PROMPT FEEDBACK — system self-improvement loop from Colony OS
- 4 feedback categories: clarity issues, missing rules, false positives, suggestions
- Section 7f: Prompt Feedback output format specification with examples
- Ant Report gains Section 13 (no renumbering — appended after Handoff)
- Rejection trigger: missing PROMPT FEEDBACK section = auto REJECT
- Prompt Feedback does NOT affect task PASS/FAIL verdict
- BECCA aggregates: 3+ Ants same issue = priority protocol fix
- Quick Reference: PROMPT FEEDBACK requirement added
- ALL additions are MANUAL ONLY — no automation

### [1.6.0] 2026-02-10
- NEW Section 8: LESSONS FOR FUTURE ANTS — knowledge transfer from Colony OS
- 5 lesson categories: what worked, fragile/surprising, approach advice, verification pattern, protocol tip
- Section 7e: Lessons output format specification with examples
- Ant Report renumbered: Risks=9 (was 8), Gate Log=10 (was 9), Hive Context=11 (was 10), Handoff=12 (was 11)
- Ghost Review reference updated: "Section 11 present" (was Section 10)
- Rejection trigger: missing LESSONS section = auto REJECT
- Rejection trigger: HIVE CONTEXT now Section 11 (was 10)
- Quick Reference: Gate Log reference updated to Section 10, LESSONS requirement added
- ALL additions are MANUAL ONLY — no automation

### [1.5.0] 2026-02-10
- Section numbering alignment: Ant Report now uses Header (unnumbered) + Sections 1–11
- Previously: Header was Section 1, sections ran 1–12. Now matches template numbering.
- All section references updated: Hive Context = Section 10 (was 11), Handoff = Section 11 (was 12)
- Rejection trigger updated: "Section 10 required" (was Section 11)
- Ghost Review reference updated: "Section 10 present" (was Section 11)
- Quick Reference updated with aligned section numbers
- NO functional changes — numbering alignment only

### [1.4.0] 2026-02-10
- Surgical Protocol outputs: Section 7d (Understanding Proof, Data Op Classification, Backup Proof formats)
- Ant Report Section 3: Understanding Proof added to Discovery Findings purpose
- Ant Report Section 4: Data Op Classification table added to Footprint purpose
- Ant Report Section 4b: NEW — Backup Proof (conditional, LAW 2)
- Ant Report Section 10: BACKUP gate noted in Gate Log
- Ghost Review Section 5c: NEW — Surgical Protocol Compliance
- Gate Log: BACKUP gate documented as conditional entry
- File tree: backup_proof.txt evidence path + OPERATOR_MANUAL added
- 5 new rejection triggers: understanding proof, data op classification, backup proof, BACKUP token, write semantics
- Quick Reference updated with surgical protocol summary
- ALL additions are MANUAL ONLY — no automation

### [1.3.0] 2026-02-10
- Ant Report Section 10: HIVE CONTEXT added (previous tasks, pheromones, traffic per file)
- Ant Report renumbered: Handoff is now Section 11 (was 10)
- Ghost Review Section 5b: Hive Mind Compliance added
- Project file paths: .neo/index/ directory added
- New rejection trigger: missing HIVE CONTEXT section
- Index output files documented in file path tree
- Updated Quick Reference version
- ALL additions are MANUAL ONLY — no automation

### [1.2.0] 2026-02-09
- Section 7: Debugger Test Report (TEST_REPORT) — diagnostic output for 🐛 Debugger Ant
- Section 7b: Snapshot Summary — required 5-line summary at end of DISCOVERY
- Section 7c: Pheromone Output Format — structured warning markers in reports
- New rejection triggers: missing snapshot summary, missing pheromone section, untagged NUCLEAR, critical surface without override
- Updated Quick Reference with new output types and requirements
- ALL additions are MANUAL ONLY — no automation

### [1.1.0] 2026-02-09
- Added Ant Type as required field in Task Packet and Ant Report header
- Ghost Review gains Section 4b: Ant Type Validation (type match + risk requirements)
- New rejection triggers: missing ANT_TYPE, missing risk-level requirements
- Updated all section tables with Ant Type references

### [1.0.0] 2026-02-09
- Initial release
- Adapted from IAMBecca IAMBECCA-OUTPUTS.md v1.5.0
- Universal output skeleton
- 5 output types: Ant Report, Ghost Review, Inspector Report, Task Packet, Gate Log
- Rejection triggers for missing fields

## NEO-ACTIVATION
**Source:** `shared/NEO-ACTIVATION.md`


### [1.7.0] 2026-02-27
- RESPONSE BOUNDARY PROTOCOL: new Section 0 (highest priority, read first)
- One gate per response rule: response MUST END after each gate output
- Gate checkpoint table: exact ⏸️ prompts for all roles (BECCA, Ant, Ghost, Inspector)
- Self-test: two gate outputs in one response = protocol violation
- Role boundaries enforced: BECCA no Edit/Write, Ghost/Inspector no fix, one task per Ant
- ROOT CAUSE: prior runs showed Claude skipping ALL gates — producing one massive response
  from RECON through coding with zero operator approval. This section enforces stop points.
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.6.0] 2026-02-25
- Strike 3 Decision Matrix: 6-signal table for BECCA choosing DEBUGGER vs SPLIT vs RE-ASSIGN
- Signals: same deficiency repeated, different deficiency each loop, scope too large, 5+ files/3+ dirs, wrong Ant type, type-category mismatch
- Tie-breaker rule: if multiple signals match, prefer DEBUGGER (diagnosis before action)
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.5.0] 2026-02-25
- STRIKE 3 DEBUGGER ESCALATION: replaces old "operator review recommended" at loop 3
- Loop Tracking section: added Strike 3 table (loop 1–2 = retry, loop 3 = escalate)
- 3 escalation decisions: DEBUGGER (root cause diagnosis), SPLIT (scope too large), RE-ASSIGN (wrong Ant type)
- Strike 3 flow diagram: Ant fails → Ghost STRIKE 3 prompt → BECCA reactivates → decides action
- Ant does NOT retry a 4th time — diagnosis before more fix attempts
- Quick Reference: "MAX LOOPS: 3 per task" replaced with STRIKE 3 escalation block
- Origin: old rule just warned operator at loop 3 — no structured escalation path

### [1.4.0] 2026-02-11
- PROJECT LOCK binding (FROZEN): every role activated via "I AM" inherits the locked project root
- Lock set by BECCA during RECON, persists through CLOSE, only new "deep dive" creates new lock
- Ant activation response: now shows CHECKPOINT state, PROJECT LOCK, and scope
- BECCA activation response: now mentions PROJECT LOCK will be set after RECON
- Quick Reference: PROJECT LOCK + CHECKPOINT FIRST sections added
- Cross-reference: V-10 (project lock violation) in NEO-GATES.md v1.5.0
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.3.0] 2026-02-10
- Hive Mind: .neo/index/ directory added to project file paths
- STATE.md: now tracks Last Pheromone ID (PH-NNN)
- BECCA CLOSE: now updates HIVE indexes alongside STATE.md and RUN_INDEX.md
- Quick Reference: HIVE line added, CLOSE updates list updated
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.2.0] 2026-02-09
- RUN_INDEX.md: BECCA's institutional memory — one entry per completed run
- BECCA CLOSE protocol: step 5 appends run summary to RUN_INDEX.md
- BECCA CLOSE output: mentions "Run index updated"
- Section 9: added .neo/RUN_INDEX.md format alongside STATE.md
- Quick Reference: added INDEX line + CLOSE updates list
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.1.0] 2026-02-09
- BECCA orchestration: everything starts and ends with BECCA
- BECCA RECON: checks .neo/STATE.md, prior TODOs, last task ID, run counter
- BECCA SCOUT dispatch: "I AM" → 🚁 Scout surveys project → creates TODO
- BECCA VERIFY: final regression check — did any Ant break previous Ant's work?
- BECCA CLOSE: archives TODO, updates STATE.md, signs off on run
- Task ID continuity: global per project, never reset, tracked in STATE.md
- .neo/STATE.md format: last run, last task ID, status
- Updated pipeline flow diagram to show BECCA at both ends
- BECCA activation response added to Section 7
- Updated Quick Reference with full BECCA-bookended flow
- ALL transitions are MANUAL ONLY — NO AUTOMATION

### [1.0.0] 2026-02-09
- Initial release
- "I AM" protocol: universal role activation trigger
- Tactical TODO: shared coordination document per project
- Pipeline flow: Ant → Ghost → Inspector per task
- Rejection loops: Ghost/Inspector reject → back to Ant (max 3 loops)
- Same-chat rules: one role at a time, TODO is single source of truth
- Cross-session continuity: TODO persists, new session reads where left off
- Archival protocol: all tasks done → move TODO to archive/
- TODO update rules: status icons, who writes what, chat-first/file-second
- Operator commands: I AM, SKIP INSPECTOR, SKIP GHOST, PAUSE, ABORT
- Inspired by IAMBecca ACTIVATION (packets), QUEUE (distribution), LEDGER (logging)
- ALL transitions are MANUAL ONLY — NO AUTOMATION

## NEO-FIVE-HORSEMEN
**Source:** `shared/NEO-FIVE-HORSEMEN.md`


### [1.0.0] 2026-02-12
- Initial release — adapted from Colony OS Five Horsemen Protocol v1.0.0
- 5 catastrophic failure modes: Hallucination, Amnesia, Drift, Privilege Creep, Silent Failure
- Detection signals and checklist items for each
- Templates for Ant self-check, Ghost review, Inspector audit
- NEO pipeline state mapping
- ALL additions are MANUAL ONLY — no automation

## NEO-HIVEMIND-GLOBAL
**Source:** `shared/NEO-HIVEMIND-GLOBAL.md`


### [1.2.0] 2026-02-25
- Structured Staleness Detection: 3-step protocol with exact grep commands
- Step 1: Pheromone reference scan with structured results table (ID, last referenced, run count, projects, status)
- Step 2: Anti-pattern/safe pattern technology verification with grep examples
- Step 3: Cross-colony lesson framework version checking
- GLOBAL HIVEMIND HEALTH: structured RECON output table (category breakdown + stale candidates with recommendations)
- Origin: staleness check was manual prose — now has exact commands and structured output tables
- ALL additions are MANUAL ONLY — NO AUTOMATION

### [1.1.0] 2026-02-25
- Entry Lifecycle & Deprecation: ACTIVE → STALE → DEPRECATED lifecycle
- Staleness Detection: BECCA RECON checks entries against last 5 runs
- Deprecation Rules: 4 conditions for when to deprecate
- Deprecation Format: strikethrough + reason + successor reference
- RECON output: global hivemind staleness section added
- NUCLEAR entries exempt from auto-deprecation (operator-only)
- Deprecated entries stay for historical context, Ants skip them
- Origin: entries accumulated indefinitely with no retirement process

### [1.0.0] 2026-02-12
- Initial release: cross-project pheromones, anti-patterns, safe patterns, lessons
