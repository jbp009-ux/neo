# F12 NETWORK AUDIT CARD
**CARD_ID:** F12-003 | **Phase:** SCAN | **Role:** DevTools Sentinel Ant + Network Ant
**INPUTS:** Page inventory from F12-001, app loaded in browser
> Read this card after F12_CONSOLE_AUDIT (Sentinel) or F12_SETUP (Network).

## 1. CAPTURE NETWORK REQUESTS
□ For each page in inventory:
  □ `select_page` (if multiple tabs)
  □ `list_network_requests` → capture all HTTP activity
  □ Filter to API calls: resourceTypes = ["xhr", "fetch"]
  □ Record total request count and failed request count

## 2. FLAG ISSUES (per request)

| Pattern | Severity |
|---------|----------|
| 5xx response status | FAIL_BLOCKING |
| 4xx status (not expected 404) | FAIL_BLOCKING |
| Auth token in URL query string | FAIL_BLOCKING |
| PII in request URL (email, phone) | FAIL_BLOCKING |
| Mixed HTTP/HTTPS content | FAIL_BLOCKING |
| Duplicate identical requests (3+) | FAIL_ADVISORY |
| Request time > 5s | FAIL_ADVISORY |
| Response size > 1MB (API call) | FAIL_ADVISORY |
| Missing Cache-Control on static | FAIL_ADVISORY |

□ For each FAIL_BLOCKING request:
  □ `get_network_request(reqid)` → capture request headers + response body
  □ Check: auth headers present? Tenant ID scoped? Response structure valid?

## 3. DEEP INSPECTION (Network Ant only)
□ If dispatched as Network Ant (not Sentinel):
  □ For EACH API call (not just failures):
    □ `get_network_request(reqid)` → full request/response
    □ Validate auth header format (Bearer token present)
    □ Validate tenant isolation (restaurantId in path/body)
    □ Check for PII exposure in response body
    □ Check CORS headers (if cross-origin)

## 4. PRODUCE NETWORK FINDINGS TABLE
□ Fill table:

| # | Page | URL | Method | Status | Size | Time | Severity | Evidence |
|---|------|-----|--------|--------|------|------|----------|----------|
| 1 | {route} | {url} | {GET} | {200} | {KB} | {ms} | {PASS} | {reqid} |

□ Summary: {N} blocking, {M} advisory, {K} pass

## 5. TRANSITION
□ Network audit complete for all pages

```
🛑 END RESPONSE HERE. Write this as your LAST line:
⏸️ Network audit complete. {N} blocking, {M} advisory findings.
Do NOT produce next card output in this same response.
```

□ → In your NEXT response, load the appropriate card:
□ Sentinel → Load **F12_VISUAL_SNAPSHOT** card
□ Network Ant → Load **F12_STATE_INSPECTION** card

## STOP CONDITIONS THIS PHASE
- Page crashes during network capture → record FAIL_BLOCKING, continue to next page
- Network requests exceed 200 → capture first 100 API calls, note truncation
- Auth endpoint requires real credentials → use test/demo mode only
