# F12 CONSOLE AUDIT CARD
**CARD_ID:** F12-002 | **Phase:** SCAN | **Role:** DevTools Sentinel Ant
**INPUTS:** Page inventory from F12-001, app loaded in browser
> Read this card after F12_SETUP. Follow every □ item for EACH page in inventory.

## 1. CAPTURE CONSOLE MESSAGES
□ For each page in inventory:
  □ `select_page` (if multiple tabs)
  □ `list_console_messages` → capture all messages since navigation
  □ Record count by type: error, warn, log, info

## 2. CLASSIFY EACH MESSAGE

| Type | Pattern | Classification |
|------|---------|---------------|
| `error` | Uncaught exception / unhandled rejection | FAIL_BLOCKING |
| `error` | React hydration mismatch | FAIL_BLOCKING |
| `error` | Failed to fetch / network error | FAIL_BLOCKING |
| `error` | Firebase auth error | FAIL_BLOCKING |
| `warn` | Deprecation warning | FAIL_ADVISORY |
| `warn` | Missing React key prop | FAIL_ADVISORY |
| `warn` | Component unmounted during async | FAIL_ADVISORY |
| `log` | Debug output (console.log in production) | FAIL_ADVISORY |
| `info` | Expected application logging | PASS |

□ For each FAIL_BLOCKING message:
  □ `get_console_message(msgid)` → capture full stack trace
  □ Record: message text, stack trace, page route

## 3. PRODUCE CONSOLE FINDINGS TABLE
□ Fill table:

| # | Page | Type | Message (first 100 chars) | Severity | Evidence |
|---|------|------|---------------------------|----------|----------|
| 1 | {route} | {error} | {text} | {BLOCKING} | {msgid} |

□ Summary: {N} blocking, {M} advisory, {K} pass

## 4. TRANSITION
□ Console audit complete for all pages

```
🛑 END RESPONSE HERE. Write this as your LAST line:
⏸️ Console audit complete. {N} blocking, {M} advisory findings.
Do NOT produce network audit output in this same response.
```

□ → In your NEXT response, load **F12_NETWORK_AUDIT** card

## STOP CONDITIONS THIS PHASE
- Page crashes during console read → record FAIL_BLOCKING, continue to next page
- Console output exceeds 500 messages → capture first 100 + last 50, note truncation
