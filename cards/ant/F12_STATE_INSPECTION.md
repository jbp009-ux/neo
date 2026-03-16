# F12 STATE INSPECTION CARD
**CARD_ID:** F12-006 | **Phase:** VALIDATE | **Role:** DevTools Network Ant
**INPUTS:** Network findings from F12-003, target flows from BECCA dispatch
> Read this card after F12_NETWORK_AUDIT. Follow every □ item.

## 1. SESSION STATE CHECK
□ Run read-only JS to inspect client storage:
  ```
  evaluate_script(() => ({
    localStorageKeys: Object.keys(localStorage),
    sessionStorageKeys: Object.keys(sessionStorage),
    cookieNames: document.cookie.split(';').map(c => c.trim().split('=')[0]).filter(Boolean)
  }))
  ```
□ Check:
  □ No auth tokens in localStorage (should be httpOnly cookies)
  □ No passwords or secrets stored client-side
  □ No PII stored unencrypted in localStorage
  □ Session data size reasonable (< 5MB)

## 2. AUTH STATE CHECK
□ Verify authentication state matches expected:
  ```
  evaluate_script(() => ({
    hasFirebaseUser: typeof firebase !== 'undefined' && !!firebase.auth?.().currentUser,
    documentCookies: document.cookie.length,
    windowAuthKeys: Object.keys(window).filter(k =>
      k.toLowerCase().includes('auth') || k.toLowerCase().includes('token')
    )
  }))
  ```
□ Check:
  □ Auth state present when flow requires authentication
  □ No auth state leaked to window globals
  □ Token not accessible via JS (httpOnly flag working)

## 3. APPLICATION STATE CHECK
□ Inspect application-level state:
  ```
  evaluate_script(() => ({
    globalKeys: Object.keys(window).filter(k => k.startsWith('__')),
    errorCount: (window.__errors || []).length,
    nextData: !!window.__NEXT_DATA__,
    reactRoots: document.querySelectorAll('[data-reactroot], #__next').length
  }))
  ```
□ Check:
  □ No orphaned global state (unexpected __ prefixed keys)
  □ No accumulated error objects
  □ React app mounted correctly (root element present)
  □ Next.js data hydrated (\_\_NEXT_DATA\_\_ present)

## 4. TENANT ISOLATION CHECK
□ Review all API responses captured in F12-003:
  □ Every Firestore path includes correct restaurantId?
  □ No cross-tenant data visible in any response?
  □ Demo tenant bypass active ONLY for known demo IDs?
  □ Admin endpoints require appropriate role claims?

| Check | Expected | Actual | Status |
|-------|----------|--------|--------|
| Auth token location | httpOnly cookie | {actual} | {✅/❌} |
| No secrets in localStorage | clean | {actual} | {✅/❌} |
| Tenant isolation | restaurantId scoped | {actual} | {✅/❌} |
| No PII in URLs | clean | {actual} | {✅/❌} |
| React app mounted | root present | {actual} | {✅/❌} |
| No global state leaks | clean | {actual} | {✅/❌} |

## 5. NETWORK VERDICT
□ Aggregate all findings from F12-003 + F12-006:

```
DEVTOOLS NETWORK VERDICT
════════════════════════
Flows validated: {N}
Requests inspected: {N}
State checks: {N}

VERDICT: PASS / FAIL_ADVISORY / FAIL_BLOCKING

SECURITY: {✅ VERIFIED / ❌ BREACH: detail}
TENANT:   {✅ VERIFIED / ❌ BREACH: detail}
AUTH:     {✅ VERIFIED / ❌ LEAK: detail}

BLOCKING:
  {numbered list with evidence}

ADVISORY:
  {numbered list with evidence}
```

□ Save verdict to NETWORK section of DEVTOOLS_REPORT

```
🛑 END RESPONSE HERE. Write this as your LAST line:
⏸️ Network Ant complete. Verdict: {VERDICT}. Security: {status}. Tenant: {status}.
Do NOT produce further output. Hand off to BECCA.
```

## STOP CONDITIONS THIS PHASE
- evaluate_script fails (CSP restriction) → note limitation, skip JS checks
- Auth flow requires real credentials → use test/demo mode only, NEVER real payments
- Tenant isolation unclear → flag as FAIL_ADVISORY (not enough data to confirm)
