# NEO-HIVE v1.6.0
## Hive Mind — Index Formats, Sharding Rules & Read/Write Contracts

**Version:** 1.6.0
**Date:** 2026-03-02
**Purpose:** Shared intelligence layer — every Ant sees what came before, every pheromone persists until resolved, every lesson feeds forward
**Scale Target:** 10,000 ANTs per project

---

## 1. Overview

The Hive Mind is NEO's institutional memory system. It consists of six index files that track every completed task, every file touched, every risk identified, and every lesson learned across the lifetime of a project.

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│   Every Ant reads the Hive before touching code.                │
│   Every pheromone persists until explicitly resolved.           │
│   Every file has a documented history.                          │
│   Every lesson feeds forward to the next Ant.                   │
│                                                                 │
│   No Ant works blind. No risk gets buried.                      │
│   No lesson gets lost. The Hive remembers everything.           │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 2. Index Files

Six indexes live in `<PROJECT>/.neo/index/`:

| Index | File Pattern | Purpose | Sharding |
|-------|-------------|---------|----------|
| **MASTER_INDEX** | `MASTER_INDEX_NNN.md` | One line per completed task — the task registry | 500 entries per shard |
| **FILE_OWNERSHIP** | `FILE_OWNERSHIP_<dir>.md` | Per-file modification history — who touched what | By directory prefix |
| **PHEROMONE_REGISTRY** | `PHEROMONE_<SEVERITY>.md` | Active warnings with resolution tracking | By severity level |
| **LESSONS_INDEX** | `LESSONS_INDEX_<domain>.md` | Lessons learned by domain — what worked, what broke, what to watch | By domain |
| **REJECTION_INDEX** | `REJECTION_INDEX.md` | Ghost/Inspector rejection tracking — why tasks fail | Single file |
| **FINDINGS_INDEX** | `FINDINGS_INDEX.md` | Ghost/Inspector findings aggregated across runs — recurring patterns | Single file |

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
├── PHEROMONE_INFO.md
├── LESSONS_INDEX_auth.md        ← Lessons about auth files
├── LESSONS_INDEX_payments.md    ← Lessons about payment files
├── LESSONS_INDEX_voice.md       ← Lessons about voice/TTS files
├── LESSONS_INDEX_general.md     ← Cross-cutting lessons
├── REJECTION_INDEX.md           ← All rejections across runs
└── FINDINGS_INDEX.md            ← Ghost/Inspector findings aggregated
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

## 6. LESSONS_INDEX Format

Lessons learned from each Ant, organized by domain for easy retrieval by future Ants working on the same area.

### Shard Naming

Sharded by **domain** — derived from the file paths and Ant type of the lesson's source task:

| Domain | Derived From | Example Files |
|--------|-------------|---------------|
| `auth` | Fire Ant tasks, files with auth/login/session/jwt/token in path | `auth.ts`, `middleware.ts`, `session.ts` |
| `payments` | Financial Ant tasks, files with payment/billing/stripe/subscription in path | `stripe.ts`, `billing.ts`, `checkout.ts` |
| `voice` | Files with voice/tts/stt/speech/audio in path | `voiceInput.ts`, `ttsService.ts` |
| `data` | Harvester Ant tasks, files with firestore/database/collection/query in path | `userService.ts`, `menuData.ts` |
| `ui` | Carpenter/Figma Ant tasks, files with component/page/layout in path | `page.tsx`, `Header.tsx` |
| `deploy` | Config/deployment files, CI/CD related | `firebase.json`, `vercel.json` |
| `general` | Cross-cutting lessons, framework behavior, tooling | Anything that doesn't fit above |

**Rule:** Each lesson goes into ONE domain shard. If a lesson spans multiple domains, use the PRIMARY domain (the one most likely to be searched by a future Ant). If unclear, use `general`.

### Header (line 1 of each shard)
```
# LESSONS_INDEX — <domain>
```

### Entry Format
```markdown
## L-NNN: <short title> (TASK-NNN, YYYY-MM-DD)

**Ant Type:** <emoji> <type>
**Files:** <comma-separated file basenames>
**Category:** WHAT_WORKED | GOTCHA | FRAGILE | APPROACH | VERIFICATION | PROTOCOL

**Lesson:**
<2-4 sentences describing the lesson — specific enough that a future Ant on the same files can act on it>

**Evidence:** <reference to Ant report section or specific finding>

**Usage Stats:** Used: 0 | Success: 0 | Failure: 0
```

### Reinforcement Fields

Each lesson tracks how often it was injected into task packets and whether it helped:

| Field | Meaning | Updated By |
|-------|---------|------------|
| `Used` | Times this lesson was injected into a task packet | BECCA during HANDOFF |
| `Success` | Times the Ant who received this lesson passed Ghost on first try | BECCA during HANDOFF (reconciled at CLOSE) |
| `Failure` | Times the Ant who received this lesson was rejected by Ghost | BECCA during HANDOFF (reconciled at CLOSE) |

**Hit Rate** = `Success / Used × 100` — lessons with high hit rates get scored higher for injection.

**Rules:**
- New lessons start at `Used: 0 | Success: 0 | Failure: 0`
- BECCA increments `Used` when attaching lesson to a task packet
- BECCA increments `Success` or `Failure` during HANDOFF to next Ant, based on previous task's Ghost verdict
- CLOSE reconciles: applies reinforcement for any tasks missed due to session crash
- Lessons with `Used >= 5` and `Success / Used < 30%` → flag for review: "Lesson not helping"
- Lessons with `Used >= 5` and `Success / Used > 80%` → HIGH VALUE — prioritize for injection

### Lesson Categories

| Category | Meaning | Example |
|----------|---------|---------|
| `WHAT_WORKED` | An approach that succeeded — repeat it | "Using blob: URLs instead of data: URIs bypasses CSP restrictions" |
| `GOTCHA` | A trap or surprise — watch out | "iPhone speechSynthesis breaks with ANY preprocessing" |
| `FRAGILE` | A file or pattern that breaks easily | "voiceInput.ts re-suspends AudioContext after 1s async gap" |
| `APPROACH` | How to tackle this kind of task | "For Stripe webhook changes, test with Stripe CLI before deploy" |
| `VERIFICATION` | How to verify changes in this area | "Voice changes require real iPhone testing — emulator won't reproduce" |
| `PROTOCOL` | A NEO protocol tip for this domain | "Always check PHEROMONE_NUCLEAR.md before touching auth files" |

### Lesson ID

Global sequential: `L-001`, `L-002`, etc. Never reused, never reset.

### Example
```markdown
# LESSONS_INDEX — voice

## L-001: iPhone speechSynthesis breaks with preprocessing (TASK-037, 2026-02-10)

**Ant Type:** 🛠️ Carpenter
**Files:** voiceInput.ts, ttsService.ts
**Category:** GOTCHA

**Lesson:**
iPhone's speechSynthesis API breaks silently with ANY preprocessing — cancel(), pause/resume, voice selection, or rate/pitch changes. The ONLY safe approach on iPhone is ultra-minimal: create utterance with text, call speak(). Anything more causes silent failure with no error.

**Evidence:** ANT_REPORT_TASK-037.md Section 8, Lesson 2

**Usage Stats:** Used: 3 | Success: 2 | Failure: 1

## L-002: CSP blocks data: URIs for audio blobs (TASK-042, 2026-02-11)

**Ant Type:** 🧰 Toolbox
**Files:** ttsService.ts, voiceStorage.ts
**Category:** GOTCHA

**Lesson:**
Content Security Policy blocks `data:` URIs for audio playback. Use `blob:` URLs via `URL.createObjectURL()` instead. The audio ArrayBuffer must be wrapped in a Blob with the correct MIME type before creating the object URL.

**Evidence:** ANT_REPORT_TASK-042.md Section 8, Lesson 1

**Usage Stats:** Used: 5 | Success: 4 | Failure: 1
```

### Searching
```bash
# Find all lessons about a specific file
grep "voiceInput.ts" .neo/index/LESSONS_INDEX_*.md

# Find all GOTCHAs in a domain
grep "GOTCHA" .neo/index/LESSONS_INDEX_voice.md

# Find all lessons from a specific task
grep "TASK-037" .neo/index/LESSONS_INDEX_*.md

# Find all lessons mentioning a keyword
grep -i "speechSynthesis" .neo/index/LESSONS_INDEX_*.md

# Count total lessons
grep -c "^## L-" .neo/index/LESSONS_INDEX_*.md

# Find high-value lessons (5+ uses, high success)
grep -B5 "Used: [5-9]\|Used: [1-9][0-9]" .neo/index/LESSONS_INDEX_*.md | grep "Success"
```

---

## 7. REJECTION_INDEX Format

Tracks every Ghost/Inspector rejection across all runs — what failed and why. This is the signal source that tells you **what the framework is failing to teach**.

### Single File (No Sharding)

One file: `REJECTION_INDEX.md` — rejections are infrequent enough that sharding is unnecessary. If a project reaches 500+ rejections, the framework has bigger problems.

### Header (line 1)
```
# REJECTION_INDEX — All Rejections Across Runs
```

### Entry Format
```markdown
## REJ-NNN: <short reason> (TASK-NNN, YYYY-MM-DD)

**Rejected By:** Ghost / Inspector
**Verdict:** 🔑 GHOST REJECTED / 🔑 GHOST CHANGES REQUESTED / 🔑 INSPECTOR REJECTED
**Ant Type:** <emoji> <type>
**Category:** EVIDENCE | COMPLIANCE | SURGICAL | NUCLEAR | HIVE | QUALITY | DOD
**Rule Triggered:** <S-NN, V-NN, or NONE> — the specific violation/S-condition that caused the rejection
**Stage:** DISCOVERY | FOOTPRINT | BACKUP | PATCH | VERIFY | REPORT — where the deficiency was detected
**Deficiencies:**
- <deficiency 1 — from Ghost/Inspector deficiency list>
- <deficiency 2>

**Resolution:** FIXED_TASK-NNN / UNRESOLVED / DEFERRED
**Loops:** <number of times this task was rejected before passing>
```

### Rule and Stage Fields

| Field | Purpose | How to Populate |
|-------|---------|-----------------|
| `Rule Triggered` | The specific S-condition or V-violation that caused the rejection | Extract from Ghost/Inspector deficiency list (e.g., "S-12", "V-07"). If no specific rule cited, use `NONE`. |
| `Stage` | The pipeline stage where the deficiency occurred | Determine from Ghost/Inspector review — which section of the Ant report had the problem. |

**Why:** These fields enable BECCA to detect which rules are triggering the most rejections and at which pipeline stages. If `S-12` triggers 5+ rejections across runs, the rule might be unclear. If `DISCOVERY` stage has 3x more rejections than `PATCH`, task packets may need better guidance.

### Rejection Categories

| Category | Meaning | Example |
|----------|---------|---------|
| `EVIDENCE` | Missing or weak evidence, placeholder paths, fabricated output | "Evidence score 42%" |
| `COMPLIANCE` | Missing report sections, budget ledger, truthy diffs, discovery strategy | "Missing Budget Ledger" |
| `SURGICAL` | LAW 1/2/3 violations, missing understanding proof, no backup | "No Understanding Proof" |
| `NUCLEAR` | Undetected NUCLEAR condition, missing NUCLEAR pheromone | "Cross-tenant query unflagged" |
| `HIVE` | Missing hive evidence, didn't read LESSONS_INDEX, prior work not preserved | "LESSONS_INDEX not checked" |
| `QUALITY` | Code quality issues, insufficient testing, missing edge cases | "No edge-case tests for MEDIUM risk" |
| `DOD` | Definition of Done criteria not met | "Success criterion 2 failed" |

### Rejection ID

Global sequential: `REJ-001`, `REJ-002`, etc. Never reused, never reset.

### Resolution Values

| Resolution | Meaning |
|------------|---------|
| `FIXED_TASK-NNN` | Ant fixed the deficiencies and task passed on re-submission |
| `UNRESOLVED` | Task was abandoned or run closed without resolution |
| `DEFERRED` | Deficiency acknowledged but deferred to a future run |

### Example
```markdown
# REJECTION_INDEX — All Rejections Across Runs

## REJ-001: Missing Budget Ledger (TASK-015, 2026-02-20)

**Rejected By:** Ghost
**Verdict:** 🔑 GHOST REJECTED: Missing Budget Ledger in DISCOVERY
**Ant Type:** 🛠️ Carpenter
**Category:** COMPLIANCE
**Rule Triggered:** S-12
**Stage:** DISCOVERY
**Deficiencies:**
- Budget Ledger table missing from DISCOVERY output
- Resource usage not tracked (files read, greps run)

**Resolution:** FIXED_TASK-015
**Loops:** 1

## REJ-002: Evidence score 38% (TASK-018, 2026-02-21)

**Rejected By:** Ghost
**Verdict:** 🔑 GHOST REJECTED: Evidence score < 50%
**Ant Type:** 📊 Harvester
**Category:** EVIDENCE
**Rule Triggered:** V-07
**Stage:** REPORT
**Deficiencies:**
- 3 of 6 evidence paths are placeholder text
- Test output appears fabricated (no timestamps, generic format)

**Resolution:** FIXED_TASK-018
**Loops:** 2
```

### Searching
```bash
# Find all rejections for a specific category
grep "COMPLIANCE" .neo/index/REJECTION_INDEX.md

# Find all unresolved rejections
grep "UNRESOLVED" .neo/index/REJECTION_INDEX.md

# Count total rejections
grep -c "^## REJ-" .neo/index/REJECTION_INDEX.md

# Find rejections that took 2+ loops
grep "Loops: [2-9]" .neo/index/REJECTION_INDEX.md

# Find all rejections for a specific Ant type
grep "Carpenter" .neo/index/REJECTION_INDEX.md

# Find all rejections triggered by a specific rule
grep "Rule Triggered: S-12" .neo/index/REJECTION_INDEX.md

# Find rejections by pipeline stage
grep "Stage: DISCOVERY" .neo/index/REJECTION_INDEX.md
```

---

## 8. FINDINGS_INDEX Format

Aggregates all Ghost and Inspector findings across runs — not just rejections, but ALL flagged issues. This reveals **recurring patterns** that indicate systematic framework gaps.

### Single File (No Sharding)

One file: `FINDINGS_INDEX.md` — tracks aggregated finding types, not individual findings. Each finding type appears once with a running count.

### Header (line 1)
```
# FINDINGS_INDEX — Aggregated Ghost/Inspector Findings Across Runs
```

### Entry Format
```markdown
| Finding Type | Category | Severity | Count | First Seen | Last Seen | Source | Status |
|--------------|----------|----------|-------|------------|-----------|--------|--------|
| <description> | <category> | <severity> | <N> | TASK-NNN | TASK-NNN | Ghost/Inspector | RECURRING / RESOLVED / IMPROVING |
```

### Finding Categories

Same as Ghost review categories:

| Category | Meaning |
|----------|---------|
| `EVIDENCE` | Evidence quality issues |
| `COMPLIANCE` | Protocol compliance gaps |
| `SURGICAL` | Surgical protocol violations |
| `NUCLEAR` | NUCLEAR condition findings |
| `HIVE` | Hive Mind compliance issues |
| `QUALITY` | Code or report quality |

### Status Values

| Status | Meaning |
|--------|---------|
| `RECURRING` | Finding appeared in the last 3 runs — systemic issue |
| `RESOLVED` | Finding hasn't appeared in 5+ runs — likely fixed |
| `IMPROVING` | Count dropped 50%+ compared to first 5 occurrences — trend is good |

### Thresholds

```
IF finding.count >= 3 AND finding.status == RECURRING:
  → Flag as FRAMEWORK SIGNAL in BECCA's FRAMEWORK HEALTH CHECK
  → "Finding type '<type>' appeared <N> times — framework may need adjustment"

IF finding.count >= 5 AND finding.status == RECURRING:
  → Flag as PRIORITY FRAMEWORK SIGNAL
  → "Finding type '<type>' appeared <N> times — strongly recommend Prompt Architect"
```

### Example
```markdown
# FINDINGS_INDEX — Aggregated Ghost/Inspector Findings Across Runs

| Finding Type | Category | Severity | Count | First Seen | Last Seen | Source | Status |
|--------------|----------|----------|-------|------------|-----------|--------|--------|
| Missing Budget Ledger | COMPLIANCE | HIGH | 7 | TASK-008 | TASK-021 | Ghost | RECURRING |
| Snapshot Summary incomplete | COMPLIANCE | MEDIUM | 4 | TASK-005 | TASK-019 | Ghost | IMPROVING |
| Evidence score < 70% | EVIDENCE | HIGH | 3 | TASK-002 | TASK-018 | Ghost | RECURRING |
| Prior work attestation missing | HIVE | HIGH | 2 | TASK-012 | TASK-020 | Ghost | RECURRING |
| Operator Manual stale (>5 runs) | QUALITY | LOW | 3 | TASK-009 | TASK-020 | Ghost | RECURRING |
| A-01 violated (unread code changed) | SURGICAL | HIGH | 1 | TASK-017 | TASK-017 | Ghost | RESOLVED |
```

### Searching
```bash
# Find all RECURRING findings
grep "RECURRING" .neo/index/FINDINGS_INDEX.md

# Find findings with count >= 3
grep -P "(\|\s*[3-9]\d*\s*\||\|\s*\d{2,}\s*\|)" .neo/index/FINDINGS_INDEX.md

# Count total finding types tracked
grep -c "^|" .neo/index/FINDINGS_INDEX.md

# Find all COMPLIANCE findings
grep "COMPLIANCE" .neo/index/FINDINGS_INDEX.md
```

---

## 9. Sharding Rules

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

### LESSONS_INDEX Sharding

| Rule | Value |
|------|-------|
| Shard key | Domain (derived from file paths and Ant type) |
| Fixed domains | 7 (auth, payments, voice, data, ui, deploy, general) |
| New shard trigger | First lesson encountered for a new domain |
| Created by | BECCA during CLOSE (on demand) |
| Seed domains | `general` (seeded by neo-init.ps1) |

### REJECTION_INDEX (No Sharding)

| Rule | Value |
|------|-------|
| Single file | `REJECTION_INDEX.md` |
| No sharding | Rejections are infrequent |
| Created by | `neo-init.ps1` (empty seed) |

### FINDINGS_INDEX (No Sharding)

| Rule | Value |
|------|-------|
| Single file | `FINDINGS_INDEX.md` |
| No sharding | Aggregated finding types, not individual findings |
| Created by | `neo-init.ps1` (empty seed) |

### Scale Projections

| ANTs | MASTER Shards | FILE Shards | PHEROMONE Shards | LESSONS Shards | REJECTION | FINDINGS | Total Files |
|------|--------------|-------------|------------------|----------------|-----------|----------|-------------|
| 100 | 1 | ~5 | 5 | ~3 | 1 | 1 | ~16 |
| 1,000 | 2 | ~20 | 5 | ~5 | 1 | 1 | ~34 |
| 5,000 | 10 | ~50 | 5 | ~7 | 1 | 1 | ~74 |
| 10,000 | 20 | ~100 | 5 | ~7 | 1 | 1 | ~134 |

---

## 10. Read/Write Contracts

### Who Reads What

| Role | MASTER_INDEX | FILE_OWNERSHIP | PHEROMONE_REGISTRY | LESSONS_INDEX | REJECTION_INDEX | FINDINGS_INDEX |
|------|-------------|----------------|-------------------|---------------|----------------|----------------|
| **Ant** | ✅ READ (during DISCOVERY) | ✅ READ (during DISCOVERY) | ✅ READ (during DISCOVERY) | ✅ READ (during DISCOVERY) | — | — |
| **Ghost** | ✅ READ (validates Ant claims) | ✅ READ (spot-checks) | ✅ READ (validates pheromones) | ✅ READ (validates Ant read lessons) | — | — |
| **Inspector** | ✅ READ (HIVE audit) | ✅ READ (HIVE audit) | ✅ READ (HIVE audit) | ✅ READ (HIVE audit) | ✅ READ (HIVE audit) | ✅ READ (HIVE audit) |
| **BECCA** | ✅ READ + WRITE (RECON + CLOSE) | ✅ READ + WRITE (CLOSE) | ✅ READ + WRITE (CLOSE) | ✅ READ + WRITE (CLOSE) | ✅ READ + WRITE (RECON + CLOSE) | ✅ READ + WRITE (RECON + CLOSE) |
| **Prompt Architect** | — | — | ✅ READ (pattern mining) | ✅ READ (lesson mining) | ✅ READ (rejection mining) | ✅ READ (finding mining) |

### Write Rules

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│   ONLY BECCA WRITES TO INDEXES.                                 │
│   ONLY DURING CLOSE — except LESSONS_INDEX Usage Stats          │
│   (Used/Success/Failure), which BECCA updates incrementally     │
│   during HANDOFF after each task completes the pipeline.        │
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

4. **LESSONS_INDEX:**
   - Read the Ant's report Section 8 (LESSONS FOR FUTURE ANTS)
   - For each substantive lesson (skip N/A entries):
     - Determine domain shard (from file paths and Ant type — see Section 6)
     - If shard doesn't exist → create from template
     - Assign next L-NNN ID (global sequential from STATE.md)
     - Determine category: WHAT_WORKED / GOTCHA / FRAGILE / APPROACH / VERIFICATION / PROTOCOL
     - Append entry with: ID, title, task, date, Ant type, files, category, lesson text, evidence ref
   - Update STATE.md: Last Lesson ID = L-<highest>

5. **REJECTION_INDEX:**
   - Read all Ghost reviews from this run (.neo/outbox/ghost/)
   - For each Ghost verdict that is REJECTED or CHANGES REQUESTED:
     - Assign next REJ-NNN ID (global sequential from STATE.md)
     - Extract deficiency list from Ghost review Section 8
     - Determine category from Ghost findings (EVIDENCE, COMPLIANCE, SURGICAL, etc.)
     - Check if task was later re-submitted and passed → Resolution = FIXED_TASK-NNN
     - Count loops from TODO
     - Append entry to REJECTION_INDEX.md
   - Read all Inspector reports from this run (.neo/outbox/inspector/)
   - For each Inspector verdict that is REJECTED or FAIL:
     - Same process — append with "Rejected By: Inspector"
   - Update STATE.md: Last Rejection ID = REJ-<highest>

6. **FINDINGS_INDEX:**
   - Read all Ghost reviews from this run (Section 7: FINDINGS)
   - For each finding (F-NNN) in each Ghost review:
     - Check if this finding type already exists in FINDINGS_INDEX.md
     - If exists: increment Count, update Last Seen, update Status (RECURRING if seen in last 3 runs)
     - If new: append new row with Count = 1, Status = RECURRING
   - Read all Inspector reports from this run
   - For each Inspector finding: same process
   - Check for RESOLVED findings: if a finding type hasn't appeared in 5+ runs → update Status to RESOLVED
   - Update STATE.md: Last Findings Update = <date>

---

## 11. Ant Hive Mind Check

> **Authoritative procedure:** See `roles/NEO-ANT.md` DISCOVERY State, step 0 (Hive Mind Check).
> The Ant performs this check before reading any code. All 7 indexes must be queried with COMMAND PROOF.
> See `shared/NEO-EVIDENCE.md` Section 12 for hive evidence requirements.

---

## 12. Fingerprint Deduplication

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

## 13. Pheromone Lifecycle

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

### How an Ant Resolves a Pheromone

An Ant that fixes an issue flagged by an existing pheromone MUST declare the resolution in their report:

**Step 1 — During DISCOVERY (Hive Mind Check):**
The Ant finds the active pheromone (e.g., `PH-007 ACTIVE on cartFunctions.ts:88 — Missing input validation`).

**Step 2 — During PATCH:**
The Ant fixes the issue. The diff evidence must directly address the pheromone's description.

**Step 3 — In Ant Report Section 9 (PHEROMONES):**
Add a `RESOLVED` entry using this exact format:

```markdown
### Pheromones Resolved

| PH-ID | Original Issue | How Resolved | Evidence |
|-------|---------------|--------------|----------|
| PH-007 | Missing input validation on cartFunctions.ts:88 | Added Zod schema validation for all cart inputs | Diff in Section 4, lines 12-28 |
```

**Step 4 — BECCA CLOSE:**
BECCA reads the Ant's "Pheromones Resolved" table and updates PHEROMONE_REGISTRY:
- Find `PH-007` in the appropriate severity shard
- Change Status from `ACTIVE` to `RESOLVED_TASK-NNN`

**Ghost verifies:** Ghost checks that the Ant's claimed resolution actually fixes the pheromone's original issue (not just adjacent code).

---

## 14. Index Health Check (BECCA RECON)

During RECON, BECCA checks index integrity:

```
INDEX HEALTH CHECK:
1. Count total tasks in MASTER_INDEX (grep -c "^TASK-" across all shards)
2. Verify shard sizes (none > 500 entries)
3. Count active pheromones by severity
4. Check for stale pheromones (ACTIVE for > 30 days — warn operator)
5. Check for orphaned entries (task in FILE_OWNERSHIP but not in MASTER_INDEX)
6. Count total lessons in LESSONS_INDEX (grep -c "^## L-" across all shards)
7. Count total rejections in REJECTION_INDEX (grep -c "^## REJ-")
8. Count RECURRING findings in FINDINGS_INDEX (grep -c "RECURRING")
9. PHEROMONE TRIAGE: generate priority-sorted triage output (see below)
10. Report summary:
    "Index healthy: N tasks, M pheromones (X NUCLEAR), K files, J lessons, R rejections, F recurring findings"
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
| Lessons stored | 47 (across 5 domain shards) |
| Total rejections | 8 (5 FIXED, 2 UNRESOLVED, 1 DEFERRED) |
| Top rejection category | COMPLIANCE (4 of 8) |
| Recurring findings | 3 (2 COMPLIANCE, 1 EVIDENCE) |
| Priority findings (5+) | 1 — "Missing Budget Ledger" (7 occurrences) |
| Orphaned entries | 0 |
| Status | ✅ HEALTHY / ⚠️ ISSUES FOUND |
```

### Pheromone Triage Format

During RECON step 9, BECCA generates a triage report for the operator — sorted by priority so the most important pheromones are visible first.

```
🔬 PHEROMONE TRIAGE

## By Priority (oldest + highest severity first)

| # | PH-ID | Severity | Category | File | Days Active | Tasks Since | Priority |
|---|-------|----------|----------|------|-------------|-------------|----------|
| 1 | PH-001 | ⚫ NUCLEAR | ISOLATION | sonnyAI.ts:42 | 45 | 12 | 🔴 URGENT |
| 2 | PH-003 | 🔴 HIGH | SECURITY | auth.ts:15 | 38 | 8 | 🔴 URGENT |
| 3 | PH-008 | 🟠 MEDIUM | VALIDATION | orderFunctions.ts:88 | 12 | 3 | 🟡 MODERATE |
| 4 | PH-012 | 🟡 LOW | PERFORMANCE | menuData.ts:200 | 5 | 1 | 🟢 LOW |

## Priority Rules
- 🔴 URGENT: NUCLEAR severity OR >30 days active OR >10 tasks since emission
- 🟡 MODERATE: HIGH severity OR >14 days active OR >5 tasks since emission
- 🟢 LOW: everything else

## Stale Pheromone Alert
🛑 2 pheromones ACTIVE >30 days (PH-001, PH-003)
Recommended: Queue resolution task before next run.

## Pheromone Debt Trend
| Run | Active Count | Added | Resolved | Net Change |
|-----|-------------|-------|----------|------------|
| Run 013 | 8 | 3 | 1 | +2 |
| Run 014 | 10 | 4 | 2 | +2 |
| Run 015 | 12 | 3 | 1 | +2 |
Trend: ⚠️ GROWING (+2 per run) — recommend dedicated resolution run
```

**Triage Calculation:**
1. Read all ACTIVE pheromones from PHEROMONE_*.md files
2. For each: calculate days since emission (from task date in MASTER_INDEX)
3. For each: count tasks that touched the same file since emission (from FILE_OWNERSHIP)
4. Sort by: severity DESC → days active DESC → tasks since DESC
5. Assign priority: URGENT / MODERATE / LOW per rules above
6. Calculate debt trend: net active pheromones per run (from last 5 runs in RUN_INDEX)
```

---

## 15. Integration Points

### With NEO-ACTIVATION.md
- Project structure diagram includes `index/` directory
- Index file paths documented

### With NEO-ANT.md
- Hive Mind Check added to DISCOVERY state
- Section 11: HIVE CONTEXT added to Ant report
- NUCLEAR stop rule for pheromones
- Lessons Read: Ant searches LESSONS_INDEX for target files during Hive Mind Check
- Lessons presented in Hive Mind Briefing ("Prior Lessons on Target Files")

### With NEO-GHOST.md
- Section 5b: Hive Mind Compliance added to review
- Ghost spot-checks Ant's hive context claims
- Ghost verifies Ant read LESSONS_INDEX and acknowledged relevant lessons

### With NEO-BECCA.md
- CLOSE phase: index writes (MASTER_INDEX, FILE_OWNERSHIP, PHEROMONE_REGISTRY, LESSONS_INDEX, REJECTION_INDEX, FINDINGS_INDEX)
- CLOSE phase: extracts lessons from Ant Report Section 8, writes to LESSONS_INDEX
- CLOSE phase: extracts rejections from Ghost reviews, writes to REJECTION_INDEX
- CLOSE phase: aggregates findings from Ghost/Inspector reviews, writes to FINDINGS_INDEX
- CLOSE phase: RUN_METRICS output (first-pass rate, deficiency density, pheromone debt)
- RECON phase: index health check (now includes rejection count, recurring findings, pheromone triage)
- RECON phase: PHEROMONE_TRIAGE output (priority-sorted, debt trend, stale alerts)

### With NEO-INSPECTOR.md
- HIVE inspection type: 10-point index consistency audit (was 8 — +REJECTION_INDEX, +FINDINGS_INDEX)

### With NEO-EVIDENCE.md
- Hive context claims require evidence (actual grep output from indexes)

### With NEO-OUTPUTS.md
- Index output contracts for BECCA's write operations

### With PROMPT_ARCHITECT.md
- Proactive Intelligence Scan: mines REJECTION_INDEX for rejection patterns + FINDINGS_INDEX for recurring findings
- Rejection patterns feed directly into Architect's signal analysis alongside LESSONS_INDEX

---

## Changelog

### v1.6.0 (2026-03-02)
- **Write contract amended** — LESSONS_INDEX Usage Stats (Used/Success/Failure) now updated incrementally during HANDOFF, not only at CLOSE
- Reinforcement Fields table updated: Success/Failure updated by "BECCA during HANDOFF (reconciled at CLOSE)"
- Rules text updated: CLOSE reconciles missed updates from session crashes

### v1.5.0 (2026-02-25)
- Lessons Learned Feedback Loop, Token Normalization Rule, Nearest Truth Rule
