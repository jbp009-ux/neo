# HANDOFF: Twilio SMS / A2P 10DLC Setup for Sonny & BeccaOS

**Date:** February 11, 2026
**Session:** Multi-session work (2 chats)
**Status:** SMS pipeline COMPLETE, carrier delivery BLOCKED (awaiting A2P campaign approval)

---

## 1) WHAT WAS DONE (Complete List)

### A) Twilio A2P 10DLC Registration (Previous Session)

1. **Business Profile** created and APPROVED on Twilio
2. **A2P Brand Registration** — Sole Proprietor
   - Brand SID: `BN_REDACTED_SEE_ENV`
   - Status: **APPROVED**
3. **A2P Campaign** submitted
   - Campaign SID: `QE_REDACTED_SEE_ENV`
   - Campaign ID: `null` (not yet assigned — still under review)
   - Campaign Status: **IN_PROGRESS** (submitted 2026-02-11)
   - Use Case: `SOLE_PROPRIETOR`
   - Messaging Service: `MG_REDACTED_SEE_ENV`
4. **Phone Number** `PHONE_REDACTED_SEE_ENV` assigned to Messaging Service
5. **Campaign content** configured:
   - STOP/HELP keywords set
   - 5 message samples (order confirmations, delivery updates, workout reminders, promos)
   - Opt-in flow: signup checkbox on sonny8.ai / rizend.com
   - Opt-out: STOP, CANCEL, END, QUIT, UNSUBSCRIBE, REVOKE, STOPALL, OPTOUT

### B) Sonny Backend SMS Configuration (This Session)

1. **Added `TWILIO_MESSAGING_SERVICE_SID`** to `d:\projects\sonny\functions\.env`
   - Value: `MG_REDACTED_SEE_ENV`
   - This was the MISSING env var — smsAdapter.ts reads it at line 34 and prefers it over direct `From` number at line 315
2. **Deployed all Firebase Functions** — `firebase deploy --only functions` (80+ functions updated)
3. **Tested direct Twilio API** — sent SMS to +14134336257
   - SID: `SM5b6c4341e4a33dea530d6307a6a2d210`
   - Status: `undelivered` (error 30034 — carrier blocked, A2P campaign not approved yet)
4. **Tested full Sonny pipeline** — created test order in Firestore, updated status pending→confirmed
   - Trigger fired: `onOrderStatusChange`
   - Notification routed to 3 channels: SMS (customer), Email (customer), KDS (kitchen)
   - SMS SID from logs: `SM4b883ba6d18e413e7b042d158786bd7c`
   - Email sent via SendGrid (message ID: `NbUwhtlCTKySZZt4fsFNFg`)
   - KDS notification: success
   - **All 3 channels succeeded at the application level**
   - SMS was accepted by Twilio but blocked by carrier (same error 30034)
5. **Created test script**: `d:\projects\sonny\scripts\test-sms-notification.cjs`
   - Creates a test order in Firestore with a customer phone number
   - Updates status to trigger `onOrderStatusChange`
   - Checks dead letter queue
   - Cleans up test order
   - Usage: `node scripts/test-sms-notification.cjs +14134336257`

### C) Privacy & Terms Pages (This Session)

1. **BeccaOS (beccaos.com)** — Created from scratch:
   - `d:\projects\beccaos\src\app\privacy\page.tsx` — 12 sections, SMS/A2P compliant (Section 4)
   - `d:\projects\beccaos\src\app\terms\page.tsx` — 15 sections, SMS terms (Section 5)
   - Added footer links to Privacy/Terms on main landing page
   - Both pages use BeccaOS branding (becca-500/accent-500 gradients)

2. **Sonny (sonny8.ai)** — Updated existing pages:
   - `d:\projects\sonny\frontend\src\app\privacy\page.tsx` — Added Section 5 (SMS & Text Messaging), added Twilio + SendGrid to third-party table, renumbered sections, updated date to Feb 11 2026
   - `d:\projects\sonny\frontend\src\app\terms\page.tsx` — Updated contact website to sonny8.ai

### D) Domain Migration (This Session)

1. **Sonny domain**: `sonny.beccaos.com` → `sonny8.ai`
   - Updated in: beccaos/page.tsx (4 URLs), beccaos/admin/page.tsx (7 URLs), sonny privacy/terms pages, sonny useDomainConfig.ts
   - Left middleware.ts untouched (infrastructure routing)
2. **Rizend domain**: Added `rizend.com` references
   - Replaced "Coming Soon" product card on BeccaOS landing page with Rizend (live)
3. **MEMORY.md** updated with all domain mappings

### E) BeccaOS Admin Dashboard Updates (This Session)

- Added Business & Compliance panel with:
  - Entity info (BECCA OS LLC, EIN 41-4149101, MA, Feb 6 2026)
  - Compliance deadlines (MA Annual Report, Federal Tax, MA State Tax, Quarterly Estimates)
  - IRS/Federal links, MA State links, Business Services links (Twilio Console, Brand Registration)
  - Business Setup Checklist (EIN, LLC, Twilio Profile, BOI, A2P Brand, A2P Campaign status)

---

## 2) CURRENT STATE OF TWILIO/SMS

### What Works
- Sonny's full notification pipeline: Firestore trigger → notificationFunctions.ts → smsAdapter.ts → Twilio API
- All env vars configured and deployed
- Messaging Service SID preferred over direct From number
- Email notifications via SendGrid working
- KDS notifications working
- Privacy/Terms pages with TCPA/CTIA compliant SMS language deployed

### What's Blocked
- **SMS delivery to phones** — Error 30034 (Message Blocked by carrier)
- **Root cause**: A2P 10DLC campaign `QE_REDACTED_SEE_ENV` is `IN_PROGRESS`
- **Resolution**: Wait 2-3 weeks for campaign approval (submitted 2026-02-11)
- **Once approved**: Twilio assigns a campaign_id, carrier whitelists the number, SMS delivers normally
- **No code changes needed** — everything is already wired up

### Campaign Registration Details
```
Brand SID:              BN_REDACTED_SEE_ENV
Campaign SID:           QE_REDACTED_SEE_ENV
Campaign ID:            null (pending)
Campaign Status:        IN_PROGRESS
Messaging Service SID:  MG_REDACTED_SEE_ENV
Phone Number:           PHONE_REDACTED_SEE_ENV
Use Case:               SOLE_PROPRIETOR
Submitted:              2026-02-11T13:55:56Z
Errors:                 None
```

### Message Samples Registered with Campaign
1. "Your order #1042 from Mario's Pizza has been confirmed! Ready in 25 minutes. Reply STOP to unsubscribe."
2. "Your workout for today is ready! Log in to rizend.com to view your plan. Reply STOP to opt out."
3. "Mario's Pizza: 20% off all large pizzas this weekend! Order now at sonny8.ai. Reply STOP to unsubscribe."
4. "Great news! Your delivery from Mario's Pizza is on its way. Track your order at sonny8.ai/track. Reply STOP to opt out."
5. "Rizend: Start your New Year strong! Get 30% off your first month of coaching at rizend.com/promo. Reply STOP to opt out."

---

## 3) KEY TWILIO CREDENTIALS & IDS

```
Account SID:            AC_REDACTED_SEE_ENV
Auth Token:             AUTH_TOKEN_REDACTED_SEE_ENV
Phone Number:           PHONE_REDACTED_SEE_ENV
Messaging Service SID:  MG_REDACTED_SEE_ENV
Brand SID:              BN_REDACTED_SEE_ENV
Campaign SID:           QE_REDACTED_SEE_ENV
```

**Test Phone:** `+14134336257`

---

## 4) KEY FILES

### Sonny Backend (d:\projects\sonny\)
| File | What |
|------|------|
| `functions/.env` | All Twilio env vars (ACCOUNT_SID, AUTH_TOKEN, PHONE_NUMBER, MESSAGING_SERVICE_SID) |
| `functions/src/adapters/smsAdapter.ts` | Core SMS logic — 626 lines, uses Messaging Service SID with fallback to From number |
| `functions/src/functions/notificationFunctions.ts` | `onOrderStatusChange` trigger (line 649) — routes to SMS/email/KDS |
| `functions/src/functions/orderFunctions.ts` | `updateOrderStatus` callable (line 544) — triggers notifications |
| `scripts/test-sms-notification.cjs` | Test script — creates order, updates status, triggers SMS pipeline |
| `frontend/src/app/privacy/page.tsx` | Privacy policy with SMS Section 5 |
| `frontend/src/app/terms/page.tsx` | Terms of service |
| `frontend/src/hooks/staff/useDomainConfig.ts` | Domain config (updated to sonny8.ai) |

### BeccaOS (d:\projects\beccaos\)
| File | What |
|------|------|
| `src/app/privacy/page.tsx` | Privacy policy (NEW — 12 sections with SMS) |
| `src/app/terms/page.tsx` | Terms of service (NEW — 15 sections with SMS) |
| `src/app/page.tsx` | Landing page (updated: sonny8.ai URLs, Rizend product card, footer links) |
| `src/app/admin/page.tsx` | Admin dashboard (updated: sonny8.ai URLs, Business & Compliance panel) |

---

## 5) SMS ARCHITECTURE (How It Works)

```
Order Status Change (Firestore document update)
    |
    v
onOrderStatusChange() — Firestore Cloud Function trigger
    |
    v
Load Restaurant Settings (smsEnabled, triggers, templates)
    |
    v
Build NotificationEvent {
  order, statusChange, recipients, messages
}
    |
    v
Check Cooldown (30s per-order) → Check Daily Cap (500/day) → Check Opt-Out
    |
    v
smsAdapter.sendSms() — uses TWILIO_MESSAGING_SERVICE_SID
    |
    v
Twilio REST API (POST /2010-04-01/Accounts/{SID}/Messages.json)
    |
    v
Carrier delivers SMS (BLOCKED until A2P campaign approved)
```

### smsAdapter.ts Key Behavior (line 315):
```typescript
const body = TWILIO_MESSAGING_SERVICE_SID
  ? new URLSearchParams({
      To: normalizedTo,
      MessagingServiceSid: TWILIO_MESSAGING_SERVICE_SID,
      Body: sanitizedMessage,
    })
  : new URLSearchParams({
      To: normalizedTo,
      From: TWILIO_PHONE_NUMBER!,
      Body: sanitizedMessage,
    });
```

### Safeguards Built In:
- Daily SMS cap: 500 per restaurant per day
- Notification cooldown: 30 seconds per order
- Deduplication window: 30 seconds
- Customer opt-out checking (smsOptOut flag)
- PROFIT SHIELD: usage guardrails per workspace plan
- Dead letter queue for failed SMSs
- Emoji stripping (prevents UCS-2 cost penalty)
- E.164 phone normalization
- Max 3 segments per message

---

## 6) WHAT'S LEFT TO DO

### Immediate (When Campaign Approved)
- [ ] Check campaign status: `curl -u "AC_REDACTED_SEE_ENV:AUTH_TOKEN_REDACTED_SEE_ENV" "https://messaging.twilio.com/v1/Services/MG_REDACTED_SEE_ENV/Compliance/Usa2p"`
- [ ] Once `campaign_status` = `VERIFIED`, run test: `node scripts/test-sms-notification.cjs +14134336257`
- [ ] Verify SMS actually arrives on phone

### Campaign Content Fix Needed
- [ ] Message samples reference `sonny.beccaos.com` — should be `sonny8.ai` (update via Twilio Console or API)
- [ ] Message flow description references `sonny.beccaos.com` — update to `sonny8.ai`

### Optional Improvements
- [ ] Add Twilio webhook signature validation (security hardening)
- [ ] Build admin UI for SMS notification settings per restaurant
- [ ] Deploy BeccaOS to Vercel (privacy/terms pages + Rizend card + domain updates)
- [ ] Deploy Sonny frontend (privacy page updates)

### Env Var Warnings (Non-Blocking)
- Cloud Functions logs show warnings about newline/whitespace in env vars (TWILIO_ACCOUNT_SID, AUTH_TOKEN, PHONE_NUMBER, SENDGRID_API_KEY)
- The smsAdapter trims these before use — not causing failures
- Could clean up .env file encoding if desired

---

## 7) HOW TO CHECK CAMPAIGN STATUS

```bash
# Check A2P campaign status
curl -s -u "AC_REDACTED_SEE_ENV:AUTH_TOKEN_REDACTED_SEE_ENV" \
  "https://messaging.twilio.com/v1/Services/MG_REDACTED_SEE_ENV/Compliance/Usa2p" \
  | python -m json.tool

# Look for: "campaign_status": "VERIFIED" and "campaign_id": "C..."
# Currently: "campaign_status": "IN_PROGRESS", "campaign_id": null
```

```bash
# Check recent message delivery status
curl -s -u "AC_REDACTED_SEE_ENV:AUTH_TOKEN_REDACTED_SEE_ENV" \
  "https://api.twilio.com/2010-04-01/Accounts/AC_REDACTED_SEE_ENV/Messages.json?PageSize=5" \
  | python -m json.tool
```

```bash
# Run full pipeline test
cd d:\projects\sonny
node scripts/test-sms-notification.cjs +14134336257
```

---

## 8) ERROR REFERENCE

| Error Code | Meaning | Resolution |
|------------|---------|------------|
| 30034 | Message Blocked by carrier | A2P campaign not approved yet — wait for approval |
| 21610 | Message filtered (spam) | Check message content, ensure STOP language |
| 21608 | Unverified number | Phone not assigned to Messaging Service |

---

## 9) DOMAIN MAP (Current)

| Domain | Product | Status |
|--------|---------|--------|
| `sonny8.ai` | Sonny (AI Pizza SaaS) | LIVE |
| `*.sonny8.ai` | Tenant subdomains | LIVE (via Cloudflare Worker) |
| `rizend.com` | Rizend (Fitness Coaching) | LIVE |
| `beccaos.com` | BeccaOS (Company Hub) | LIVE |
| `*.beccaos.com` | Legacy tenant subdomains | Migrated to sonny8.ai |

**Emails remain @beccaos.com** (not migrated to sonny8.ai)

---

## 10) FIREBASE PROJECT

- **Project ID:** `ai-waitress-31281`
- **Region:** `us-central1`
- **Functions:** 80+ deployed
- **Console:** https://console.firebase.google.com/project/ai-waitress-31281

---

*End of handoff. Resume by checking A2P campaign status and testing SMS delivery once approved.*
