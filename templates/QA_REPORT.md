# QA_REPORT: <TASK_ID>

NEO_STATE: REPORT
ROLE: QA Ant (Browser Verification)
TASK_ID: <TASK_ID>
VERIFYING: <TASK-NNN — the builder Ant's task being tested>
DATE: <YYYY-MM-DD>

---

## 1. TEST SUMMARY

| Field | Value |
|-------|-------|
| QA Task ID | <TASK_ID> |
| Builder Task | <TASK-NNN — what was built> |
| Feature Tested | <what feature was verified> |
| App URL | <URL tested — localhost:3000 or deployed URL> |
| Browser | Chromium (via Playwright MCP) |
| Verdict | **PASS** / **FAIL** |

<1-2 sentence summary of QA results>

---

## 2. BUILDER ANT REVIEW

**Builder Ant Report read:** `ANT_REPORT_<TASK-NNN>.md`

| What Was Built | Expected Behavior |
|----------------|-------------------|
| <feature/change 1> | <what should happen> |
| <feature/change 2> | <what should happen> |

**Test plan derived from builder report:**
1. <test case 1 — happy path>
2. <test case 2 — error path>
3. <test case 3 — edge case>

---

## 3. TEST RESULTS

### Test Case 1: <name>

| Step | Action | Expected | Actual | Status |
|------|--------|----------|--------|--------|
| 1 | <navigate to X> | <page loads> | <what happened> | PASS/FAIL |
| 2 | <click Y> | <Z appears> | <what happened> | PASS/FAIL |
| 3 | <fill form> | <form accepts> | <what happened> | PASS/FAIL |
| 4 | <submit> | <API call succeeds> | <what happened> | PASS/FAIL |

**Screenshot:** <description — before/after>
**Network:** <API call URL — status code — response summary>
**Console:** <errors/warnings — or "Clean">

*(Repeat for each test case)*

---

## 4. NETWORK EVIDENCE

| # | Method | URL | Status | Response Summary |
|---|--------|-----|--------|-----------------|
| 1 | POST | <api/endpoint> | 200 | `{ success: true, ... }` |
| 2 | GET | <api/endpoint> | 200 | `{ data: [...] }` |

**Key API call detail (most important):**
```
URL: <full URL>
Method: <POST/GET/PUT/DELETE>
Status: <code>
Response: <abbreviated response body — key fields only>
```

---

## 5. CONSOLE OUTPUT

| Level | Message | Source |
|-------|---------|--------|
| ERROR | <message> | <file:line or "unknown"> |
| WARN | <message> | <source> |

*(If clean: "No console errors or warnings detected.")*

---

## 6. SCREENSHOT INDEX

| # | Description | State |
|---|-------------|-------|
| 1 | <page before interaction> | BEFORE |
| 2 | <page after feature used> | AFTER |
| 3 | <error state — if tested> | ERROR |

*(Screenshots captured via Playwright MCP `browser_screenshot`)*

---

## 7. VERDICT

### Overall: **PASS** / **FAIL**

| Category | Result | Evidence |
|----------|--------|----------|
| Happy path works | PASS/FAIL | <test case reference> |
| Error handling works | PASS/FAIL/NOT TESTED | <test case reference> |
| No console errors | PASS/FAIL | <console section reference> |
| API responses correct | PASS/FAIL | <network section reference> |
| UI renders correctly | PASS/FAIL | <screenshot reference> |

### If FAIL — Defects Found

| # | Severity | Description | Steps to Reproduce | Expected vs Actual |
|---|----------|-------------|--------------------|--------------------|
| 1 | HIGH/MED/LOW | <what's broken> | <click X → see Y> | <expected Z but got W> |

### Recommendation

- **PASS:** Feature is working. Ready for CLOSE.
- **FAIL:** Dispatch builder Ant to fix defect(s) before CLOSE.

---

## 8. HANDOFF

| Field | Value |
|-------|-------|
| Report written to | `.neo/outbox/ants/QA_REPORT_<TASK_ID>.md` |
| Builder task verified | <TASK-NNN> |
| Next step | BECCA CLOSE (if PASS) / Builder Ant fix (if FAIL) |

---

🔑 QA REPORT COMPLETE: <TASK_ID> — VERDICT: **PASS/FAIL**
