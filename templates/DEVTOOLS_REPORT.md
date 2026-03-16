# DEVTOOLS REPORT — Run {RUN_NUMBER}

**Date:** {DATE}
**Project:** {PROJECT_NAME}
**Tasks in Run:** {TASK_COUNT}
**Ants Dispatched:** Sentinel {+ Perf} {+ Network}

---

## 1. RUN CONTEXT

| Field | Value |
|-------|-------|
| Run | {RUN_NUMBER} |
| Pages Inspected | {PAGE_COUNT} |
| Sentinel Dispatched | YES |
| Perf Dispatched | YES / NO (trigger: {reason}) |
| Network Dispatched | YES / NO (trigger: {reason}) |
| App URL | {URL} |
| Prior Baseline | {YES — Run N / NO — first run} |

---

## 2. PAGE INVENTORY

| # | Route | Source Task | Modified Files | Notes |
|---|-------|-----------|----------------|-------|
| 1 | {/route} | TASK-{NNN} | {file1, file2} | {auth required, new route, etc.} |

---

## 3. SENTINEL SCAN RESULTS

### Console Audit

| # | Page | Type | Message (truncated) | Severity | Evidence |
|---|------|------|---------------------|----------|----------|
| 1 | {route} | {error/warn/log} | {message} | {BLOCKING/ADVISORY/PASS} | {path} |

### Network Audit

| # | Page | URL | Method | Status | Size | Time | Severity | Evidence |
|---|------|-----|--------|--------|------|------|----------|----------|
| 1 | {route} | {url} | {GET/POST} | {200/500} | {KB} | {ms} | {BLOCKING/ADVISORY/PASS} | {path} |

### Visual Baseline

| # | Page | Screenshot | Snapshot | Load Time |
|---|------|-----------|----------|-----------|
| 1 | {route} | {path} | {path} | {ms} |

---

## 4. PERF ANALYSIS (if dispatched)

### Baseline Metrics

| Metric | {Page 1} | {Page 2} | Target | Status |
|--------|----------|----------|--------|--------|
| LCP | {ms} | {ms} | <2500ms | {✅/❌} |
| FCP | {ms} | {ms} | <1800ms | {✅/❌} |
| CLS | {val} | {val} | <0.1 | {✅/❌} |
| TBT | {ms} | {ms} | <200ms | {✅/❌} |
| TTFB | {ms} | {ms} | <800ms | {✅/❌} |

### Throttled Metrics (Slow 4G + 4x CPU)

| Metric | {Page 1} | {Page 2} | Delta from Baseline |
|--------|----------|----------|---------------------|
| LCP | {ms} | {ms} | {+N%} |
| FCP | {ms} | {ms} | {+N%} |
| CLS | {val} | {val} | {+N} |
| TBT | {ms} | {ms} | {+N%} |

### Regression Check (vs Prior Run)

| Metric | Prior | Current | Delta | Status |
|--------|-------|---------|-------|--------|
| LCP | {ms} | {ms} | {±N%} | {✅/⚠️/❌} |

---

## 5. NETWORK ANALYSIS (if dispatched)

### Request Validation

| # | Flow | URL | Auth | Tenant | PII-Safe | Status | Evidence |
|---|------|-----|------|--------|----------|--------|----------|
| 1 | {checkout} | {url} | {✅/❌} | {✅/❌} | {✅/❌} | {200} | {path} |

### State Validation

| Check | Expected | Actual | Status |
|-------|----------|--------|--------|
| Auth token location | httpOnly cookie | {actual} | {✅/❌} |
| Tenant isolation | restaurantId scoped | {actual} | {✅/❌} |
| No PII in URLs | clean | {actual} | {✅/❌} |
| localStorage safe | no secrets | {actual} | {✅/❌} |

---

## 6. EVIDENCE INDEX

| # | Type | File Path | Description |
|---|------|-----------|-------------|
| 1 | screenshot | {path} | {page route — visual state} |
| 2 | snapshot | {path} | {page route — a11y tree} |
| 3 | trace | {path} | {page route — perf trace} |
| 4 | network | {path} | {flow — request/response} |

---

## 7. VERDICT

```
DEVTOOLS VERIFICATION — Run {RUN_NUMBER}
══════════════════════════════════════════

Sentinel: {PASS / FAIL_ADVISORY / FAIL_BLOCKING}
Perf:     {PASS / REGRESSION_DETECTED / NOT_DISPATCHED}
Network:  {PASS / FAIL_ADVISORY / FAIL_BLOCKING / NOT_DISPATCHED}

OVERALL:  {PASS / FAIL_ADVISORY / FAIL_BLOCKING}

BLOCKING ISSUES:
  {None / numbered list with evidence citations}

ADVISORY ISSUES:
  {None / numbered list with evidence citations}

SPECIALIST TRIGGERS DETECTED:
  {None / ⚡ Perf: reason / 🌐 Network: reason}
```
