# NEO ARCHIVAL UPDATE PLAN
## Bringing Colony OS Ghost Decomposition Pattern to NEO

**Created:** 2026-02-09
**Status:** IN PROGRESS — Documenting before implementation
**Purpose:** Crash-proof reference for the NEO archival upgrade

---

## 1. WHAT COLONY OS DOES (The Pattern We're Adopting)

### The Core Idea

In Colony OS, Ghost Archivist (PMX-12) doesn't just "review" the Ant report — it **dismantles** the report into **7 separate sections** and routes each section to a **different file/folder**. Then Horsemen Inspector (PMX-13) verifies that every piece landed in the correct location.

### Colony OS 7-Section Decomposition

| # | Section | Destination File | What It Contains |
|---|---------|-----------------|------------------|
| 1 | Run Header | *(not persisted)* | Runtime metadata (timestamp, mode, units processed) |
| 2 | Master Index Entry | `governance/index/MASTER_ANT_INDEX.md` | One-line pipe-delimited grep-searchable registry entry per Ant |
| 3 | File Ownership | `governance/index/FILE_OWNERSHIP_MAP.md` | Which Ants modified/created which files (basenames, `+ANT-ID`) |
| 4 | Pheromones | `governance/index/PHEROMONE_REGISTRY.md` | Warnings grouped by severity (CRITICAL/HIGH/MEDIUM/INFO) |
| 5 | Batch Report | `governance/reports/batch/ANT_REPORTS_{range}.md` | Full report content, sharded by ID range (25 per file) |
| 6 | Inbox Delta | `governance/index/RECENT_UNINDEXED_REPORTS.md` | Remove from inbox (indexed) or move to quarantine (failed) |
| 7 | Manifest | *(discarded after review)* | Operator audit notes, extraction ledger, invariant checks |

### Colony OS Roles

| Role | What They Do | What They DON'T Do |
|------|-------------|-------------------|
| **Ghost Archivist (PMX-12)** | Picks up Ant reports from inbox, qualifies them, breaks into 7 pieces, routes each to correct file, maintains append-only ledger | Modify code, delete reports, change history, make quality judgments |
| **Horsemen Inspector (PMX-13)** | Verifies Ghost placed everything correctly, checks 5 dimensions (Hallucination, Amnesia, Drift, Privilege Creep, Silent Failure) | Fix anything, apply recommendations, override operator |

### Colony OS Folder Structure

```
governance/
├── raw-reports/
│   ├── inbox/              ← Ants write completion reports here
│   └── processed/          ← Ghost moves them after indexing
├── index/
│   ├── MASTER_ANT_INDEX.md         ← Section 2: one line per Ant
│   ├── FILE_OWNERSHIP_MAP.md       ← Section 3: who touched what
│   ├── PHEROMONE_REGISTRY.md       ← Section 4: all warnings
│   ├── RECENT_UNINDEXED_REPORTS.md ← Section 6: inbox delta
│   └── HORSEMEN_OUTCOMES.md        ← Inspector verdicts
└── reports/
    ├── aux_reports/                ← Legacy reports (ANT-1 to ANT-99)
    │   ├── AUX_REPORTS_001_025.md
    │   ├── AUX_REPORTS_026_050.md
    │   └── ...
    └── batch/                      ← Standard reports (ANT-100+)
        ├── ANT_REPORTS_100_124.md
        └── ...
```

### Colony OS Qualification Test (Before Indexing)

Ghost only indexes reports that pass 3 checks:

| Check | Rule | Fail Action |
|-------|------|-------------|
| 1. Anchor | First line has canonical header `### ANT-{digits}` | QUARANTINE: NO_CANONICAL_ANCHOR |
| 2. Complete | Contains `Status:` or `VERDICT` header | QUARANTINE: INCOMPLETE_REPORT |
| 3. Not Chat | No conversational text before first `### ANT-` | QUARANTINE: CHAT_HISTORY_CONTEXT |

### Colony OS Key Principles

- **Append-only ledger** — add entries, update status, NEVER delete or modify history
- **Deterministic** — identical input = identical output
- **Sharded** — 25 Ants per batch file for scalability
- **Deduplication** — fingerprints detect duplicates: `@ant-{id}-{flags}-{type}-ph{phase}-{file-slug}`

---

## 2. WHAT NEO CURRENTLY DOES (The Problem)

### Current NEO Flow

```
Ant writes full report → .neo/outbox/ants/ANT_REPORT_<TASK_ID>.md
    │
    ▼
Ghost "reviews" it as ONE BLOB → .neo/outbox/ghost/GHOST_REVIEW_<TASK_ID>.md
    │
    ▼
Inspector audits for standards → .neo/outbox/inspector/INSPECTOR_REPORT_<TASK_ID>.md
```

### What's Wrong

1. **Ghost doesn't break the report apart** — it stays as one monolithic file
2. **No index files** — no master index, no file ownership map, no pheromone registry
3. **No institutional memory** — when 50 tasks are done, there's no way to grep across all of them
4. **No sharding** — every report is its own file, no batch consolidation
5. **Inspector doesn't verify placement** — only checks standards compliance, not archival correctness
6. **No qualification test** — Ghost accepts any report, no quarantine for malformed ones

### Current NEO Ant Report (10 Sections)

| # | Section | Currently Goes To |
|---|---------|------------------|
| 1 | Task Summary | stays in ANT_REPORT blob |
| 2 | Discovery Findings | stays in ANT_REPORT blob |
| 3 | Footprint | stays in ANT_REPORT blob |
| 4 | Patch (Diffs) | stays in ANT_REPORT blob |
| 5 | Verification | stays in ANT_REPORT blob |
| 6 | Evidence Index | stays in ANT_REPORT blob |
| 7 | Self-Assessment | stays in ANT_REPORT blob |
| 8 | Risks / Unknowns | stays in ANT_REPORT blob |
| 9 | Gate Log | stays in ANT_REPORT blob |
| 10 | Handoff | stays in ANT_REPORT blob |

Everything stays in **one file**. Nothing gets routed anywhere.

---

## 3. THE PLANNED UPDATE — NEO 8-Section Decomposition

### What Ghost Should Do After This Update

Ghost receives the Ant report and **breaks it into 8 routed sections**, each going to a specific file/folder:

| # | Section | Source (from Ant Report) | Destination | Purpose |
|---|---------|------------------------|-------------|---------|
| 1 | Master Index Entry | Task Summary + Handoff metadata | `.neo/index/MASTER_TASK_INDEX.md` | One-line grep-searchable registry per task |
| 2 | File Ownership | Footprint + Patch (files changed) | `.neo/index/FILE_OWNERSHIP_MAP.md` | Which tasks modified which files |
| 3 | Pheromones / Warnings | Risks/Unknowns + Self-Assessment concerns | `.neo/index/PHEROMONE_REGISTRY.md` | Warnings by severity, searchable |
| 4 | Evidence Archive | Evidence Index + Verification output | `.neo/audit/evidence/<TASK_ID>/` | All proof files consolidated in task folder |
| 5 | Batch Report | Full report content | `.neo/audit/reports/TASK_REPORTS_{range}.md` | Sharded by ID range (25 per file) |
| 6 | Gate Log Archive | Gate Log section | `.neo/audit/gate-logs/GATE_LOG_<TASK_ID>.md` | Token trail preserved separately |
| 7 | Inbox Delta | Handoff status | `.neo/index/RECENT_UNPROCESSED.md` | Remove from outbox/ants or quarantine |
| 8 | Ghost Review | Ghost's own findings + verdict | `.neo/outbox/ghost/GHOST_REVIEW_<TASK_ID>.md` | Ghost's review document |

### Updated NEO Folder Structure

```
<PROJECT_ROOT>/.neo/
├── inbox/
│   └── TASK_<TASK_ID>.md                          ← Task packets (operator creates)
│
├── outbox/
│   ├── ants/
│   │   └── ANT_REPORT_<TASK_ID>.md                ← Ant writes here (raw, pre-archival)
│   ├── ghost/
│   │   └── GHOST_REVIEW_<TASK_ID>.md              ← Section 8: Ghost review + verdict
│   └── inspector/
│       └── INSPECTOR_REPORT_<TASK_ID>.md          ← Inspector placement verification
│
├── index/                                          ← INSTITUTIONAL MEMORY (append-only)
│   ├── MASTER_TASK_INDEX.md                        ← Section 1: one line per task
│   ├── FILE_OWNERSHIP_MAP.md                       ← Section 2: who touched what
│   ├── PHEROMONE_REGISTRY.md                       ← Section 3: warnings by severity
│   ├── RECENT_UNPROCESSED.md                       ← Section 7: inbox delta
│   └── INSPECTOR_OUTCOMES.md                       ← Inspector verdicts log
│
├── audit/
│   ├── evidence/
│   │   └── <TASK_ID>/                              ← Section 4: per-task evidence folder
│   │       ├── diffs.patch
│   │       ├── test_output.txt
│   │       ├── build_output.txt
│   │       └── screenshots/
│   ├── reports/                                    ← Section 5: sharded batch files
│   │   ├── TASK_REPORTS_001_025.md
│   │   ├── TASK_REPORTS_026_050.md
│   │   └── ...
│   └── gate-logs/
│       └── GATE_LOG_<TASK_ID>.md                   ← Section 6: archived gate logs
│
├── runtime/                                        ← Active task state (ephemeral)
│   └── GATE_LOG_<TASK_ID>.md                       ← Active gate log (moves to audit when done)
│
└── NEO_STATE.json                                  ← Project pipeline state
```

### The New Flow

```
Ant writes report → .neo/outbox/ants/ANT_REPORT_<TASK_ID>.md
    │
    ▼
Ghost picks it up
    │
    ├─→ Qualification test (canonical header? complete? not chat?)
    │   FAIL → QUARANTINE (stays in outbox/ants with QUARANTINE prefix)
    │   PASS ↓
    │
    ├─→ BREAKS report into 8 sections
    │   ├─→ Section 1: Extract index entry     → .neo/index/MASTER_TASK_INDEX.md (append)
    │   ├─→ Section 2: Extract file ownership  → .neo/index/FILE_OWNERSHIP_MAP.md (append)
    │   ├─→ Section 3: Extract pheromones      → .neo/index/PHEROMONE_REGISTRY.md (append)
    │   ├─→ Section 4: Consolidate evidence    → .neo/audit/evidence/<TASK_ID>/ (create folder)
    │   ├─→ Section 5: Archive full report     → .neo/audit/reports/TASK_REPORTS_{range}.md (append)
    │   ├─→ Section 6: Archive gate log        → .neo/audit/gate-logs/GATE_LOG_<TASK_ID>.md (move)
    │   ├─→ Section 7: Update inbox delta      → .neo/index/RECENT_UNPROCESSED.md (update)
    │   └─→ Section 8: Write Ghost review      → .neo/outbox/ghost/GHOST_REVIEW_<TASK_ID>.md (create)
    │
    ▼
Inspector verifies PLACEMENT (not just standards)
    │
    ├─→ P1: Index entry exists in MASTER_TASK_INDEX.md?
    ├─→ P2: File ownership recorded in FILE_OWNERSHIP_MAP.md?
    ├─→ P3: Pheromones registered (if any warnings existed)?
    ├─→ P4: Evidence folder created with all referenced files?
    ├─→ P5: Full report appended to correct batch file?
    ├─→ P6: Gate log archived?
    ├─→ P7: Inbox delta updated?
    ├─→ P8: Ghost review written with valid verdict?
    │
    ▼
✅ INSPECTOR PASS / 🛑 INSPECTOR FAIL: <missing placements>
```

---

## 4. ROLE RESPONSIBILITY CHANGES

### Ghost (roles/NEO-GHOST.md) — Must Be Updated

**Before:** Ghost reviews the report as one blob and writes a review.

**After:** Ghost has TWO jobs:
1. **ARCHIVE** — Break the report into 8 sections and route each to correct file/folder
2. **REVIEW** — Validate evidence quality and issue verdict

**New Ghost State Flow:**
```
QUALIFY → ARCHIVE → REVIEW → VALIDATE_EVIDENCE → VERDICT
```

| State | What Happens |
|-------|-------------|
| QUALIFY | Read Ant report, run 3 qualification checks (canonical header, complete, not chat) |
| ARCHIVE | Break into 8 sections, route each to correct destination, append-only |
| REVIEW | Check report completeness, DoD, code quality |
| VALIDATE_EVIDENCE | Verify all evidence paths real, score evidence |
| VERDICT | Compile findings, issue APPROVED/REJECTED, write Ghost review |

### Inspector (roles/NEO-INSPECTOR.md) — Must Be Updated

**Before:** Inspector only checks standards compliance (DRIFT/COMPLIANCE/QUALITY).

**After:** Inspector gains a 4th inspection type: **PLACEMENT**

| Type | What It Checks |
|------|---------------|
| DRIFT | Did work deviate from approved plan? |
| COMPLIANCE | Does work meet required standards? |
| QUALITY | Is the work of acceptable quality? |
| **PLACEMENT** | **Did Ghost route all 8 sections to correct locations?** |

**PLACEMENT checks (8 points):**

| # | Check | Pass Criteria |
|---|-------|--------------|
| P1 | Master Index | Task entry exists in `MASTER_TASK_INDEX.md` |
| P2 | File Ownership | All changed files recorded in `FILE_OWNERSHIP_MAP.md` |
| P3 | Pheromones | Warnings from Ant report registered in `PHEROMONE_REGISTRY.md` |
| P4 | Evidence Folder | `.neo/audit/evidence/<TASK_ID>/` exists with referenced files |
| P5 | Batch Report | Full report appended to correct `TASK_REPORTS_{range}.md` |
| P6 | Gate Log | `GATE_LOG_<TASK_ID>.md` exists in `audit/gate-logs/` |
| P7 | Inbox Delta | `RECENT_UNPROCESSED.md` updated (removed from pending) |
| P8 | Ghost Review | `GHOST_REVIEW_<TASK_ID>.md` exists with valid verdict token |

### Ant (roles/NEO-ANT.md) — Minor Update

Ant's job stays mostly the same. Only change:
- Ant still writes its report to `.neo/outbox/ants/ANT_REPORT_<TASK_ID>.md`
- Ant must ensure the report has a **canonical header** so Ghost can qualify it
- Ant must ensure all 10 sections are present (Ghost needs them to extract 8 pieces)

---

## 5. INDEX FILE FORMATS

### MASTER_TASK_INDEX.md

```markdown
# MASTER TASK INDEX

| TASK_ID | Type | Priority | Status | Target Files | Batch File | Timestamp |
|---------|------|----------|--------|-------------|------------|-----------|
| TASK-001 | FIX | HIGH | COMPLETE | src/auth.ts | TASK_REPORTS_001_025.md | 2026-02-09T14:30:00Z |
| TASK-002 | FEATURE | MEDIUM | COMPLETE | src/menu.ts, src/api.ts | TASK_REPORTS_001_025.md | 2026-02-09T16:00:00Z |
```

One line per task. Grep-searchable. Append-only.

### FILE_OWNERSHIP_MAP.md

```markdown
# FILE OWNERSHIP MAP

| File | Tasks | Last Modified By |
|------|-------|-----------------|
| src/auth.ts | TASK-001, TASK-005 | TASK-005 |
| src/menu.ts | TASK-002 | TASK-002 |
| src/api.ts | TASK-002, TASK-003 | TASK-003 |
```

Tracks which tasks touched which files. Updated (not just appended) when same file is touched again.

### PHEROMONE_REGISTRY.md

```markdown
# PHEROMONE REGISTRY

## CRITICAL
| Target | Category | Task | Message | Status |
|--------|----------|------|---------|--------|
| src/auth.ts:42 | SECURITY | TASK-001 | "Hardcoded secret found" | OPEN |

## HIGH
| Target | Category | Task | Message | Status |
|--------|----------|------|---------|--------|

## MEDIUM
| Target | Category | Task | Message | Status |
|--------|----------|------|---------|--------|
| src/menu.ts:100 | PERFORMANCE | TASK-002 | "N+1 query in loop" | OPEN |

## LOW / INFO
| Target | Category | Task | Message | Status |
|--------|----------|------|---------|--------|
```

Warnings grouped by severity. Extracted from Ant's "Risks/Unknowns" section.

### RECENT_UNPROCESSED.md

```markdown
# RECENT UNPROCESSED

## PENDING (in outbox/ants/, not yet archived)
| Task | Report File | Received | Status |
|------|------------|----------|--------|
| TASK-003 | ANT_REPORT_TASK-003.md | 2026-02-09T18:00:00Z | AWAITING_GHOST |

## PROCESSED (archived, removed from pending)
| Task | Archived To | Processed | By |
|------|------------|-----------|-----|
| TASK-001 | TASK_REPORTS_001_025.md | 2026-02-09T15:00:00Z | Ghost |
| TASK-002 | TASK_REPORTS_001_025.md | 2026-02-09T17:00:00Z | Ghost |

## QUARANTINED (failed qualification)
| Task | Reason | Received |
|------|--------|----------|
```

---

## 6. FILES THAT NEED TO CHANGE

| File | Change Type | What Changes |
|------|-------------|-------------|
| `roles/NEO-GHOST.md` | **MAJOR REWRITE** | Add QUALIFY + ARCHIVE states, 8-section routing table, qualification test, append-only doctrine |
| `roles/NEO-INSPECTOR.md` | **UPDATE** | Add PLACEMENT inspection type with 8-point checklist |
| `roles/NEO-ANT.md` | **MINOR** | Add canonical header requirement, ensure 10 sections map to 8 destinations |
| `shared/NEO-OUTPUTS.md` | **MAJOR UPDATE** | Add Section 0 with full folder tree including index/, update all path references, add index file formats |
| `shared/NEO-EVIDENCE.md` | **UPDATE** | Update storage tree to show index/ folder, per-task evidence folders |
| `shared/NEO-GATES.md` | **UPDATE** | Add Ghost QUALIFY + ARCHIVE states to state machine |
| `templates/GHOST_REVIEW.md` | **UPDATE** | Add archival checklist section (8 placements), qualification results |
| `templates/INSPECTOR_REPORT.md` | **UPDATE** | Add PLACEMENT inspection type template |
| `scripts/neo-init.ps1` | **UPDATE** | Create index/ folder with empty index files on init |
| `scripts/neo-refresh.ps1` | **NO CHANGE** | Refresh only copies governance, index files are project data |
| `README.md` | **UPDATE** | Add archival flow explanation, index file descriptions |

### NEW Files to Create

| File | Purpose |
|------|---------|
| `templates/MASTER_TASK_INDEX.md` | Empty template for master index |
| `templates/FILE_OWNERSHIP_MAP.md` | Empty template for file ownership |
| `templates/PHEROMONE_REGISTRY.md` | Empty template for pheromone registry |
| `templates/RECENT_UNPROCESSED.md` | Empty template for inbox delta |
| `templates/INSPECTOR_OUTCOMES.md` | Empty template for inspector verdicts |

---

## 7. SUMMARY — WHO DOES WHAT

```
┌──────────────────────────────────────────────────────────────────┐
│                                                                  │
│  ANT writes the report (10 sections, one file)                   │
│       ↓                                                          │
│  GHOST breaks it apart (8 pieces, 8 destinations)                │
│       ↓                                                          │
│  INSPECTOR verifies placement (8-point checklist)                │
│                                                                  │
│  ANT = produces    │  GHOST = archives    │  INSPECTOR = verifies│
│  (one report)      │  (8 placements)      │  (8 checks)         │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

| Question | Answer |
|----------|--------|
| Who writes the report? | **Ant** — one monolithic file in `outbox/ants/` |
| Who breaks it apart? | **Ghost** — dismantles into 8 sections, routes to 8 destinations |
| Who verifies correct placement? | **Inspector** — PLACEMENT type checks all 8 destinations |
| What principle governs the index? | **Append-only** — add and update status, NEVER delete history |
| How are reports sharded? | **25 per batch file** — TASK_REPORTS_001_025.md, TASK_REPORTS_026_050.md, etc. |

---

## 8. IMPLEMENTATION ORDER

1. Create index file templates (5 new template files)
2. Update `scripts/neo-init.ps1` to create `index/` folder with empty index files
3. Rewrite `roles/NEO-GHOST.md` with QUALIFY + ARCHIVE states and 8-section routing
4. Update `roles/NEO-INSPECTOR.md` with PLACEMENT inspection type
5. Update `shared/NEO-GATES.md` state machine with new Ghost states
6. Update `shared/NEO-OUTPUTS.md` with index file formats and new folder tree
7. Update `shared/NEO-EVIDENCE.md` storage tree
8. Update `templates/GHOST_REVIEW.md` with archival checklist
9. Update `templates/INSPECTOR_REPORT.md` with PLACEMENT type
10. Update `roles/NEO-ANT.md` with canonical header requirement
11. Update `README.md` with full archival flow

---

**This document is the crash-proof reference. If chat dies, resume from here.**

---

## 9. GAP ANALYSIS — 14 Missing Systems from Colony OS

**Source:** Compared Colony OS CLAUDE.md (~2,950 lines) against NEO v1.1.0
**Date:** 2026-02-09
**Constraint:** ALL additions MANUAL-ONLY, project-agnostic (no Firebase paths)

### 9.1 Systems Added to NEO v1.2.0

| # | System | Target Files | Status |
|---|--------|-------------|--------|
| 1 | 🐛 Debugger Ant (13th type) | NEO-ANT, TASK_PACKET, NEO-OUTPUTS, templates | ✅ DONE |
| 2 | ⚫ NUCLEAR Severity tier | NEO-GATES, NEO-EVIDENCE, NEO-OUTPUTS | ✅ DONE |
| 3 | STOP MEANS STOP doctrine | NEO-GATES | ✅ DONE |
| 4 | Expanded STOP Conditions (15+) | NEO-GATES, NEO-ANT | ✅ DONE |
| 5 | Permission Hierarchy (L0-L3) | NEO-GATES | ✅ DONE |
| 6 | Critical Surfaces (protected files) | NEO-TOOLS, NEO-GATES | ✅ DONE |
| 7 | Multi-Tenant Critical Surfaces | NEO-TOOLS | ✅ DONE |
| 8 | Tenant Isolation Pheromones | NEO-EVIDENCE | ✅ DONE |
| 9 | Anti-Drowning Protocol | NEO-ANT, NEO-EVIDENCE | ✅ DONE |
| 10 | Guardian Control Words (expanded tokens) | NEO-GATES | ✅ DONE |
| 11 | Violations Warning Box | NEO-GATES | ✅ DONE |
| 12 | Evidence Budget (hard caps) | NEO-EVIDENCE, NEO-ANT | ✅ DONE |
| 13 | Debugger TEST REPORT format | NEO-OUTPUTS, templates | ✅ DONE |
| 14 | Snapshot Summary (end of DISCOVERY) | NEO-ANT, NEO-OUTPUTS | ✅ DONE |

### 9.2 What Each System Does

**1. 🐛 Debugger Ant** — Diagnose-only type. Reads code, runs tests, produces TEST_REPORT. NEVER fixes code. Hands off to appropriate Ant type. Risk: 🟡 STANDARD.

**2. ⚫ NUCLEAR Severity** — Above CRITICAL. For tenant isolation breaches, cross-tenant data access, security boundary violations. NO override available. Task BLOCKED until security review. The black dot (⚫).

**3. STOP MEANS STOP** — "Acknowledge and continue" is NON-COMPLIANT. Only an explicit Guardian token (🔑 CONTINUE or 🔑 GO) allows progress past a STOP. No read-only exception. No workaround.

**4. Expanded STOP Conditions** — 15+ conditions that trigger immediate STOP (vs NEO's original 7). Includes: cross-tenant query detected, permission escalation, environment mismatch, race condition risk, hardcoded secrets, etc.

**5. Permission Hierarchy (L0-L3)** — 4 levels: L0 THINK ONLY → L1 READ+VERIFY (needs DISCOVERY APPROVED) → L2 WRITE+CHANGE (needs PATCH APPROVED) → L3 FORBIDDEN (never allowed). Every Ant starts at L0.

**6. Critical Surfaces** — Protected files that require CRITICAL SURFACE OVERRIDE token before editing. Examples: auth rules, security configs, deploy configs, database schemas. Operator defines per project.

**7. Multi-Tenant Critical Surfaces** — Data isolation layer files, API boundary files, tenant-specific config. Any edit requires tenant context verification.

**8. Tenant Isolation Pheromones** — Warning markers: TENANT_BOUNDARY (⚫ NUCLEAR), CROSS_TENANT_QUERY (⚫ NUCLEAR), TENANT_CONTEXT (🟠 HIGH), SHARED_COMPONENT (🟡 MEDIUM). Missing pheromone = task incomplete.

**9. Anti-Drowning Protocol** — Evidence budget per state. DISCOVERY: max 5 files, 200 lines, 10 greps. One-question rule. Triage-first. Nearest truth rule. Two-pass workflow (read first, think second).

**10. Guardian Control Words** — Expanded token vocabulary: DISCOVERY APPROVED, DISCOVERY EXPANSION APPROVED, FOOTPRINT APPROVED, PATCH APPROVED, CRITICAL SURFACE OVERRIDE, STOP, CONTINUE/GO, ROLLBACK, BRANCH_PROTECTION_BYPASS APPROVED.

**11. Violations Warning Box** — 8 named violations that auto-reject: gate skipping, budget continue, read-only exception, token fabrication, multi-gate message, acknowledge+continue, wrong prefix, ledger math mismatch.

**12. Evidence Budget** — Hard caps: DISCOVERY (5 files / 200 lines / 10 greps), FOOTPRINT (3 files / 150 lines / 5 greps), VERIFY (10 tests / 500 lines output). Exceeding = STOP + ask.

**13. Debugger TEST REPORT** — Structured output for Debugger Ant: hypothesis, test plan, results, diagnosis, recommended Ant type for fix. Not an ANT_REPORT — it's a TEST_REPORT.

**14. Snapshot Summary** — Required at end of DISCOVERY. 5-line structured summary: (1) root cause, (2) affected files, (3) proposed approach, (4) risk assessment, (5) estimated scope. Prevents DISCOVERY bloat.

### 9.3 Adaptation Rules (Colony OS → NEO)

| Colony OS Concept | NEO Adaptation |
|-------------------|----------------|
| PMX roles (PMX-01 to PMX-14) | 3 roles: Ant, Ghost, Inspector |
| Firebase-specific paths | Project-agnostic (operator defines) |
| Automated transitions | MANUAL ONLY — every transition needs 🔑 |
| 400+ task queue | Same patterns, any scale |
| Colony-specific pheromones | Generic pheromone system |
| `governance/` folder | `.neo/` folder |

**KEY CONSTRAINT: NO AUTOMATION. Every gate, every override, every escalation requires a human 🔑 token.**

---

## 10. IMPLEMENTATION ORDER (All 14 Systems)

1. ✅ Shared modules first (they're loaded by all roles)
   - NEO-GATES.md → v1.2.0 (Systems 2, 3, 4, 5, 6, 10, 11)
   - NEO-EVIDENCE.md → v1.1.0 (Systems 2, 8, 9, 12)
   - NEO-TOOLS.md → v1.1.0 (Systems 6, 7)
   - NEO-OUTPUTS.md → v1.2.0 (Systems 2, 13, 14)
2. ✅ Roles second (they reference shared modules)
   - NEO-ANT.md → v1.2.0 (Systems 1, 4, 9, 12, 14)
   - NEO-GHOST.md → v1.2.0 (Systems 2, 8, 11)
   - NEO-INSPECTOR.md → v1.1.0 (Systems 2, 8)
3. ✅ Templates last
   - TASK_PACKET.md (System 1, 6)
   - ANT_REPORT.md (Systems 8, 14)
   - GHOST_REVIEW.md (Systems 2, 8, 11)
   - INSPECTOR_REPORT.md (Systems 2, 8)
   - NEW: TEST_REPORT.md (System 13)
