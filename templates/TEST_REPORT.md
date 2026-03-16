# TEST_REPORT: <TASK_ID>

NEO_STATE: REPORT
ROLE: Ant (Debugger)
TASK_ID: <TASK_ID>
ANT_TYPE: 🐛 Debugger Ant
DATE: <YYYY-MM-DD>

---

## 1. TASK SUMMARY

| Field | Value |
|-------|-------|
| Task ID | <TASK_ID> |
| Ant Type | 🐛 Debugger Ant |
| Risk Level | 🟡 STANDARD |
| Objective | <what needs to be diagnosed> |
| Status | DIAGNOSED / HALTED |
| Target Files | <file list> |

<1-2 sentence summary of the diagnosis>

---

## 2. ENVIRONMENT SNAPSHOT

| Field | Value |
|-------|-------|
| Node.js | <version from `node -v`> |
| npm/bun | <version from `npm -v` or `bun -v`> |
| Framework | <Next.js / React / etc. + version from package.json> |
| Browser tested | <Chrome / Firefox / Safari + version, or "N/A — backend only"> |
| OS | <Windows 11 / macOS / Linux> |
| Firebase project | <project ID from `.firebaserc`, or "N/A"> |
| Dev server | <localhost:PORT, or "not running"> |
| Sentry DSN | <configured / not configured> |

**Why this matters:** Rules out "works on my machine" — the fixing Ant inherits the exact environment context.

---

## 3. REPRODUCTION STEPS

**Can reproduce?** YES / NO / INTERMITTENT

**Steps to trigger the bug:**
1. <exact step — e.g., "Navigate to /settings/billing">
2. <exact step — e.g., "Click 'Update Plan' button">
3. <exact step — e.g., "Select 'Pro' tier and submit">
4. <exact step — e.g., "Observe: spinner never stops, console shows 403">

**Reproduction evidence:**

| Evidence | Source | Path/Reference |
|----------|--------|----------------|
| Screenshot at failure | Chrome DevTools / Playwright | <screenshot path or inline> |
| Console errors | `list_console_messages` | <error text or msgid> |
| Network failure | `list_network_requests` | <URL + status code + reqid> |
| Sentry event | Sentry MCP | <event ID or issue URL> |

**If cannot reproduce:**
- <what was tried>
- <what differs from the operator's report>
- <recommendation: more info needed / intermittent / environment-specific>

*(If backend-only bug: write "Backend bug — no browser reproduction. Diagnosed from code + logs.")*

---

## 4. HYPOTHESIS

**Initial hypothesis:**
<What do you think is wrong, based on the task description and initial reading?>

**Hypothesis formed from:**
- <evidence 1 — file:line>
- <evidence 2 — file:line>
- <evidence 3 — runtime observation from DevTools/Playwright/Sentry>

---

## 5. TEST PLAN

| # | Test | Purpose | Expected Result |
|---|------|---------|-----------------|
| 1 | <test description> | <what it validates> | <expected outcome> |
| 2 | <test description> | <what it validates> | <expected outcome> |

---

## 6. RESULTS

| # | Test | Result | Evidence |
|---|------|--------|----------|
| 1 | <test description> | PASS / FAIL / INCONCLUSIVE | <output or path> |
| 2 | <test description> | PASS / FAIL / INCONCLUSIVE | <output or path> |

### Runtime Observations

| Source | Finding |
|--------|---------|
| Console | <errors/warnings captured via DevTools or Playwright> |
| Network | <failed requests: URL, status, response body summary> |
| DOM state | <unexpected elements, missing nodes, stale renders> |
| Performance | <CWV scores, slow renders, long tasks — if perf trace was run> |
| Sentry | <production error events, breadcrumbs, affected users count> |
| Firebase logs | <Cloud Functions errors, Firestore query results> |

*(Omit rows where the source was not used. Minimum 1 row required.)*

### Detailed Output

```
<actual test output, error messages, stack traces>
```

---

## 7. DIAGNOSIS

**Root cause:** <one sentence — what is actually wrong>

**Detailed analysis:**
<explain the root cause with evidence from the test results and runtime observations>

**Confidence level:** HIGH / MEDIUM / LOW

**Evidence chain:**
1. <symptom> → observed via <tool/source>
2. <investigation> → found <specific code/data issue> at <file:line>
3. <confirmation> → test/runtime evidence proves <root cause>

**If MEDIUM or LOW confidence:**
- <what additional investigation is needed>
- <what couldn't be determined and why>

---

## 8. RECOMMENDED ANT TYPE FOR FIX

| Field | Value |
|-------|-------|
| Recommended Ant Type | <emoji> <type name> |
| Why this type | <rationale> |
| Estimated fix scope | <files to change, approx line count> |
| Fix priority | HIGH / MEDIUM / LOW |

**Recommended approach for the fixing Ant:**
1. <step 1>
2. <step 2>
3. <step 3>

---

## 9. EVIDENCE INDEX

| Claim | Evidence | Source |
|-------|----------|--------|
| Bug reproduced | <screenshot/recording path> | Chrome DevTools / Playwright |
| Root cause identified | <file:line + explanation> | Code inspection |
| Runtime error captured | <console message or network failure> | DevTools / Sentry |
| Tests run | <test output path or inline> | Jest / Vitest |
| Data state verified | <Firestore query result> | Firebase MCP |
| Diagnosis supported | <evidence chain summary> | Combined |

**All paths must be real. No placeholders. All evidence must come from actual tool output.**

---

## 10. PHEROMONES EMITTED

| Severity | Category | Target | Message |
|----------|----------|--------|---------|
| <⚫/🔴/🟠/🟡/🟢> | <category> | <file:line> | <description> |

*(If no pheromones: write "No pheromones emitted." — do NOT omit this section.)*

---

## 11. HANDOFF

| Field | Value |
|-------|-------|
| Report written to | .neo/outbox/ants/TEST_REPORT_<TASK_ID>.md |
| Next step | Hand off to <recommended Ant type> |
| Ready for handoff | YES / NO |
| Diagnostic tools used | <list: DevTools, Playwright, Sentry, Firebase, etc.> |

**The Debugger Ant has completed its diagnosis. It does NOT fix the issue.**

---

## APPROVAL

🔑 REPORT APPROVED: TASK <TASK_ID> DIAGNOSED — READY FOR HANDOFF TO <ANT_TYPE>
