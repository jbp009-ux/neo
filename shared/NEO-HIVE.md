# NEO-HIVE v1.0.0
## Hive Mind — Index Formats, Sharding Rules & Read/Write Contracts

**Version:** 1.0.0
**Date:** 2026-02-10
**Purpose:** Shared intelligence layer — every Ant sees what came before, every pheromone persists until resolved
**Scale Target:** 10,000 ANTs per project

---

## 1. Overview

The Hive Mind is NEO's institutional memory system. It consists of three index files that track every completed task, every file touched, and every risk identified across the lifetime of a project.

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│   Every Ant reads the Hive before touching code.                │
│   Every pheromone persists until explicitly resolved.           │
│   Every file has a documented history.                          │
│                                                                 │
│   No Ant works blind. No risk gets buried.                      │
│   The Hive remembers everything.                                │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 2. Index Files

Three indexes live in `<PROJECT>/.neo/index/`:

| Index | File Pattern | Purpose | Sharding |
|-------|-------------|---------|----------|
| **MASTER_INDEX** | `MASTER_INDEX_NNN.md` | One line per completed task — the task registry | 500 entries per shard |
| **FILE_OWNERSHIP** | `FILE_OWNERSHIP_<dir>.md` | Per-file modification history — who touched what | By directory prefix |
| **PHEROMONE_REGISTRY** | `PHEROMONE_<SEVERITY>.md` | Active warnings with resolution tracking | By severity level |

```
<PROJECT>/.neo/index/
├── MASTER_INDEX_001.md          ← Tasks 1-500
├── MASTER_INDEX_002.md          ← Tasks 501-1000
├── FILE_OWNERSHIP_src_functions.md
├── FILE_OWNERSHIP_src_app.md
├── FILE_OWNERSHIP_root.md       ← Files in project root
├── PHEROMONE_NUCLEAR.md
├── PHEROMONE_HIGH.md
├── PHEROMONE_MEDIUM.md
├── PHEROMONE_LOW.md
└── PHEROMONE_INFO.md
```

---

## 3. MASTER_INDEX Format

One line per completed task. Pipe-delimited for grep.

### Header (line 1 of each shard)
```
# MASTER_INDEX — Shard NNN (Tasks X-Y)
```

### Entry Format
```
TASK_ID|DATE|ANT_TYPE|RISK|FILES_TOUCHED|VERDICT|EVIDENCE_SCORE|PHEROMONE_SUMMARY|FINGERPRINT
```

### Fields

| Field | Format | Example |
|-------|--------|---------|
| TASK_ID | `TASK-NNN` | `TASK-001` |
| DATE | `YYYY-MM-DD` | `2026-02-10` |
| ANT_TYPE | `<emoji> <name>` | `📊 Analyst` |
| RISK | `<emoji> <level>` | `🟢 LOW` |
| FILES_TOUCHED | Comma-separated basenames | `sonnyAI.ts,cartFunctions.ts` |
| VERDICT | `✅ PASS` / `✅ PASS WITH FINDINGS` / `❌ FAIL` | `✅ PASS` |
| EVIDENCE_SCORE | Percentage | `97%` |
| PHEROMONE_SUMMARY | Short text or `None` | `⚫ NUCLEAR:1, 🔴 HIGH:2` |
| FINGERPRINT | First 8 chars of SHA256 of Ant report | `a1b2c3d4` |

### Example
```
TASK-001|2026-02-10|📊 Analyst|🟢 LOW|sonnyAI.ts,cartFunctions.ts,menuPublishTriggers.ts,publishMenuForRestaurant.ts,firestore.rules|✅ PASS|97%|None|a1b2c3d4
TASK-002|2026-02-10|🔥 Fire Ant|🔴 HIGH|auth.ts,middleware.ts|✅ PASS|92%|⚫ NUCLEAR:1|e5f6g7h8
TASK-003|2026-02-10|🛠️ Carpenter|🟡 STANDARD|orderFunctions.ts|✅ PASS WITH FINDINGS|85%|🟠 MEDIUM:1|i9j0k1l2
```

### Searching
```bash
# Find all tasks that touched a file
grep "sonnyAI.ts" .neo/index/MASTER_INDEX_*.md

# Find all NUCLEAR tasks
grep "NUCLEAR" .neo/index/MASTER_INDEX_*.md

# Find all Fire Ant tasks
grep "Fire Ant" .neo/index/MASTER_INDEX_*.md

# Count total tasks
grep -c "^TASK-" .neo/index/MASTER_INDEX_*.md
```

---

## 4. FILE_OWNERSHIP Format

Per-file sections showing complete modification history.

### Shard Naming

Sharded by the first directory under project root:
- `src/functions/auth.ts` → `FILE_OWNERSHIP_src_functions.md`
- `src/app/login/page.tsx` → `FILE_OWNERSHIP_src_app.md`
- `firestore.rules` (root) → `FILE_OWNERSHIP_root.md`
- `cloudflare/worker/index.ts` → `FILE_OWNERSHIP_cloudflare_worker.md`

**Rule:** Take the first TWO path segments after project root. If the file is in root, use `root`.

### Header (line 1 of each shard)
```
# FILE_OWNERSHIP — <directory path>
```

### Entry Format
```markdown
## <relative/path/to/file>
| Task | Date | Ant Type | Change | Risk | Pheromones |
|------|------|----------|--------|------|------------|
| TASK-NNN | YYYY-MM-DD | <emoji> <type> | READ/MODIFY/CREATE/DELETE | <risk> | <pheromone or None> |
```

### Change Types

| Type | Meaning |
|------|---------|
| `READ` | File was analyzed but not modified |
| `MODIFY` | File was changed (code edits) |
| `CREATE` | File was newly created |
| `DELETE` | File was removed |

### Example
```markdown
## src/functions/sonnyAI.ts
| Task | Date | Ant Type | Change | Risk | Pheromones |
|------|------|----------|--------|------|------------|
| TASK-001 | 2026-02-10 | 📊 Analyst | READ | 🟢 LOW | None |
| TASK-005 | 2026-02-11 | 🔥 Fire Ant | MODIFY | 🔴 HIGH | ⚫ NUCLEAR: cross-tenant query |
| TASK-012 | 2026-02-12 | 💵 Financial | MODIFY | 🔴 HIGH | None |

## src/functions/cartFunctions.ts
| Task | Date | Ant Type | Change | Risk | Pheromones |
|------|------|----------|--------|------|------------|
| TASK-001 | 2026-02-10 | 📊 Analyst | READ | 🟢 LOW | None |
| TASK-008 | 2026-02-11 | 🛡️ Soldier | MODIFY | 🟠 MEDIUM | 🟠 MEDIUM: missing input validation |
```

### Searching
```bash
# Find all tasks that touched a specific file
grep -A 20 "## src/functions/auth.ts" .neo/index/FILE_OWNERSHIP_src_functions.md

# Find all MODIFY operations in a directory
grep "MODIFY" .neo/index/FILE_OWNERSHIP_src_functions.md

# Find high-traffic files (count tasks per file)
grep -c "TASK-" .neo/index/FILE_OWNERSHIP_*.md
```

---

## 5. PHEROMONE_REGISTRY Format

Severity-grouped warnings with resolution tracking.

### Shard Naming

One file per severity level:
- `PHEROMONE_NUCLEAR.md` — ⚫ NUCLEAR (tenant/credential/security boundary)
- `PHEROMONE_HIGH.md` — 🔴 HIGH (significant risk)
- `PHEROMONE_MEDIUM.md` — 🟠 MEDIUM (moderate risk)
- `PHEROMONE_LOW.md` — 🟡 LOW (minor risk)
- `PHEROMONE_INFO.md` — 🟢 INFO (observations)

### Header (line 1 of each shard)
```
# PHEROMONE_REGISTRY — <SEVERITY>
```

### Entry Format
```markdown
| ID | Task | File:Line | Category | Message | Status |
|----|------|-----------|----------|---------|--------|
| PH-NNN | TASK-NNN | <file>:<line> | <category> | <description> | ACTIVE / RESOLVED_TASK-NNN |
```

### Pheromone ID

Global sequential: `PH-001`, `PH-002`, etc. Never reused, never reset.

### Categories

| Category | Used For |
|----------|----------|
| ISOLATION | Tenant isolation issues (cross-tenant queries, shared state) |
| CREDENTIAL | Secrets in code, logs, configs |
| SECURITY | Auth bypasses, boundary violations |
| VALIDATION | Missing input validation, sanitization |
| PERFORMANCE | Performance risks, unbounded queries |
| DATA_INTEGRITY | Data consistency risks, race conditions |
| DEPENDENCY | Risky dependency patterns |
| ARCHITECTURE | Structural concerns, coupling |

### Status Values

| Status | Meaning |
|--------|---------|
| `ACTIVE` | Pheromone is current — Ants MUST acknowledge before touching this file |
| `RESOLVED_TASK-NNN` | Fixed by the specified task — for audit trail only |

### Example
```markdown
# PHEROMONE_REGISTRY — NUCLEAR

| ID | Task | File:Line | Category | Message | Status |
|----|------|-----------|----------|---------|--------|
| PH-001 | TASK-005 | sonnyAI.ts:42 | ISOLATION | Cross-tenant query without restaurantId filter | ACTIVE |
| PH-002 | TASK-008 | auth.ts:15 | CREDENTIAL | API key hardcoded in source | RESOLVED_TASK-012 |
| PH-003 | TASK-019 | middleware.ts:88 | SECURITY | Auth check skipped for admin route | ACTIVE |
```

### Searching
```bash
# Find all ACTIVE pheromones on a file
grep "ACTIVE" .neo/index/PHEROMONE_*.md | grep "sonnyAI.ts"

# Find all NUCLEAR pheromones
grep "ACTIVE" .neo/index/PHEROMONE_NUCLEAR.md

# Count active pheromones by severity
grep -c "ACTIVE" .neo/index/PHEROMONE_NUCLEAR.md
grep -c "ACTIVE" .neo/index/PHEROMONE_HIGH.md

# Find resolution history for a pheromone
grep "PH-001" .neo/index/PHEROMONE_NUCLEAR.md
```

---

## 6. Sharding Rules

### MASTER_INDEX Sharding

| Rule | Value |
|------|-------|
| Max entries per shard | 500 |
| Shard naming | `MASTER_INDEX_001.md`, `MASTER_INDEX_002.md`, ... |
| New shard trigger | Current shard reaches 500 entries |
| First shard created by | `neo-init.ps1` (empty seed) |
| New shards created by | BECCA during CLOSE |

### FILE_OWNERSHIP Sharding

| Rule | Value |
|------|-------|
| Shard key | First two directory segments (e.g., `src_functions`, `src_app`) |
| Root files | `FILE_OWNERSHIP_root.md` |
| New shard trigger | First file encountered in a new directory |
| Created by | BECCA during CLOSE (on demand) |

### PHEROMONE_REGISTRY Sharding

| Rule | Value |
|------|-------|
| Shard key | Severity level |
| Fixed shards | 5 (NUCLEAR, HIGH, MEDIUM, LOW, INFO) |
| No dynamic sharding | Severity levels are fixed |
| Created by | `neo-init.ps1` (all 5 seeded empty) |

### Scale Projections

| ANTs | MASTER Shards | FILE Shards | PHEROMONE Shards | Total Files |
|------|--------------|-------------|------------------|-------------|
| 100 | 1 | ~5 | 5 | ~11 |
| 1,000 | 2 | ~20 | 5 | ~27 |
| 5,000 | 10 | ~50 | 5 | ~65 |
| 10,000 | 20 | ~100 | 5 | ~125 |

---

## 7. Read/Write Contracts

### Who Reads What

| Role | MASTER_INDEX | FILE_OWNERSHIP | PHEROMONE_REGISTRY |
|------|-------------|----------------|-------------------|
| **Ant** | ✅ READ (during DISCOVERY) | ✅ READ (during DISCOVERY) | ✅ READ (during DISCOVERY) |
| **Ghost** | ✅ READ (validates Ant claims) | ✅ READ (spot-checks) | ✅ READ (validates pheromones) |
| **Inspector** | ✅ READ (HIVE audit) | ✅ READ (HIVE audit) | ✅ READ (HIVE audit) |
| **BECCA** | ✅ READ + WRITE (RECON + CLOSE) | ✅ READ + WRITE (CLOSE) | ✅ READ + WRITE (CLOSE) |

### Write Rules

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│   ONLY BECCA WRITES TO INDEXES.                                 │
│   ONLY DURING CLOSE.                                            │
│   ONE TASK AT A TIME. APPEND-ONLY.                              │
│                                                                 │
│   No other role may modify index files.                         │
│   No deletions (except pheromone status updates).               │
│   No reordering. No reformatting.                               │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### BECCA CLOSE Index Write Procedure

For each completed task in the run:

1. **MASTER_INDEX:**
   - Read current shard, count entries
   - If count >= 500 → create new shard
   - Append one line with all 9 fields
   - Compute fingerprint (SHA256 of Ant report content, first 8 chars)
   - Check fingerprint against all shards — if duplicate found, STOP and report

2. **FILE_OWNERSHIP:**
   - For each file in the task's "Target Files" or "Files Changed":
     - Determine shard (first two directory segments)
     - If shard doesn't exist → create from template
     - If file section doesn't exist → create new `## <path>` section
     - Append one row: Task, Date, Ant Type, Change Type, Risk, Pheromones

3. **PHEROMONE_REGISTRY:**
   - For each pheromone in the Ant's report Section 8 (PHEROMONES EMITTED):
     - Determine severity shard
     - Assign next PH-NNN ID (global sequential)
     - Append one row with Status = `ACTIVE`
   - For each pheromone the task RESOLVED:
     - Find the pheromone by PH-NNN in the appropriate shard
     - Update Status from `ACTIVE` to `RESOLVED_TASK-NNN`

---

## 8. Ant Hive Mind Check

Every Ant MUST perform a Hive Mind Check at the START of DISCOVERY, before reading any code.

### Procedure

```
STATE: DISCOVERY (Hive Mind Check)

1. Identify target files from the task packet
2. Search MASTER_INDEX for all tasks that touched these files:
   grep "<filename>" .neo/index/MASTER_INDEX_*.md
3. Read FILE_OWNERSHIP for each target file:
   grep -A 20 "## <filepath>" .neo/index/FILE_OWNERSHIP_<dir>.md
4. Search PHEROMONE_REGISTRY for active warnings on target files:
   grep "ACTIVE" .neo/index/PHEROMONE_*.md | grep "<filename>"
5. Present HIVE MIND BRIEFING to operator
```

### Hive Mind Briefing Format

```
📡 HIVE MIND BRIEFING

Target Files:
- sonnyAI.ts — 3 previous tasks (TASK-001, TASK-005, TASK-012), last: TASK-012 (💵 Financial, HIGH)
- cartFunctions.ts — 2 previous tasks, last: TASK-008 (🛡️ Soldier, MEDIUM)
- auth.ts — 5 previous tasks, HIGH-TRAFFIC ZONE ⚠️

Active Pheromones on Target Files:
- ⚫ PH-001 (NUCLEAR) on sonnyAI.ts:42 — Cross-tenant query without filter
- 🟠 PH-007 (MEDIUM) on cartFunctions.ts:88 — Missing input validation

Hive Risk Assessment:
- sonnyAI.ts: HIGH — NUCLEAR pheromone active, tenant-critical
- cartFunctions.ts: MEDIUM — active pheromone
- auth.ts: LOW — no active pheromones, but high traffic
```

### NUCLEAR Stop Rule

```
IF any target file has an ACTIVE ⚫ NUCLEAR pheromone:
→ STOP. Present the pheromone details.
→ Request operator clearance: "⚫ NUCLEAR pheromone active. Proceed? (Y/N)"
→ If operator says NO → HALT task, report blocked
→ If operator says YES → Log clearance, continue with caution
```

---

## 9. Fingerprint Deduplication

Every Ant report gets a fingerprint to prevent duplicate indexing.

### Computing the Fingerprint

1. Read the full Ant report content
2. Compute SHA256 hash of the content
3. Take first 8 characters
4. This is the fingerprint (e.g., `a1b2c3d4`)

### Dedup Check

Before writing to MASTER_INDEX, BECCA searches all shards:
```bash
grep "a1b2c3d4" .neo/index/MASTER_INDEX_*.md
```

If match found → STOP, report: "Duplicate fingerprint detected. Task already indexed."

---

## 10. Pheromone Lifecycle

```
EMITTED (by Ant)
    │
    ▼
INDEXED (by BECCA during CLOSE)
    │  Status: ACTIVE
    │
    ▼
READ (by future Ants during Hive Mind Check)
    │  "⚫ NUCLEAR pheromone active on this file"
    │
    ▼  (some later task fixes the issue)
RESOLVED (by BECCA during CLOSE)
    │  Status: RESOLVED_TASK-NNN
    │
    ▼
ARCHIVED (remains in registry forever — audit trail)
```

### Resolution Rules

- A pheromone is RESOLVED when a later Ant explicitly fixes the issue and documents it
- The resolving Ant must reference the pheromone ID in their report
- BECCA updates the status during CLOSE
- Resolved pheromones are NOT deleted — they stay for audit trail
- Future Ants see resolved pheromones but they don't trigger the NUCLEAR stop rule

---

## 11. Index Health Check (BECCA RECON)

During RECON, BECCA checks index integrity:

```
INDEX HEALTH CHECK:
1. Count total tasks in MASTER_INDEX (grep -c "^TASK-" across all shards)
2. Verify shard sizes (none > 500 entries)
3. Count active pheromones by severity
4. Check for stale pheromones (ACTIVE for > 30 days — warn operator)
5. Check for orphaned entries (task in FILE_OWNERSHIP but not in MASTER_INDEX)
6. Report summary:
   "Index healthy: N tasks indexed, M active pheromones (X NUCLEAR), K files tracked"
   OR
   "Index issues found: <list of problems>"
```

### Health Report Format

```
📊 INDEX HEALTH REPORT

| Metric | Value |
|--------|-------|
| Total tasks indexed | 847 |
| MASTER_INDEX shards | 2 |
| Files tracked | 234 |
| FILE_OWNERSHIP shards | 18 |
| Active pheromones | 12 (2 NUCLEAR, 3 HIGH, 4 MEDIUM, 2 LOW, 1 INFO) |
| Stale pheromones (>30d) | 1 — PH-003 on middleware.ts (NUCLEAR, 45 days) |
| Orphaned entries | 0 |
| Status | ✅ HEALTHY / ⚠️ ISSUES FOUND |
```

---

## 12. Integration Points

### With NEO-ACTIVATION.md
- Project structure diagram includes `index/` directory
- Index file paths documented

### With NEO-ANT.md
- Hive Mind Check added to DISCOVERY state
- Section 10: HIVE CONTEXT added to Ant report
- NUCLEAR stop rule for pheromones

### With NEO-GHOST.md
- Section 5b: Hive Mind Compliance added to review
- Ghost spot-checks Ant's hive context claims

### With NEO-BECCA.md
- CLOSE phase: index writes (MASTER_INDEX, FILE_OWNERSHIP, PHEROMONE_REGISTRY)
- RECON phase: index health check

### With NEO-INSPECTOR.md
- HIVE inspection type: 8-point index consistency audit

### With NEO-EVIDENCE.md
- Hive context claims require evidence (actual grep output from indexes)

### With NEO-OUTPUTS.md
- Index output contracts for BECCA's write operations

---

## Changelog

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
