# BECCA CLOSE — DEVTOOLS VERIFICATION
**CARD_ID:** BECCA-CLOSE-DEVTOOLS | **Phase:** CLOSE | **Role:** BECCA
**INPUTS:** All Ant reports from this run, prior DEVTOOLS_REPORT (if exists), trigger rules
> Read this card after BECCA_CLOSE_ANALYTICS. This is a HARD GATE — no merge without clearance.

□ At each CHECKPOINT below, update `.neo/STATE.md` with:
  `CLOSE_PROGRESS: card: CLOSE_DEVTOOLS | checkpoint: <N>`
  `CLOSE_LAST_CARD: CLOSE_DEVTOOLS`
  `CLOSE_LAST_CHECKPOINT: <N>`

## 1. TRIGGER ASSESSMENT
□ Scan all Ant reports from this run: which files were modified?
□ Build MODIFIED FILES list from all reports

### Change-Based Triggers
□ Match modified files against trigger table:

| Trigger | File Patterns | Dispatches |
|---------|--------------|-----------|
| Checkout/payment | `checkout/`, `payment`, `stripe`, `billing` | 🌐 Network Ant |
| Auth/session | `auth`, `session`, `middleware`, `login`, `signup` | 🌐 Network Ant |
| Shared modules | `lib/`, `hooks/`, `context/`, `types/` | ⚡ Perf + 🌐 Network |
| HIGH/NUCLEAR pheromone | Pheromone severity ≥ HIGH on changed files | ⚡ Perf + 🌐 Network |
| New routes | New files in `app/` directory | 🛡️ Sentinel (adds pages) |
| Golden menu boundary | `goldenMenu`, `publishedMenu`, `menu/items` | 🛡️ Sentinel only |

### Symptom-Based Triggers
□ Read prior DEVTOOLS_REPORT (if exists):

| Trigger | Prior Report Shows | Dispatches |
|---------|-------------------|-----------|
| Console errors | FAIL_ADVISORY for console in prior run | 🛡️ Sentinel (verify fix) |
| Network failures | 4xx/5xx in prior run | 🌐 Network Ant |
| Duplicate requests | Same endpoint 3+ times | 🌐 Network Ant |
| Perf regression | CWV worse than baseline | ⚡ Perf Ant |

□ Result — DISPATCH LIST:
  - 🛡️ Sentinel: ALWAYS (mandatory every closeout)
  - ⚡ Perf: {YES — trigger reason / NO}
  - 🌐 Network: {YES — trigger reason / NO}

## 2. DISPATCH CHIEF SENTINEL (mandatory)
□ Create task packet for 🛡️ DevTools Sentinel Ant:
  - Target: ALL pages/routes modified in this run
  - Prior baseline: from last DEVTOOLS_REPORT (if exists)
  - Context: trigger assessment results
□ Present to operator: "Dispatching DevTools Sentinel. I AM?"
□ WAIT for operator "I AM" confirmation
□ Sentinel executes: F12-001 → F12-002 → F12-003 → F12-004 → VERDICT
□ Receive DEVTOOLS_REPORT (Sentinel section)
□ Record in STATE.md: `DEVTOOLS_CHIEF: COMPLETE`
□ Gate: 🔑 DEVTOOLS_CHIEF COMPLETE

**□ CHECKPOINT 6a:** Sentinel complete? Review verdict before dispatching specialists.

## 3. DISPATCH SPECIALISTS (if triggered)
□ If ⚡ Perf triggered OR Sentinel flagged perf issue:
  □ Create task packet for ⚡ DevTools Perf Ant:
    - Target: pages with perf concerns
    - Prior baseline: from last DEVTOOLS_REPORT perf section (if exists)
  □ Present to operator: "Dispatching Perf Ant. I AM?"
  □ Perf executes: F12-001 → F12-005 → VERDICT
  □ Receive DEVTOOLS_REPORT (Perf section)
□ If 🌐 Network triggered OR Sentinel flagged network issue:
  □ Create task packet for 🌐 DevTools Network Ant:
    - Target: flows with network/security concerns
    - Context: Sentinel's network findings
  □ Present to operator: "Dispatching Network Ant. I AM?"
  □ Network executes: F12-001 → F12-003 → F12-006 → VERDICT
  □ Receive DEVTOOLS_REPORT (Network section)
□ If no specialists triggered:
  □ Record: `DEVTOOLS_ESCALATED: NONE`
□ Gate: 🔑 DEVTOOLS_SPECIALISTS COMPLETE (or SKIPPED)

## 3b. DISPATCH STRESS TESTER (if AI chat modified)
□ Check if ANY Ant in this run modified chat/AI/ordering files:

| Trigger | File Patterns | Action |
|---------|--------------|--------|
| Chat/AI modified | `chat/`, `ai/`, `gemini`, `openai`, `order`, `menu`, `voice` | Dispatch stress |
| Allergy/safety modified | `allergy`, `dietary`, `safety` | Dispatch stress |
| Payment flow modified | `checkout`, `payment`, `cart`, `pricing` | Dispatch stress |
| Prior stress failures | STRESS_REPORT had FAIL in prior run | Dispatch stress (regression) |

□ If triggered:
  □ Create task packet for 🔥⚡ F12 Stress Tester Ant:
    - Playbook: `templates/F12_STRESS_PLAYBOOK.yaml` (baseline 25, expanded 64, or operator subset)
    - Target: chat page URL
    - Prior baseline: from last STRESS_REPORT (if exists)
  □ Present to operator: "Dispatching Stress Tester. I AM?"
  □ Stress Tester executes: F12-001 → F12-007 → VERDICT
  □ Receive STRESS_REPORT section for DEVTOOLS_REPORT
  □ Record in STATE.md: `DEVTOOLS_STRESS: COMPLETE`
□ If not triggered:
  □ Record: `DEVTOOLS_STRESS: NOT_TRIGGERED`
□ Gate: 🔑 DEVTOOLS_STRESS COMPLETE (or SKIPPED)

**□ CHECKPOINT 6b:** All DevTools Ants complete (including stress if triggered)? Aggregate verdict.

## 4. DEVTOOLS VERDICT
□ Aggregate all DEVTOOLS_REPORT sections
□ Check for FAIL_BLOCKING verdicts across all Ants

### If ANY FAIL_BLOCKING:
□ Present to operator:
  ```
  ⚠️ DEVTOOLS VERIFICATION BLOCKED

  Blocking issues:
    1. {finding — evidence path}
    2. ...

  Options:
    (a) Fix issues and re-run DevTools verification
    (b) Override with justification (recorded in RUN_INDEX)
    (c) Abort closeout — return to HANDOFF state
  ```
□ If operator chooses (a): re-dispatch affected Ant(s)
□ If operator chooses (b): record DEVTOOLS_OVERRIDE in RUN_INDEX with justification
□ If operator chooses (c): STOP closeout

### If all PASS or FAIL_ADVISORY only:
□ Log advisory items in DEVTOOLS_REPORT
□ Record in STATE.md: `DEVTOOLS_CHIEF: COMPLETE`
□ Record in STATE.md: `DEVTOOLS_EVIDENCE: {file paths}`

□ Gate: 🔑 DEVTOOLS VERIFICATION APPROVED

## 5. TRANSITION
□ Present DevTools summary:
  ```
  DEVTOOLS VERIFICATION — Run {N}
  Sentinel: {PASS/FAIL_ADVISORY/FAIL_BLOCKING}
  Perf:     {verdict or NOT_DISPATCHED}
  Network:  {verdict or NOT_DISPATCHED}
  Stress:   {verdict or NOT_TRIGGERED}
  OVERALL:  {PASS/FAIL_ADVISORY/OVERRIDE}
  ```
□ Update STATE.md: `CLOSE_PROGRESS: card: CLOSE_DEVTOOLS | complete`

```
🛑 END RESPONSE HERE. Write this as your LAST line:
⏸️ DEVTOOLS complete. Loading GOVERNANCE.
Do NOT skip ahead. Do NOT produce a COMPLETION REPORT yet.
The operator says "continue" → you load BECCA_CLOSE_GOVERNANCE card.
```

## STOP CONDITIONS THIS PHASE
- S-40: DevTools verification skipped — Chrome DevTools MCP not available → STOP, operator must configure before closeout
- All FAIL_BLOCKING and operator chooses abort → return to HANDOFF
- Operator override recorded → proceed with justification logged
