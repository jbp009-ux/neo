# OPERATOR MANUAL: <PROJECT>

**Project:** <project name>
**Path:** <absolute path>
**Created:** <date>
**Last Updated:** <date>

---

## 0) What This Is

The Operator Manual is project-specific knowledge that supplements NEO governance. It documents what Ants need to know **before** touching any code or data in this project.

- Created by **Scout** on first BECCA run (or manually by operator)
- Read by **BECCA** during RECON
- Read by **Ants** during DISCOVERY (for danger zones and data models)
- Updated by **BECCA** during CLOSE (if new patterns discovered)

**This is NOT governance** — it's operational knowledge. Governance lives in `shared/NEO-*.md`.

---

## 1) Architecture Summary

<!-- High-level description of what this project is and how it works -->

| Aspect | Description |
|--------|-------------|
| **Type** | <SaaS / API / Library / CLI / Monorepo / etc.> |
| **Stack** | <e.g., Next.js 16 + Firebase + Cloudflare> |
| **Multi-tenant?** | YES / NO |
| **Tenant isolation** | <how tenants are separated — e.g., Firestore subcollections, row-level, schema-per-tenant> |
| **Auth method** | <e.g., Firebase Auth + custom claims> |
| **Deployment** | <e.g., Firebase Hosting + Cloud Functions> |

---

## 2) Folder / Code Map

<!-- Key directories and what lives in them. Helps Ants navigate unfamiliar codebases. -->

```
<project-root>/
├── src/
│   ├── <dir>/        ← <purpose>
│   └── <dir>/        ← <purpose>
├── functions/
│   └── src/          ← <purpose>
├── <dir>/            ← <purpose>
└── ...
```

---

## 3) Critical Data Models

<!-- What data structures MUST NOT be destroyed. Ants read this before ANY data operation. -->

| Model / Collection | Location | Importance | Notes |
|--------------------|----------|------------|-------|
| <e.g., menus> | <Firestore: tenants/{tid}/menus> | 🔴 CRITICAL | Owner-created content — irreplaceable |
| <e.g., orders> | <Firestore: tenants/{tid}/orders> | 🔴 CRITICAL | Financial records — legal retention |
| <e.g., users> | <Firebase Auth + Firestore> | 🔴 CRITICAL | PII — tenant isolation mandatory |
| <e.g., config> | <Firestore: tenants/{tid}/config> | 🟠 HIGH | Tenant settings — restorable but disruptive |

**Rule:** Any operation classified as `DATA_WRITE`, `DATA_DELETE`, `MIGRATION`, or `SEED` on a critical data model triggers LAW 2 (Backup) from `NEO-SURGICAL.md`.

---

## 4) Danger Zones

<!-- Files, endpoints, or scripts that CAN wipe or corrupt data if misused. -->

| Zone | File / Path | What It Does | Risk |
|------|------------|-------------|------|
| <e.g., Seed script> | `scripts/seedMenu.ts` | Overwrites menu collection | 🔴 Can destroy owner menu data |
| <e.g., Reset endpoint> | `POST /api/admin/reset` | Resets tenant to defaults | 🔴 Wipes all tenant customization |
| <e.g., Migration> | `scripts/migrate-v2.ts` | Restructures data schema | 🔴 Irreversible without backup |
| <e.g., Delete trigger> | `functions/onTenantDelete` | Cascades delete across subcollections | 🔴 Data loss if triggered incorrectly |

**Rule:** Ants encountering a danger zone file MUST flag it in DISCOVERY findings. If the task requires modifying a danger zone, `🔑 CRITICAL SURFACE OVERRIDE` is required.

---

## 5) Safe Operation Patterns

<!-- HOW to safely perform common operations in this project. -->

### 5a) Updating Menus / Content

```
SAFE:   Use PATCH semantics — merge into existing document
UNSAFE: Use PUT semantics — replaces entire document (destroys fields not in payload)
SAFE:   updateDoc(ref, { field: value })           ← merges
UNSAFE: setDoc(ref, { field: value })              ← replaces (unless { merge: true })
```

### 5b) Adding New Features

```
SAFE:   Add new Cloud Functions as separate files
UNSAFE: Modify existing function signatures (breaks deployed callers)
SAFE:   Extend Firestore security rules additively
UNSAFE: Rewrite rules from scratch (may lock out existing paths)
```

### 5c) Working with Tenant Data

```
SAFE:   Always scope queries to tenant context (tenants/{tid}/...)
UNSAFE: Global queries across tenants (collection group queries without tenant filter)
SAFE:   Test with emulator or test tenant
UNSAFE: Test against production data
```

<!-- Add project-specific safe patterns as discovered -->

---

## 6) Red Flags

<!-- Scripts, patterns, or behaviors that should NEVER run on live data. -->

| # | Red Flag | Why |
|---|----------|-----|
| RF-01 | `seedDemoData()` called from a live endpoint | Demo seed functions overwrite real data |
| RF-02 | `setDoc()` without `{ merge: true }` on existing documents | Replaces entire document, destroying unmentioned fields |
| RF-03 | Collection group query without tenant filter | Returns data across all tenants — isolation breach |
| RF-04 | `deleteCollection()` helper with wildcard | Can cascade-delete entire tenant data tree |
| RF-05 | Environment variable `NODE_ENV` not checked before seed | Seeds can run in production accidentally |

**Rule:** If an Ant encounters a red flag during DISCOVERY, it MUST:
1. Log it in DISCOVERY findings as a ⚫ NUCLEAR or 🔴 HIGH pheromone
2. STOP and report to operator before proceeding
3. Do NOT attempt to "fix" it — investigate intent first (LAW 1)

---

## 7) Environment & Deployment Notes

<!-- Project-specific deployment knowledge that affects how changes are applied. -->

| Aspect | Detail |
|--------|--------|
| **Local dev** | <how to run locally — e.g., `firebase emulators:start`> |
| **Staging** | <staging environment details, if any> |
| **Production** | <production deployment method — e.g., `firebase deploy`> |
| **Deploy gotchas** | <known issues — e.g., "must redeploy function X after changing Y"> |
| **Env vars needed** | <critical environment variables that must be set> |

---

## 8) Known Intentional Patterns

<!-- Things that LOOK wrong but are INTENTIONAL. Prevents assumption-based "fixes." -->

| Pattern | Looks Like | Actually Is |
|---------|-----------|-------------|
| <e.g., Empty menu categories> | Bug — missing data | Intentional — owner hasn't added items yet |
| <e.g., Hardcoded tenant ID in test> | Security issue | Test-only tenant for emulator |
| <e.g., Commented-out feature flag> | Dead code | Feature waiting for launch date |

**Rule:** If something looks wrong, check this section FIRST. If it's listed here, it's intentional — do NOT "fix" it. (Anti-Assumption Rule A-07 from `NEO-SURGICAL.md`)

---

## 9) Theme / Styling (Color Expert)

<!-- OPTIONAL: Only fill this section if the project has theme/CSS work.
     Required before 🎨 Color Expert Ant can start.
     If not applicable, leave this section empty or delete it. -->

### Theme File Map

<!-- Which files control styling in this project? -->

| File | Purpose | Risk Level |
|------|---------|------------|
| <e.g., src/styles/theme.css> | CSS variables / design tokens | FRAGILE -- variables only |
| <e.g., src/styles/overrides.css> | Light mode overrides | SAFE -- preferred edit target |
| <e.g., src/constants/colors.js> | Color family definitions | DATA CONTRACT -- affects components |

### Validation Surface

<!-- How to visually verify the theme system. Could be ColorLab, Storybook, or a dedicated test page. -->

| What | Location |
|------|----------|
| Validation component/page | <e.g., Storybook, /dev/colorlab, DevTools> |
| How to access | <e.g., npm run storybook, navigate to /dev> |

### Golden Pages

<!-- Routes to check after any color/theme change. Both modes. -->

| Page | Route | What to Verify |
|------|-------|---------------|
| <e.g., Dashboard> | `/` | Header, cards, navigation |
| <e.g., Settings> | `/settings` | Forms, toggles, buttons |

### Brand Colors / Design Tokens

<!-- Approved palette. Color Expert must preserve these hues. -->

| Token | Light Mode | Dark Mode |
|-------|-----------|-----------|
| Accent | <hex> | <hex> |
| Secondary | <hex> | <hex> |
| Error / Warning / Success | <standard semantics> | <standard semantics> |

### Visual / A11y Test Commands

<!-- Commands to run after CSS changes. Referenced by Color Expert in VERIFY state. -->

| Command | Purpose |
|---------|---------|
| <e.g., npm run test:visual> | Screenshot golden pages (all modes) |
| <e.g., npm run test:a11y> | WCAG AA accessibility checks |

### Known Fragile Areas

<!-- CSS files or patterns that are historically unstable. -->

| File / Pattern | Why Fragile | Rule |
|----------------|-------------|------|
| <e.g., theme.css rules section> | Specificity wars, duplicate rules | Variables only -- no rule edits |

---

## How to Customize

1. Fill in all `<placeholder>` sections with project-specific information
2. Add rows to tables as the project evolves
3. BECCA updates this during CLOSE when new patterns are discovered
4. Scout populates initial data during first BECCA run
5. Operator can edit directly at any time
6. Section 9 (Theme/Styling) is optional -- only needed for projects with CSS/theme work

---

## Rules

- Ant MUST read Sections 3-6 during DISCOVERY (before any code changes)
- Ant MUST check Section 8 before reporting something as "broken"
- Color Expert Ant MUST read Section 9 before starting any color/theme work
- BECCA MUST read this during RECON to brief the run
- BECCA SHOULD update this during CLOSE with new discoveries
- Ghost MAY reference this to validate Ant's understanding claims (LAW 1)
