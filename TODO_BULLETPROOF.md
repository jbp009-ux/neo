# TODO: Make NEO Bulletproof — 3 Gap Fixes

**Created:** 2026-02-12
**Context:** User identified the NEO system is near-bulletproof but has 3 fixable gaps.
**Status:** ✅ COMPLETE — All 3 gaps implemented 2026-02-12

---

## Background

The NEO Pipeline (Manual → Ant → Ghost → Inspector → BECCA) has a 5-checkpoint chain that is bulletproof against code-level mistakes. Three gaps remain to make it bulletproof **end-to-end**.

All research is complete. The full NEO structure has been audited. Implementation locations are mapped.

---

## GAP 1: Cross-Project Hive Mind

**Problem:** Sonny's Hive Mind and RIZEND's Hive Mind are isolated. Same mistake can happen in both projects because learnings don't transfer.

**Solution:** Create a shared `HIVEMIND_GLOBAL.md` in the NEO source repo.

### Implementation

**CREATE:** `d:\projects\neo\shared\NEO-HIVEMIND-GLOBAL.md`

Contents:
- Cross-project pheromones (patterns that apply to ALL projects)
- Common anti-patterns discovered across colonies
- Shared safe operation patterns
- Cross-project lesson log (append-only)

Format:
```markdown
## Cross-Project Pheromones
| ID | Source Project | Category | Pattern | Severity |
|----|---------------|----------|---------|----------|

## Universal Anti-Patterns
| # | Anti-Pattern | Why | First Seen |
|---|-------------|-----|-----------|

## Universal Safe Patterns
| # | Pattern | Why | Applies To |
|---|---------|-----|-----------|

## Cross-Colony Lessons
| Date | Source | Lesson |
|------|--------|--------|
```

**MODIFY:** `d:\projects\neo\roles\NEO-BECCA.md`
- In CLOSE step, after writing to project Hive Mind indexes:
- Add step: "Check if any HIGH/NUCLEAR pheromones or lessons have cross-project relevance"
- If yes: append to `shared/NEO-HIVEMIND-GLOBAL.md`
- Location: After current CLOSE step 7 (Operator Manual Update), before step 8

**MODIFY:** `d:\projects\neo\roles\NEO-ANT.md`
- In DISCOVERY step 0 (HIVE MIND CHECK):
- Add: "Also read `shared/NEO-HIVEMIND-GLOBAL.md` for cross-project patterns"
- Location: Lines ~290-310 (DISCOVERY section, Hive Mind check)

**MODIFY:** `d:\projects\neo\scripts\neo-init.ps1` and `neo-refresh.ps1`
- Ensure `NEO-HIVEMIND-GLOBAL.md` is copied/synced to project `.neo/shared/`

---

## GAP 2: Ghost Verification Layer (Test Runner Step)

**Problem:** Ghost checks that evidence EXISTS and LOOKS real, but can't re-run code to confirm evidence IS real.

**Solution:** Add a verification sub-step to Ghost's Index 8 review that requests test re-execution when evidence includes test results.

### Implementation

**MODIFY:** `d:\projects\neo\roles\NEO-GHOST.md`

Add **Section 4b: EVIDENCE RE-EXECUTION** (between Section 4 and Section 5):

```markdown
### Section 4b: EVIDENCE RE-EXECUTION (Conditional)

**Triggered when:** Ant report includes test results, build output, or lint results in evidence.
**Skipped when:** Task is documentation-only (Leafcutter), research-only (Scout), or planning-only (Board).

Procedure:
1. Identify all test/build/lint commands referenced in Ant's VERIFY section
2. Request operator to re-run: "VERIFY RE-RUN: `<command>` — confirm output matches?"
3. If operator confirms match → PASS
4. If operator reports mismatch → Evidence score drops to 0% → AUTO REJECT
5. If operator skips (timeout/decline) → Flag as UNVERIFIED in findings, does NOT auto-reject

| Command | Ant's Claimed Result | Re-Run Result | Match? |
|---------|---------------------|---------------|--------|
```

**MODIFY:** `d:\projects\neo\templates\GHOST_REVIEW.md`
- Add Section 4b template between Section 4 and Section 5
- Add UNVERIFIED finding type to Section 7 severity options

**MODIFY:** `d:\projects\neo\roles\NEO-GHOST.md` Section Index table
- Update numbering: Sections remain 1-8, but Section 4 gains subsection 4b
- Add to Section Index: `4b | EVIDENCE RE-EXECUTION | Test/build re-run verification | YES: mismatch = 0% score`

---

## GAP 3: Manual Drift Detection (Audit Ant)

**Problem:** If someone edits code outside NEO (direct commits, hotfixes), the Operator Manual silently drifts from reality.

**Solution:** Add an 8th Inspector inspection type called MANUAL_DRIFT that audits the Operator Manual against the actual codebase.

### Implementation

**MODIFY:** `d:\projects\neo\roles\NEO-INSPECTOR.md`

Add 8th inspection type: **MANUAL_DRIFT** (after SURGICAL):

```markdown
### 8. MANUAL_DRIFT (Lines TBD)

**Purpose:** Detect drift between Operator Manual and actual codebase.
**Triggered:** Manually by operator OR automatically by BECCA during RECON if >5 runs since last drift audit.

Checks:
1. Function count in manual/FUNCTIONS.md matches actual exports
2. Collection names in manual/SCHEMA.md exist in firestore.rules
3. Route count in manual/FRONTEND.md matches actual page.tsx files
4. Env vars in manual/ENVIRONMENT.md match .env.example/.env.template
5. Test file count in manual/TESTS.md matches actual test files
6. Middleware list in manual/MIDDLEWARE.md matches actual middleware exports
7. Service integrations in manual/SERVICES.md match actual adapter imports
8. Danger Zone files in core manual still exist at listed paths
9. KIP patterns in core manual still present in codebase
10. Nuclear Invariants haven't been violated by untracked changes

Output format:
| Check | Manual Says | Codebase Says | Status |
|-------|------------|---------------|--------|
| Function count | 94 | 97 | DRIFT ⚠️ |
| Collection count | 63 | 63 | OK ✅ |

If ANY DRIFT found:
- Emit MEDIUM pheromone: "Manual drift detected: <detail>"
- BECCA auto-dispatches Leafcutter to fix
```

**MODIFY:** `d:\projects\neo\roles\NEO-BECCA.md`

In RECON phase, add drift detection trigger:
```
After reading RUN_INDEX, check:
- Count runs since last MANUAL_DRIFT inspection (search Inspector reports)
- If >= 5 runs since last drift audit → auto-queue MANUAL_DRIFT inspection
- If 0 runs (first run) → skip
```

**CREATE:** `d:\projects\neo\templates\MANUAL_DRIFT_REPORT.md`
- Template for the 10-check drift audit report
- Includes: check name, manual value, codebase value, status, evidence

---

## File Change Summary

### CREATE (3 files)
| File | Purpose |
|------|---------|
| `shared/NEO-HIVEMIND-GLOBAL.md` | Cross-project shared knowledge |
| `templates/MANUAL_DRIFT_REPORT.md` | Drift audit report template |
| (Section 4b added to existing GHOST_REVIEW.md template) | — |

### MODIFY (7 files)
| File | Change |
|------|--------|
| `roles/NEO-BECCA.md` | Add CLOSE step for global hivemind + RECON drift trigger |
| `roles/NEO-ANT.md` | Add DISCOVERY step to read global hivemind |
| `roles/NEO-GHOST.md` | Add Section 4b (Evidence Re-Execution) |
| `roles/NEO-INSPECTOR.md` | Add 8th inspection type (MANUAL_DRIFT) |
| `templates/GHOST_REVIEW.md` | Add Section 4b template |
| `scripts/neo-init.ps1` | Include NEO-HIVEMIND-GLOBAL.md in project init |
| `scripts/neo-refresh.ps1` | Include NEO-HIVEMIND-GLOBAL.md in project sync |

---

## Implementation Order

1. **Gap 1 first** (Cross-Project Hive Mind) — simplest, standalone file + small edits
2. **Gap 3 second** (Manual Drift Detection) — Inspector addition + BECCA trigger
3. **Gap 2 last** (Ghost Verification) — most delicate, touches the review pipeline

---

## Version Bumps After Implementation

| File | Current | New |
|------|---------|-----|
| `NEO-BECCA.md` | v1.7.0 | v1.8.0 |
| `NEO-ANT.md` | v1.9.0 | v1.10.0 |
| `NEO-GHOST.md` | v1.8.0 | v1.9.0 |
| `NEO-INSPECTOR.md` | v1.4.0 | v1.5.0 |

---

## DONE Criteria

All 3 gaps closed when:
- [x] Ant reads global hivemind during DISCOVERY (step 0e in NEO-ANT v1.10.0)
- [x] BECCA writes cross-project lessons during CLOSE (step 8 in NEO-BECCA v1.8.0)
- [x] BECCA reads global hivemind during RECON (step 3f in NEO-BECCA v1.8.0)
- [x] BECCA auto-triggers drift audit every 5 runs (step 3e in NEO-BECCA v1.8.0)
- [x] Ghost re-executes test evidence (Section 4b in NEO-GHOST v1.9.0)
- [x] Inspector has MANUAL_DRIFT inspection type (NEO-INSPECTOR v1.5.0)
- [x] MANUAL_DRIFT_REPORT template created (templates/MANUAL_DRIFT_REPORT.md)
- [x] NEO-HIVEMIND-GLOBAL.md created with seed data (shared/NEO-HIVEMIND-GLOBAL.md)
- [x] Version bumps applied (BECCA 1.8.0, ANT 1.10.0, GHOST 1.9.0, INSPECTOR 1.5.0)
- [x] Scripts already sync shared/ and templates/ — no changes needed
- [x] neo-refresh.ps1 run on Sonny (20 files, 3 new) + RIZEND (29 files, 25 new)
