# TASK PACKET: <TASK_ID>

**Created:** <YYYY-MM-DD>
**Created by:** Operator

---

## TASK DEFINITION

| Field | Value |
|-------|-------|
| Task ID | <TASK_ID> |
| Priority | HIGH / MEDIUM / LOW |
| Ant Type | <emoji> <type name> |

### Ant Classification (pick ONE)

| Emoji | Type | Risk | Domain | Use When |
|-------|------|------|--------|----------|
| 🔥 | Fire Ant | 🔴 HIGH | Security | Auth, encryption, tokens, secrets, permissions |
| 💵 | Financial Ant | 🔴 HIGH | Payments | Billing, Stripe, subscriptions, pricing |
| 🛡️ | Soldier Ant | 🟠 MEDIUM | Validation | Input guards, sanitization, rate limiting |
| 🛠️ | Carpenter Ant | 🟡 STANDARD | Building | New UI components, features, React hooks |
| 🧰 | Toolbox Ant | 🟡 STANDARD | Maintenance | Bug fixes, refactoring, deployments, config |
| 📊 | Harvester Ant | 🟡 STANDARD | Data | API integration, Firestore, data fetch/sync |
| 📈 | Analyst Ant | 🟢 LOW | Analytics | Dashboards, metrics, reporting, visualization |
| 🚁 | Flying Scout Ant | 🟢 LOW | Research | Discovery, audits, POCs, benchmarks |
| 🌿 | Leafcutter Ant | 🟢 LOW | Documentation | Docs, READMEs, specs, guides |
| 👔 | Board Ant | 🟢 LOW | Planning | Roadmaps, OKRs, architecture, kickoffs |
| 🤝 | Advisor Ant | 🟢 LOW | Reviews | Code reviews, feedback, consulting |
| 📞 | Customer Support Ant | 🟢 LOW | Support | Help docs, tickets, UX improvements |
| 🐛 | Debugger Ant | 🟡 STANDARD | Diagnostics | Debug, diagnose, trace, profile, reproduce |

**Risk levels affect gate behavior** (see `shared/NEO-GATES.md` Section 8):
- 🔴 **HIGH** — Extra scrutiny at every gate. Security/payment impact assessment required at FOOTPRINT.
- 🟠 **MEDIUM** — Validation-specific testing required at VERIFY gate.
- 🟡 **STANDARD** — Normal gate workflow.
- 🟢 **LOW** — Normal gate workflow.

---

## OBJECTIVE

<Clear description of what needs to be done. Be specific.>

---

## TARGET FILES

| File | Purpose |
|------|---------|
| <path/to/file.ts> | <what to do with this file> |
| <path/to/file2.ts> | <what to do with this file> |

---

## SUCCESS CRITERIA

The task is complete when ALL of these are true:

- [ ] <criterion 1 — specific, testable>
- [ ] <criterion 2 — specific, testable>
- [ ] <criterion 3 — specific, testable>

---

## DEFINITION OF DONE

Ghost will check the Ant's work against these criteria:

| Criterion | How to Verify |
|-----------|---------------|
| <criterion 1> | <verification method> |
| <criterion 2> | <verification method> |

---

## CRITICAL SURFACES (if any)

Files that require `🔑 CRITICAL SURFACE OVERRIDE` before editing:

| File | Category | Why Critical |
|------|----------|-------------|
| <path/to/file> | AUTH / DATA / DEPLOY / ENV / TENANT | <reason> |

*(Leave empty if no critical surfaces involved. See `shared/NEO-TOOLS.md` Section 5)*

---

## CONSTRAINTS

- <constraint 1 — e.g., "No breaking changes to public API">
- <constraint 2 — e.g., "Must be backwards compatible">
- <constraint 3 — e.g., "No new dependencies">

*(Leave empty if no specific constraints)*

---

## CONTEXT (Optional)

<Any background information the Ant needs to understand the task.
Related issues, prior work, design decisions, etc.>

---

## STOP CONDITIONS

The Ant MUST STOP and ask the operator if:

- <condition 1 — e.g., "Architecture change needed">
- <condition 2 — e.g., "Missing design spec for UI">
- <condition 3 — e.g., "Security concern discovered">

---

## APPROVAL

🔑 TASK ASSIGNED: <TASK_ID> → Ant
