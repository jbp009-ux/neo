# NEO-FIVE-HORSEMEN v1.0.0
## The Five Catastrophic Failure Modes

**Purpose:** Structured failure detection checklist for Ghost and Inspector
**Scope:** Loaded by Ghost (review checklist) and Inspector (audit checklist)
**Origin:** Adapted from Colony OS Five Horsemen Protocol v1.0.0

---

## PURPOSE

Five catastrophic failure modes that compromise system integrity. Every Ant report, every Ghost review, every Inspector audit MUST check for all five. If any Horseman is undefeated, the verdict is FAIL.

**Core Principle:** Proof > Vibes. Zero Trust. Claims without evidence are hallucinations.

---

## THE FIVE HORSEMEN

### H1: HALLUCINATION
**Definition:** Claims made without evidence. "It works" without proof.

**Detection Signals:**
- Report says "done/fixed/complete" without file paths or diffs
- No commit hash referenced
- No terminal output (build, test, lint) included
- "Verified" but no verification output pasted
- Claims about behavior with no screenshot or console evidence

**What Ghost/Inspector Checks:**
- [ ] Every claim has at least ONE artifact (file path, diff, terminal output, screenshot)
- [ ] Build output is included (not just "build passes")
- [ ] Test output is included (not just "tests pass")
- [ ] Diffs are real (file paths exist, line numbers match)

**Required Proof Per Claim:**

| Claim | Required Proof |
|-------|----------------|
| Bug fix | Diff + test output showing fix |
| Feature complete | Build pass output + functional verification |
| Security change | Security test output |
| UI change | Screenshot or DevTools snapshot |
| Performance fix | Before/after metrics |

---

### H2: AMNESIA
**Definition:** Forgetting constraints, prior work, or institutional knowledge. Acting as if history doesn't exist.

**Detection Signals:**
- No Hive Mind Check in DISCOVERY (skipped pheromone scan)
- Re-implemented something that already exists
- Broke code another Ant carefully built
- Ignored pheromones (especially NUCLEAR severity)
- Contradicts decisions in Operator Manual or project conventions

**What Ghost/Inspector Checks:**
- [ ] Hive Mind Check was performed in DISCOVERY
- [ ] Pheromone Registry was checked for target files
- [ ] Prior Ant work on same files was acknowledged
- [ ] Nuclear invariants were respected
- [ ] Operator Manual conventions were followed

---

### H3: DRIFT
**Definition:** Scope creep. Exceeding the approved FOOTPRINT. "While I was there" changes.

**Detection Signals:**
- Files modified that weren't in the FOOTPRINT plan
- "Also" or "additionally" or "while I was there" language
- More files changed than planned
- Unrelated improvements bundled with task
- git diff shows files outside approved scope

**What Ghost/Inspector Checks:**
- [ ] FOOTPRINT was approved before PATCH
- [ ] Actual changes match FOOTPRINT exactly
- [ ] No additional files were touched outside scope
- [ ] No "while I was there" improvements
- [ ] If new work was discovered, it was flagged as a separate task (not done inline)

---

### H4: PRIVILEGE CREEP
**Definition:** Crossing permission boundaries. Touching critical surfaces without override. Actions above authorization level.

**Detection Signals:**
- Critical surface edited without CRITICAL SURFACE OVERRIDE token
- Dangerous operations (force-push, deploy, migration) without operator approval
- Ghost/Inspector tools used to modify (write violation)
- Dependency changes without operator approval
- Production deployment attempted

**What Ghost/Inspector Checks:**
- [ ] No critical surfaces touched without OVERRIDE token
- [ ] All danger operations had operator approval
- [ ] Tool permissions respected (Ghost didn't edit, Inspector didn't build)
- [ ] No dependency additions without approval
- [ ] No force-push, deploy, or migration without explicit authorization

---

### H5: SILENT FAILURE
**Definition:** Failures that go unnoticed. Build "passes" but runtime breaks. No test coverage for new code.

**Detection Signals:**
- New code with no corresponding test
- Empty catch blocks (error swallowed)
- No error handling on async operations
- Build passes but feature actually broken at runtime
- Console errors present but ignored
- Security rule changes without test coverage

**What Ghost/Inspector Checks:**
- [ ] Tests exist and pass for new/changed code
- [ ] Error handling present on async operations
- [ ] No empty catch blocks (all catch → log or rethrow)
- [ ] Build output is clean (no warnings treated as "fine")
- [ ] Runtime verification was done (not just compile)
- [ ] Console errors checked via DevTools (if applicable)

---

## HORSEMEN CHECK TEMPLATES

> Templates for Ant Self-Check, Ghost Verdict, and Inspector Audit are in their respective report templates:
> - **Ant:** `templates/ANT_REPORT.md` Section 7 (HORSEMEN SELF-CHECK)
> - **Ghost:** `templates/GHOST_REVIEW.md` (HORSEMEN VERDICT)
> - **Inspector:** `templates/INSPECTOR_REPORT.md` (HORSEMEN AUDIT)
> - **Cards:** `cards/ant/ANT_VERIFY.md`, `cards/ghost/GHOST_VERDICT.md`, `cards/inspector/INSPECTOR_VERDICT.md`

---

## NEO PIPELINE MAPPING

| NEO State | Horseman Focus | What to Check |
|-----------|----------------|---------------|
| **DISCOVERY** | H2 AMNESIA | Hive Mind Check done? Prior work respected? |
| **FOOTPRINT** | H3 DRIFT, H4 PRIVILEGE | Scope defined? Critical surfaces flagged? |
| **PATCH** | H3 DRIFT, H4 PRIVILEGE | Changes match footprint? Permissions respected? |
| **VERIFY** | H1 HALLUCINATION, H5 SILENT FAILURE | Evidence real? Tests pass? Runtime works? |
| **REPORT** | ALL FIVE | Complete Horsemen self-check |
| **Ghost Review** | ALL FIVE | Validate all Horsemen against evidence |
| **Inspector Audit** | ALL FIVE | Audit both Ant and Ghost |

---

## STOP CONDITION

If any Horseman is undefeated:

```
HORSEMAN TRIGGERED: {H1/H2/H3/H4/H5}
WHAT FAILED: {description}
EVIDENCE MISSING: {what proof is absent}
NEXT STEP: {exact action to produce the missing proof}
CANNOT PROCEED UNTIL: {condition}
```

---
