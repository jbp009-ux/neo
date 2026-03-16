# CHAT-TO-PLAYBOOK PIPELINE

**Purpose:** Define how the F12 Stress Tester grows its scenario library from real recorded chat sessions. This is a learning loop — real conversations reveal failure patterns that pre-written scenarios miss.

---

## PIPELINE FLOW

```
SAMPLE → EXTRACT → CONVERT → VALIDATE → MERGE
```

### Step 1: SAMPLE — Read recorded chats (read-only)

- Source: Chat recording storage (Firestore/DB) — **staging preferred**
- Scope: Last 50-100 sessions, or sessions flagged by support/operators
- Access: Read-only. Never modify stored sessions.
- Frequency: After every 3-5 closeout runs, or when operator requests

### Step 2: EXTRACT — Identify failure patterns

Scan sessions for these pattern categories:

| Pattern | What to Look For | Priority |
|---------|-----------------|----------|
| Contradictions | AI said "we don't have X" then offered X later | HIGH |
| Item availability confusion | AI added item not on menu, or claimed stock it can't verify | HIGH |
| Allergy handling gaps | Confident guesses, missing disclaimers, false guarantees | HIGH |
| Order modification errors | Wrong item modified, ghost modifiers, state corruption | HIGH |
| Revenue bypass | Paid modifiers put in special instructions for free | MEDIUM |
| Ambiguity failures | AI assumed instead of asking clarifying question | MEDIUM |
| Multi-turn drift | Summary doesn't match actual order state after many turns | MEDIUM |
| Security boundary | AI complied with prompt injection or leaked system info | CRITICAL |

### Step 3: CONVERT — Create scenario proposals

For each extracted pattern, create a new scenario:

```yaml
- id: PB-NEW-001
  category: <from pattern table>
  title: <descriptive title>
  source: "Extracted from session <sessionId>, turns <N-M>"
  turns:
    - role: user
      text: "<sanitized user message>"
    - role: user
      text: "<follow-up that triggers the failure>"
  expected:
    - "<what the AI should have done>"
  failFlags:
    - <relevant flags>
  recommendedEvidence:
    - console
    - order_summary_screenshot
```

### Step 4: VALIDATE — Test in staging

- Run the proposed scenario in staging
- Confirm it actually tests what was intended
- Verify expected behavior is achievable (not testing for impossible)
- Only scenarios that produce clear PASS/FAIL results are kept

### Step 5: MERGE — Add to playbook

- Approved scenarios get permanent IDs (next available PB-NNN)
- Add to `templates/F12_STRESS_PLAYBOOK.yaml` under appropriate category
- Increment `playbookVersion` (minor bump)

---

## PRIVACY RULES (mandatory)

When converting real chats into playbook scenarios:

| Rule | Enforcement |
|------|-------------|
| **Strip all PII** | Remove names, phone numbers, addresses, emails, payment info |
| **Keep intent only** | Preserve the wording style and intent, not the actual personal details |
| **No real session IDs** | Use `source: "Extracted from session <redacted>"` in playbook |
| **No customer data in scenarios** | Replace real names with generic ("John" → just remove or use "customer") |
| **Staging preferred** | Sample from staging sessions first. Production only with operator approval. |

---

## OWNERSHIP

- **Who runs it:** Operator (triggers manually) or BECCA (during CLOSE if enough new sessions exist)
- **Who approves new scenarios:** Operator reviews proposals before merge
- **Where proposals live:** `.neo/outbox/stress/PLAYBOOK_PROPOSALS_<date>.yaml` until approved
- **Cadence:** Every 3-5 runs, or when support flags recurring issues
