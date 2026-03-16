# RUN PLAN: RUN-<NNN>

**Created:** <YYYY-MM-DD>
**Created by:** Planner Ant (👔 Board Ant)
**Source:** Scout TODO + Inbox (<N> documents)
**Project:** <PROJECT_NAME>

---

## IDEA SUMMARY

<1-3 sentences describing the overall objective for this run. What does the operator want to accomplish?>

---

## DEPENDENCY MAP

```
<ASCII diagram showing task dependencies>

Example:
TASK-041 (types) ──→ TASK-042 (hook) ──→ TASK-044 (page)
                 └──→ TASK-043 (API)  ──→ TASK-044 (page)
                                      └──→ TASK-045 (tests)
```

---

## TASK SEQUENCE

| Order | Task ID | Ant Type | Priority | Objective | Target Files | Depends On | Blocks | Session |
|-------|---------|----------|----------|-----------|-------------|------------|--------|---------|
| 1 | TASK-<NNN> | <emoji> <type> | HIGH/MED/LOW | <1-sentence> | <N> files | — | TASK-<NNN> | 1 |
| 2 | TASK-<NNN> | <emoji> <type> | HIGH/MED/LOW | <1-sentence> | <N> files | TASK-<NNN> | TASK-<NNN> | 1 |

---

## SESSION BOUNDARIES

*(Skip this section if all tasks fit in a single session — ≤7 tasks)*

| Session | Tasks | Focus | Prerequisite |
|---------|-------|-------|-------------|
| 1 | TASK-<NNN> through TASK-<NNN> | <focus area> | — |
| 2 | TASK-<NNN> through TASK-<NNN> | <focus area> | Session 1 complete |

### Cross-Session Continuity Notes
- Session 2 depends on: <list of Session 1 outputs>
- Session 2 starts with: fresh BECCA RECON → picks up from RUN_PLAN

---

## TASK PACKETS

| Task ID | Packet Path | Status |
|---------|-------------|--------|
| TASK-<NNN> | `.neo/inbox/TASK_<NNN>.md` | WRITTEN |
| TASK-<NNN> | `.neo/inbox/TASK_<NNN>.md` | WRITTEN |

---

## HIVE INTELLIGENCE APPLIED

| Signal | Source | Applied To | How |
|--------|--------|------------|-----|
| <PH-NNN: warning message> | PHEROMONE_REGISTRY | TASK-<NNN> | Added resolution step before feature work |
| <L-NNN: lesson summary> | LESSONS_INDEX | TASK-<NNN> | Pre-loaded in HIVE CONTEXT |
| <REJ-NNN: rejection pattern> | REJECTION_INDEX | TASK-<NNN> | Added to CONSTRAINTS |

*(If no hive intelligence available: "No prior intelligence for target areas — first work in this domain.")*

---

## RISK ASSESSMENT

| Risk | Severity | Mitigation | Affects |
|------|----------|------------|---------|
| <risk description> | HIGH/MED/LOW | <mitigation> | TASK-<NNN> |

---

## CLOSE PLAN

When all tasks complete, BECCA CLOSE should verify:

- [ ] All task packets in `.neo/inbox/` have corresponding reports in `.neo/outbox/ants/`
- [ ] Dependency chain respected (no task completed before its dependencies)
- [ ] <project-specific verification 1>
- [ ] <project-specific verification 2>
- [ ] Pheromones from RECON addressed or carried forward with justification

---

## APPROVAL

🔑 RUN PLAN APPROVED: RUN-<NNN>
