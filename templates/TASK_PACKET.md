# TASK PACKET: <TASK_ID>

**Created:** <YYYY-MM-DD>
**Created by:** Operator

---

## TASK DEFINITION

| Field | Value |
|-------|-------|
| Task ID | <TASK_ID> |
| Priority | HIGH / MEDIUM / LOW |
| Ant Type | <emoji> <type name> |

### Ant Classification (pick ONE)

| Emoji | Type | Risk | Domain | Use When |
|-------|------|------|--------|----------|
| 🔥 | Fire Ant | 🔴 HIGH | Security | Auth, encryption, tokens, secrets, permissions |
| 💵 | Financial Ant | 🔴 HIGH | Payments | Billing, Stripe, subscriptions, pricing |
| 🛡️ | Soldier Ant | 🟠 MEDIUM | Validation | Input guards, sanitization, rate limiting |
| 🛠️ | Carpenter Ant | 🟡 STANDARD | Building | New UI components, features, React hooks |
| 🧰 | Toolbox Ant | 🟡 STANDARD | Maintenance | Bug fixes, refactoring, deployments, config |
| 📊 | Harvester Ant | 🟡 STANDARD | Data | API integration, Firestore, data fetch/sync |
| 📈 | Analyst Ant | 🟢 LOW | Analytics | Dashboards, metrics, reporting, visualization |
| 🚁 | Flying Scout Ant | 🟢 LOW | Research | Discovery, audits, POCs, benchmarks |
| 🌿 | Leafcutter Ant | 🟢 LOW | Documentation | Docs, READMEs, specs, guides |
| 👔 | Board Ant | 🟢 LOW | Planning | Roadmaps, OKRs, architecture, kickoffs |
| 🤝 | Advisor Ant | 🟢 LOW | Reviews | Code reviews, feedback, consulting |
| 📞 | Customer Support Ant | 🟢 LOW | Support | Help docs, tickets, UX improvements |
| 🐛 | Debugger Ant | 🟡 STANDARD | Diagnostics | Debug, diagnose, trace, profile, reproduce |
| 🎨 | Color Expert Ant | 🔴 HIGH | Design | Colors, themes, design tokens, CSS variables |
| 🖼️ | Figma Ant | 🟡 STANDARD | Design | Figma→Code, design specs, token extraction |
| 🧪 | QA Ant | 🟢 LOW | Testing | Browser testing, validation, regression, Playwright |
| 🛡️ | DevTools Sentinel Ant | 🟡 STANDARD | Browser Inspection | F12 scan, console audit, network audit, visual snapshot |
| ⚡ | DevTools Perf Ant | 🟡 STANDARD | Performance | CWV trace, throttle test, regression detection |
| 🌐 | DevTools Network Ant | 🟡 STANDARD | Network/State | Request validation, auth check, tenant isolation, state |
| 🔥⚡ | F12 Stress Tester Ant | 🟡 STANDARD | Stress Testing | Chat stress playbook, order flow validation, safety/privacy boundary |

**Risk levels affect gate behavior** (see `shared/NEO-GATES.md` Section 8):
- 🔴 **HIGH** — Extra scrutiny at every gate. Security/payment impact assessment required at FOOTPRINT.
- 🟠 **MEDIUM** — Validation-specific testing required at VERIFY gate.
- 🟡 **STANDARD** — Normal gate workflow.
- 🟢 **LOW** — Normal gate workflow.

---

## OBJECTIVE

<Clear description of what needs to be done. Be specific.>

---

## TARGET FILES

| File | Purpose |
|------|---------|
| <path/to/file.ts> | <what to do with this file> |
| <path/to/file2.ts> | <what to do with this file> |

---

## SUCCESS CRITERIA

The task is complete when ALL of these are true:

- [ ] <criterion 1 — specific, testable>
- [ ] <criterion 2 — specific, testable>
- [ ] <criterion 3 — specific, testable>

---

## DEFINITION OF DONE

Ghost will check the Ant's work against these criteria:

| Criterion | How to Verify |
|-----------|---------------|
| <criterion 1> | <verification method> |
| <criterion 2> | <verification method> |

---

## CRITICAL SURFACES (if any)

Files that require `🔑 CRITICAL SURFACE OVERRIDE` before editing:

| File | Category | Why Critical |
|------|----------|-------------|
| <path/to/file> | AUTH / DATA / DEPLOY / ENV / TENANT | <reason> |

*(Leave empty if no critical surfaces involved. See `shared/NEO-TOOLS.md` Section 5)*

---

## CONSTRAINTS

- <constraint 1 — e.g., "No breaking changes to public API">
- <constraint 2 — e.g., "Must be backwards compatible">
- <constraint 3 — e.g., "No new dependencies">

*(Leave empty if no specific constraints)*

---

## EVIDENCE BUDGET

| Phase | Max Files | Max Lines | Max Greps | Hive Reads |
|-------|-----------|-----------|-----------|------------|
| DISCOVERY | 5 | 200 | 10 | EXEMPT |
| FOOTPRINT | 3 | 150 | 5 | EXEMPT |

**To exceed:** Operator grants `🔑 BUDGET EXPANSION` (+5 files / +200 lines / +10 greps).
**Budget Ledger is MANDATORY** in DISCOVERY and FOOTPRINT outputs.

---

## ANT MISSION BRIEF (Planner-generated)

> **You already have your cards and protocol. This brief gives you the intel specific to THIS task.** Follow your cards as normal — this section just points you at the right targets.

### READ FIRST (Planner pre-selected)
| # | File | Lines | What to Look For |
|---|------|-------|-----------------|
| 1 | `<file1>` | <X-Y> | <what to look for> |
| 2 | `<file2>` | <X-Y> | <what to look for> |
| 3 | `<file3>` | (if needed) | <what to look for> |

### DISCOVERY QUESTION
> "<The one question this task must answer before changing code>"

### ACTIVE PHEROMONES ON TARGET
| PH-ID | File:Line | Warning |
|-------|-----------|---------|
| <PH-NNN> | <file:line> | <what it warns about> |

*(If none: "No active pheromones on target files.")*

### VERIFY WITH
- Build: `<project build command>`
- Test: `<project test command>`
- Task-specific: <specific check for this task — e.g., "F12 at 375px, confirm cart FAB visible">

### REMINDERS
- Backup: <CODE_ONLY / data-ops — create backup first>
- Follow your cards: CHECKPOINT → DISCOVERY → FOOTPRINT → BACKUP → PATCH → VERIFY → REPORT
- One gate per response — your cards tell you when to stop

*(Planner fills in the `<placeholders>` above. The Ant's cards handle everything else.)*

---

## OPERATOR MANUAL ALERTS (Planner-extracted danger zones)

> **Planner reads the Operator Manual and extracts ONLY the sections relevant to this task's target files.** The Ant does not need to search the manual — these warnings are pre-loaded.

*(If no relevant alerts: "No Operator Manual alerts for this task's target files.")*

| Alert | Source | Warning |
|-------|--------|---------|
| <alert type> | OPERATOR_MANUAL Section <N> | <exact warning text relevant to this task> |

---

## PRIOR WORK ON TARGET FILES (Planner-extracted from Hive Mind)

> **What previous Ants did on these exact files.** The Ant reads this to understand the history before making changes. This prevents re-doing completed work and respects past architectural decisions.

*(If no prior work: "No prior tasks touched these files — first work in this area.")*

| File | Last Task | Run | Ant Type | What Was Done | Outcome |
|------|-----------|-----|----------|---------------|---------|
| <path> | TASK-NNN | Run <N> | <emoji> <type> | <1-sentence summary of changes> | <APPROVED/REJECTED> |

---

## CONTEXT (Optional)

<Any background information the Ant needs to understand the task.
Related issues, prior work, design decisions, etc.>

---

## HIVE CONTEXT (Auto-populated by BECCA or Planner)

> BECCA populates this section automatically from the Hive Mind indexes before dispatching each Ant.
> This gives every Ant institutional memory about their target files.

### Target File History
*(From FILE_OWNERSHIP index — what happened to these files before)*

| File | Last Task | Last Ant Type | Last Change | Pheromones |
|------|-----------|---------------|-------------|------------|
| <path> | TASK-NNN | <emoji> <type> | <date> | <PH-NNN or NONE> |

### Active Pheromones
*(From PHEROMONE_REGISTRY — risks/warnings on target files)*

| PH-ID | Severity | Category | Target | Message | Age |
|-------|----------|----------|--------|---------|-----|
| PH-NNN | <emoji> | <category> | <file:line> | <message> | <N days> |

*(If none: "No active pheromones on target files.")*

### Top Lessons (Scored)
*(From LESSONS_INDEX — BECCA's weighted scoring selects the top 3 most relevant lessons)*

| Rank | L-ID | Score | Category | Lesson Summary |
|------|------|-------|----------|----------------|
| 1 | L-NNN | <score> | <category> | <1-sentence summary> |
| 2 | L-NNN | <score> | <category> | <1-sentence summary> |
| 3 | L-NNN | <score> | <category> | <1-sentence summary> |

*(See scoring function in NEO-BECCA.md. Lessons with GOTCHA/FRAGILE category are boosted.)*

**Injected Lesson IDs:** L-NNN, L-NNN, L-NNN
*(Machine-readable list for reinforcement tracking. Must match L-IDs in Top Lessons table above.)*
*(If no lessons injected: "None")*

### Rejection Patterns
*(From REJECTION_INDEX — what tripped up prior Ants on similar files/types)*

| Pattern | Occurrences | Last Seen | Rule | Stage |
|---------|-------------|-----------|------|-------|
| <rejection category> | <N> | Run <N> | <S-NN / V-NN> | <stage> |

*(If none: "No prior rejections for this Ant type or target files.")*

---

## STOP CONDITIONS

The Ant MUST STOP and ask the operator if:

- <condition 1 — e.g., "Architecture change needed">
- <condition 2 — e.g., "Missing design spec for UI">
- <condition 3 — e.g., "Security concern discovered">

---

## CARD DECK (CDEX — Generated by BECCA)

> **Prime directives:** "If it isn't on a card, it didn't happen." / "If it didn't produce a receipt, it isn't accepted."

**DECK_ID:** DECK-<TASK_ID>

### CORE Cards (MANDATORY — all runs)

| Order | Card ID | Card | Waiver? |
|-------|---------|------|---------|
| 1 | CORE-001 | Load Policy Pack + Pheromones | NO — never waivable |
| 2 | CORE-002 | Backup-First Proof | CONDITIONAL — waive if CODE_ONLY |
| 3 | CORE-003 | Scope Lock | NO — never waivable |
| 4 | CORE-004 | Evidence Capture Plan | NO — never waivable |
| 5 | CORE-005 | Post-Change Verification | NO — never waivable |

### TASK Cards (per-task — generated from task type)

| Order | Card ID | Card | Phase |
|-------|---------|------|-------|
| 6 | TASK-001 | ANT_CHECKPOINT | Activation |
| 7 | TASK-002 | ANT_DISCOVERY | Discovery |
| 8 | TASK-003 | ANT_FOOTPRINT | Footprint |
| 9 | TASK-004 | ANT_BACKUP (if data ops) | Backup |
| 10 | TASK-005 | ANT_PATCH | Patch |
| 11 | TASK-006 | ANT_VERIFY | Verify |
| 12 | TASK-007 | ANT_REPORT | Report |

### TOOL Cards (project-specific — from Operator Manual)

| Order | Card ID | Card | Source |
|-------|---------|------|--------|
| — | TOOL-001 | <project test command> | OPERATOR_MANUAL |
| — | TOOL-002 | <project build command> | OPERATOR_MANUAL |
| — | TOOL-003 | <project deploy command> | OPERATOR_MANUAL |

*(BECCA populates TOOL cards from the project's Operator Manual during RECON)*

### Card Execution Rules

1. Execute cards IN ORDER — no skipping ahead
2. Every card produces an OUTPUT — attach to CARD_RECEIPT
3. Skipping requires a CARD_WAIVER (reason + risk + mitigation + approver)
4. Missing CARD_RECEIPT in final report → S-38 (output invalid)
5. CORE card skipped without waiver → S-39 (NUCLEAR)

---

## PROTOCOL CARDS

Load cards in sequence as you progress through phases:
1. `cards/ant/ANT_CHECKPOINT.md` → complete → proceed
2. `cards/ant/ANT_DISCOVERY.md` → complete → present → wait for gate
3. `cards/ant/ANT_FOOTPRINT.md` → complete → present → wait for gate
4. `cards/ant/ANT_BACKUP.md` → (if data ops) → complete → wait for gate
5. `cards/ant/ANT_PATCH.md` → complete → present → wait for gate
6. `cards/ant/ANT_VERIFY.md` → complete → present → wait for gate
7. `cards/ant/ANT_REPORT.md` → complete → present → wait for gate

Reference cards (load once, keep available):
- `cards/ref/GATE_TOKENS.md`
- `cards/ref/STOP_CONDITIONS.md`

---

## APPROVAL

🔑 TASK ASSIGNED: <TASK_ID> → Ant
