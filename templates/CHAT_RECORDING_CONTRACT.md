# CHAT RECORDING CONTRACT

**Purpose:** Verify that AI chat sessions are captured end-to-end (user input → AI response → storage). This contract defines what "recorded" means and how to prove it.

---

## REQUIRED FIELDS

### Session-Level

| Field | Required | Description |
|-------|----------|-------------|
| sessionId | YES | Unique session identifier |
| restaurantId | YES | Tenant/restaurant this session belongs to |
| channel | YES | `web` / `ios` / `admin` — which client originated the session |
| createdAt | YES | Session creation timestamp (ISO 8601) |
| updatedAt | YES | Last message timestamp (ISO 8601) |
| consentVersion | YES | Version of "chats recorded for improvement" notice accepted |
| consentAcceptedAt | YES | When consent was accepted (or proof it's handled elsewhere) |
| consentSource | YES | Where consent was obtained: `banner` / `terms_page` / `app_tos` / `inherited` |
| appVersion | RECOMMENDED | Client app version string |
| environment | YES | `staging` / `prod` — which environment produced this session |
| customerId | IF AUTH | Authenticated user ID (if user is logged in) |

### Message-Level

| Field | Required | Description |
|-------|----------|-------------|
| messageId | YES | Unique message identifier within session |
| role | YES | `user` / `assistant` / `system` |
| text | YES | Full message content |
| timestamp | YES | Message timestamp (must be monotonic within session) |
| turnOrder | YES | Integer sequence (0, 1, 2...) or derivable from timestamp ordering |
| orderContextRef | RECOMMENDED | Pointer to draft order ID if order was active |
| errorFlags | RECOMMENDED | Array of error conditions detected during this turn |

---

## VALIDATION PROTOCOL

### Step 1: Fresh Session Test

Create a fresh test session in staging with a test account. Send **10+ back-and-forth turns** including:

1. Normal ordering (2-3 turns)
2. Modifications (change quantity, add/remove modifier)
3. An allergy question
4. A "we don't have that" edge case
5. A summary request

### Step 2: Storage Verification

Verify in storage (Firestore/DB) that:

| Check | How to Verify |
|-------|---------------|
| All turns present | Count messages in storage = count sent |
| Timestamps monotonic | Each message.timestamp > previous |
| Session metadata exists | sessionId, restaurantId, channel, environment all populated |
| Assistant responses recorded | role=assistant messages present for every user turn |
| Consent metadata present | consentVersion + consentAcceptedAt + consentSource exist on session |

### Step 3: Silent Drop Test

1. Refresh app/page mid-chat (after 5+ turns)
2. Continue chatting (2-3 more turns)
3. Verify in storage: messages still append correctly, no gap in turn sequence

### Step 4: Known-Good Session

Save one verified session as the **regression baseline**:
- Export session JSON (redacted: strip customer PII)
- Store in `.neo/audit/evidence/KNOWN_GOOD_CHAT_SESSION.json`
- Reference in future stress runs to compare structure

### Evidence Required

- Screenshot of storage document(s) OR exported JSON sample (redacted)
- Code pointers to write path(s): `<file>:<section/lines>`
- Known-good session saved for regression testing

---

## HOW THE STRESS TESTER VERIFIES

### Browser-Side Check (evaluate_script)

```js
// Read-only check — DO NOT MUTATE
() => {
  // 1. Check localStorage for session refs
  const localKeys = Object.keys(localStorage)
    .filter(k => k.includes('chat') || k.includes('session') || k.includes('conversation'));

  // 2. Check sessionStorage
  const sessionKeys = Object.keys(sessionStorage)
    .filter(k => k.includes('chat') || k.includes('session') || k.includes('conversation'));

  return {
    localStorage: localKeys.map(k => ({ key: k, length: localStorage.getItem(k)?.length })),
    sessionStorage: sessionKeys.map(k => ({ key: k, length: sessionStorage.getItem(k)?.length })),
    url: window.location.href,
    timestamp: new Date().toISOString()
  };
}
```

### Network-Side Check (during stress test)

Monitor `list_network_requests` for:
- POST/PUT to chat storage endpoint (Firestore, API route)
- Response 200/201 confirms write succeeded
- Request body contains message text

### Verification Verdict

| Result | Meaning | Closeout Impact |
|--------|---------|-----------------|
| VERIFIED | Session ID found + messages present + network writes confirmed | PASS |
| PARTIAL | Session ID found but messages incomplete or network writes failed | FAIL_BLOCKING |
| NOT_VERIFIED | No session data found in any storage layer | **FAIL_BLOCKING** |
| NOT_APPLICABLE | App does not implement chat recording (operator confirms) | PASS (with note) |

> **Fail-closed rule:** NOT_VERIFIED = FAIL_BLOCKING. If chat recording evidence is missing, the stress test cannot pass. Only the operator can override with `NOT_APPLICABLE` + justification.

---

## INTEGRATION WITH STRESS PLAYBOOK

The F12 Stress Tester checks recording status after completing all scenarios:

1. Run `evaluate_script` with browser-side check
2. Cross-reference against network requests captured during stress test
3. Report verdict in STRESS_REPORT under `CHAT RECORDING` field
4. If NOT_VERIFIED → verdict escalates to FAIL_BLOCKING regardless of scenario results

**This contract is a REFERENCE DOCUMENT.** The Stress Tester Ant reads it to know what to check. The checks are embedded in [ANT_F12_STRESS.md](../cards/ant/ANT_F12_STRESS.md) Step 3.
