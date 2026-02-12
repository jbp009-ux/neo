# HANDOFF: NEO Governance Updates + Sonny Domain Migration

**Date:** February 11, 2026
**Sessions:** 3 chats (context continuations)
**Status:** All work COMPLETE — handoff for awareness + pending items across ecosystem

---

## 1) WHAT WAS DONE (3 Workstreams)

### A) NEO Pipeline — PROJECT LOCK + CHECKPOINT FIRST

**Problem:** BECCA auditing Rizend ended up with Ants working on Sonny files (cross-project confusion). Ants were also not creating backups before starting work.

**Solution:** Two new FROZEN governance rules:

1. **PROJECT LOCK** — BECCA declares a hard binding to ONE project root during RECON. All file access outside that root is a V-10 violation (BLOCKER STOP).

2. **CHECKPOINT FIRST** — Every Ant creates a git stash + records HEAD hash before ANY work. Missing checkpoint is S-26 (BLOCKER STOP).

**Files Changed (7 files in `d:\projects\neo\`):**

| File | Version | Changes |
|------|---------|---------|
| `roles/NEO-BECCA.md` | v1.6.0 → v1.7.0 | PROJECT LOCK (FROZEN) section, V-10 violation, RECON output with lock declaration |
| `roles/NEO-ANT.md` | v1.8.0 → v1.9.0 | CHECKPOINT state, CHECKPOINT FIRST box, Project Lock Validation, S-25→S-28, 11-step activation |
| `shared/NEO-GATES.md` | v1.4.0 → v1.5.0 | S-25→S-28 STOP conditions, V-10 violation, Quick Reference |
| `shared/NEO-ACTIVATION.md` | v1.3.0 → v1.4.0 | Project Binding (FROZEN) section, updated activation responses |
| `shared/NEO-SURGICAL.md` | v1.0.0 → v1.1.0 | Section 9: CHECKPOINT FIRST, Section 10: PROJECT ISOLATION |
| `templates/PROJECT_TODO.md` | — | PROJECT LOCK header, scope boundary per task |
| `README.md` | v2.3.0 → v2.4.0 | Project Isolation section, pipeline diagram, file manifest |

**New STOP conditions:**
- S-25: File path outside PROJECT LOCK root
- S-26: Checkpoint not created before DISCOVERY
- S-27: Target file outside task SCOPE BOUNDARY
- S-28: Working on wrong project's files

**New violation:** V-10 PROJECT LOCK VIOLATION

### B) NEO Pipeline — Color Expert Ant (prior session)

Added 14th Ant type: `🎨 Color Expert Ant` (HIGH risk, Styling domain)

**Files Changed (8 files in `d:\projects\neo\`):**

| File | Changes |
|------|---------|
| `prompts/COLOR_EXPERT_ANT.md` | NEW — 300-line specialized prompt with LAB state, PRESCRIPTION format, 3-change limit |
| `roles/NEO-ANT.md` | v1.7.0 → v1.8.0 | 14th Ant type + Color Expert Law |
| `shared/NEO-GATES.md` | v1.3.0 → v1.4.0 | LAB state (optional, Color Expert only) |
| `shared/NEO-OUTPUTS.md` | v1.7.0 → v1.8.0 | Section 7g: Color Expert output formats |
| `scripts/neo-init.ps1` | v2.1 → v2.2 | Deploy prompts/ directory |
| `scripts/neo-refresh.ps1` | v2.1 → v2.2 | Sync prompts/ directory |
| `README.md` | v2.2.0 → v2.3.0 | Prompts section, 14 Ant types |
| `templates/OPERATOR_MANUAL.md` | — | Optional Section 9: Theme/Styling |

### C) Sonny Domain Migration — beccaos.com → sonny8.ai

**Scope:** Migrated ALL Sonny subdomain/URL references from `*.beccaos.com` to `*.sonny8.ai`.

**Rules:** Emails stay `@beccaos.com`. BeccaOS company site still exists at `beccaos.com`.

**Files Changed (27 items across `d:\projects\sonny\`):**

**Code (17 files):**
| File | What Changed |
|------|-------------|
| `cloudflare/subdomain-proxy/wrangler.toml` | Route `*.sonny8.ai/*`, zone `sonny8.ai` |
| `cloudflare/subdomain-proxy/package.json` | Name `sonny8-subdomain-proxy` |
| `cloudflare/subdomain-proxy/src/index.ts` | Regex, host rewrite, reserved subdomains |
| `functions/src/utils/slug.ts` | JSDoc, added `sonny8` + `rizend` to reserved slugs |
| `functions/src/functions/slugFunctions.ts` | JSDoc, subdomain URLs x2 |
| `functions/src/functions/sonnyAI.ts` | CORS origins, subdomain regex |
| `functions/src/functions/subscriptionFunctions.ts` | URL allowlist, email template URLs |
| `functions/src/functions/workspaceFunctions.ts` | Subdomain URL generation |
| `functions/src/adapters/emailAdapter.ts` | Added `sonny8.ai` to allowed from-domains |
| `functions/scripts/setup-customer-portal.js` | Stripe portal URLs |
| `frontend/src/lib/slugUtils.ts` | `SUBDOMAIN_BASE = 'sonny8.ai'` |
| `frontend/src/middleware.ts` | Platform domains, regex, redirects, reserved subdomains |
| `frontend/src/components/admin/AllRestaurantsPanel.tsx` | Display URL |
| `frontend/src/components/settings/TenantInfoPanel.tsx` | Domain check |
| `frontend/src/app/onboarding/page.tsx` | Subdomain URL |
| `frontend/src/lib/firebase.ts` | reCAPTCHA comments |
| `functions/src/__tests__/functions/subscriptionFunctions.ph3.test.ts` | Test allowlist |

**Documentation (9 files):**
| File | What Changed |
|------|-------------|
| `.neo/OPERATOR_MANUAL_SONNY.md` | 11 domain refs → sonny8.ai |
| `SONNY_AI_SALES_TRAINING_MANUAL.md` | Product URLs |
| `SONNY_FEATURES_AND_PRICING.md` | Audit URL |
| `TODO-CUSTOM-DOMAINS.md` | CNAME + deployment refs |
| `TODO-SAAS-POLISH.md` | Site URL |
| `TODO-SONNY-POLISH.md` | App URL |
| `frontend/CATEGORY_OPTIONS_TODO.md` | Testing URL |
| `frontend/scripts/generate-tts-audio.js` | Testing instruction |
| `firestore.rules` | Comment |

**Build:** Functions rebuilt (`tsc`) — zero `sonny.beccaos.com` in compiled JS.

**Tracking doc:** `d:\projects\sonny\TODO-DOMAIN-MIGRATION.md` (CODE COMPLETE status)

---

## 2) DEPLOYMENT STEPS STILL NEEDED (Sonny Domain Migration)

| # | Step | Command / Location | Status |
|---|------|--------------------|--------|
| 1 | Deploy Cloudflare Worker | `cd d:\projects\sonny\cloudflare\subdomain-proxy && wrangler deploy` | TODO |
| 2 | Deploy Firebase Functions | `cd d:\projects\sonny && firebase deploy --only functions` | TODO |
| 3 | Add `sonny8.ai` to Firebase Auth | Firebase Console → Auth → Settings → Authorized domains | TODO |
| 4 | Re-run Stripe portal config | `node functions/scripts/setup-customer-portal.js` | TODO |
| 5 | Verify DNS | Cloudflare panel — `*.sonny8.ai` CNAME → `ai-waitress-31281.web.app` | TODO |
| 6 | End-to-end test | Signup → slug → subdomain → login on `sonny8.ai` | TODO |

---

## 3) PENDING NEO TASKS ACROSS ECOSYSTEM

### Trainer-OS / Rizend (`d:\projects\trainer-os\.neo\`)

**RIZEND Branding Run** (`TODO_RIZEND.md`) — 4/6 tasks remaining:
| Task | Type | Status | What |
|------|------|--------|------|
| TASK-001 | 🎨 Designer | ✅ DONE | Update CSS color tokens |
| TASK-002 | 🎨 Designer | ✅ DONE | Add gradient utilities |
| TASK-003 | 🎨 Designer | ⬜ QUEUED | Apply gradients to hero/CTAs |
| TASK-004 | 🎨 Designer | ⬜ QUEUED | Add glassmorphism effects |
| TASK-005 | 🎨 Designer | ⬜ QUEUED | Add micro-interactions |
| TASK-006 | 🎨 Designer | ⬜ QUEUED | Update PWA manifest + brand assets |

**TRAINER Bug Fix Run** (`TODO_TRAINER.md`) — 3/4 tasks remaining:
| Task | Type | Status | What |
|------|------|--------|------|
| TASK-001 | 🛠️ Toolbox | ✅ DONE | Fix workout data structure (exercises vs blocks) |
| TASK-002 | 🛠️ Toolbox | ⬜ QUEUED | Fix React hooks violations in 4 pages |
| TASK-003 | 🛠️ Toolbox | ⬜ QUEUED | Fix generateStaticParams missing demo-3 |
| TASK-004 | 🛠️ Toolbox | ⬜ QUEUED | Audit CSS classes, placeholder images, Cloud Functions |

### NEO Core (`d:\projects\neo\`)

**Archival Upgrade** (`docs/NEO_ARCHIVAL_UPDATE_PLAN.md`) — Not started:
- Ghost decomposition: break monolithic reports into 8 routed sections
- New Inspector PLACEMENT inspection type (8-point checklist)
- 11-step implementation plan documented
- This is an ARCHITECTURE change, not a bug fix

### Sonny (`d:\projects\sonny\.neo\`)
- **All 3 runs CLOSED** (13 tasks complete, Run 001-003)
- **No pending NEO work**

### IAMBecca (`d:\projects\iambecca\`)
- **All TODO files COMPLETE** (Tool Expansion, Data Protection, Report Expansion)
- Historical test packet in `inbox/bq/PKT_TEST001_TASK-001_to_NEO.md` (Feb 2, 2026 — not current)
- **No pending NEO work**

---

## 4) KEY FILE LOCATIONS

### NEO Governance
```
d:\projects\neo\
├── roles/NEO-BECCA.md      (v1.7.0)
├── roles/NEO-ANT.md        (v1.9.0)
├── shared/NEO-GATES.md     (v1.5.0)
├── shared/NEO-ACTIVATION.md (v1.4.0)
├── shared/NEO-SURGICAL.md  (v1.1.0)
├── shared/NEO-OUTPUTS.md   (v1.8.0)
├── prompts/COLOR_EXPERT_ANT.md
├── templates/PROJECT_TODO.md
├── templates/OPERATOR_MANUAL.md
├── scripts/neo-init.ps1    (v2.2)
├── scripts/neo-refresh.ps1 (v2.2)
├── docs/NEO_ARCHIVAL_UPDATE_PLAN.md
├── README.md               (v2.4.0)
└── HANDOFF_TWILIO_SMS_2026-02-11.md  (separate workstream)
```

### Project .neo Directories
```
d:\projects\sonny\.neo\           ← 3 runs complete (TASK-001–013)
d:\projects\trainer-os\.neo\      ← 2 runs in progress (7 tasks pending)
```

### Sonny Domain Migration
```
d:\projects\sonny\TODO-DOMAIN-MIGRATION.md  ← Full tracking doc (CODE COMPLETE)
```

---

## 5) DOMAIN MAP (Current)

| Domain | Product | Status |
|--------|---------|--------|
| `sonny8.ai` | Sonny (AI Pizza SaaS) | LIVE |
| `*.sonny8.ai` | Tenant subdomains | Code migrated, awaiting deploy |
| `rizend.com` | Rizend (Fitness Coaching) | LIVE |
| `beccaos.com` | BeccaOS (Company Hub) | LIVE |
| `*.beccaos.com` | Legacy tenant subdomains | Migrated to `*.sonny8.ai` |

**Emails remain `@beccaos.com`** — no email domain change.

---

## 6) RECOMMENDED NEXT STEPS (Priority Order)

1. **Deploy Sonny domain migration** (Section 2 above) — code is ready, just needs deployment
2. **Continue Trainer-OS bug fixes** — TASK-002 through TASK-004 (React hooks, generateStaticParams, CSS audit)
3. **Continue Rizend branding** — TASK-003 through TASK-006 (gradients, glassmorphism, micro-interactions, PWA)
4. **NEO Archival Upgrade** — implement Ghost decomposition (8-section routing) when ready for architecture change
5. **Check Twilio A2P campaign** — see separate handoff `HANDOFF_TWILIO_SMS_2026-02-11.md`

---

## 7) HOW TO RESUME

```
Load handoff from d:\projects\neo\HANDOFF_NEO_GOVERNANCE_2026-02-11.md
```

For Twilio SMS specifically:
```
Load handoff from d:\projects\neo\HANDOFF_TWILIO_SMS_2026-02-11.md
```

For Trainer-OS / Rizend NEO runs:
```
Say "I AM" to activate BECCA for Trainer-OS or Rizend
BECCA will read .neo/STATE.md and .neo/TODO_*.md to pick up where left off
```

---

*End of handoff. Two separate workstreams documented — NEO governance (this file) and Twilio SMS (separate file).*
