# F12 PERF TRACE CARD
**CARD_ID:** F12-005 | **Phase:** TRACE | **Role:** DevTools Perf Ant
**INPUTS:** Target pages from F12-001, dispatch trigger from BECCA
> Read this card after F12_SETUP. Follow every □ item for EACH target page.

## 1. BASELINE TRACE
□ For each target page:
  □ `navigate_page` to target route
  □ `wait_for` page content to load
  □ Run trace:
    ```
    performance_start_trace(reload: true, autoStop: true)
    ```
  □ Record baseline CWV metrics:

| Metric | Value | Target | Status |
|--------|-------|--------|--------|
| LCP | {ms} | <2500ms | {✅/❌} |
| FCP | {ms} | <1800ms | {✅/❌} |
| CLS | {val} | <0.1 | {✅/❌} |
| TBT | {ms} | <200ms | {✅/❌} |
| TTFB | {ms} | <800ms | {✅/❌} |

## 2. ANALYZE INSIGHTS
□ Review trace insights from step 1 results
□ For each highlighted insight:
  □ `performance_analyze_insight` → get details
  □ Record: insight name, severity, recommendation
□ Check for:
  □ Long tasks > 50ms → record count and duration
  □ Layout shifts during interaction → record CLS contributors
  □ Render-blocking resources → record resource URLs
  □ Excessive DOM size (> 1500 nodes)

## 3. THROTTLED TRACE
□ Apply throttling:
  □ `emulate(networkConditions: "Slow 4G", cpuThrottlingRate: 4, viewport: {width: 375, height: 812, isMobile: true, hasTouch: true})`
□ Run throttled trace:
  □ `performance_start_trace(reload: true, autoStop: true)`
□ Record throttled metrics (same table format as step 1)
□ Reset emulation:
  □ `emulate(networkConditions: "No emulation", cpuThrottlingRate: 1, viewport: null)`

## 4. COMPARISON
□ Build comparison table:

| Metric | Baseline | Throttled | Prior Run | Delta | Status |
|--------|----------|-----------|-----------|-------|--------|
| LCP | {ms} | {ms} | {ms or N/A} | {±N%} | {✅/⚠️/❌} |
| FCP | {ms} | {ms} | {ms or N/A} | {±N%} | {✅/⚠️/❌} |
| CLS | {val} | {val} | {val or N/A} | {±N} | {✅/⚠️/❌} |
| TBT | {ms} | {ms} | {ms or N/A} | {±N%} | {✅/⚠️/❌} |
| TTFB | {ms} | {ms} | {ms or N/A} | {±N%} | {✅/⚠️/❌} |

□ Status: ✅ within target, ⚠️ degraded but within, ❌ exceeds target
□ Regression = any metric > 20% worse than prior run

## 5. PERF VERDICT
□ Aggregate findings:

```
DEVTOOLS PERF VERDICT
═════════════════════
Pages profiled: {N}
Regressions: {N}
Warnings: {N}

VERDICT: PASS / REGRESSION_DETECTED

REGRESSIONS:
  {numbered list: page, metric, prior → current, delta%, evidence}

WARNINGS:
  {numbered list: page, pattern, evidence}
```

□ Save verdict to PERF section of DEVTOOLS_REPORT

```
🛑 END RESPONSE HERE. Write this as your LAST line:
⏸️ Perf Ant complete. Verdict: {VERDICT}. {N} regressions, {M} warnings.
Do NOT produce further output. Hand off to BECCA.
```

## STOP CONDITIONS THIS PHASE
- Trace fails to capture → retry once, then record tool error and continue
- Page crashes during trace → record as REGRESSION, continue to next page
- Emulation reset fails → STOP — request operator to manually reset browser
