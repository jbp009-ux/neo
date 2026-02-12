# CRITICAL SURFACES: <PROJECT>

**Project:** <project name>
**Created:** <date>
**Last Updated:** <date>

---

## What Are Critical Surfaces?

Critical surfaces are files and directories that require extra scrutiny when modified.
Any Ant touching a critical surface MUST:
1. Flag it in FOOTPRINT with `CRITICAL SURFACE OVERRIDE`
2. Obtain operator approval before proceeding
3. Ghost verifies the override token was issued
4. Inspector audits the change against the surface's category rules

---

## Critical Surface Registry

<!--
  Add project-specific critical files below.
  Format: one entry per file/pattern, with category and reason.
  Categories: AUTH, DATA, INFRA, TENANT, ENV, PAYMENT, SECURITY
-->

### AUTH — Authentication & Authorization

| File / Pattern | Reason |
|---------------|--------|
| `**/auth/**` | Authentication logic |
| `**/middleware/auth*` | Auth middleware |
| `**/firebaseAdmin*` | Firebase admin SDK initialization |

### DATA — Data Layer & Persistence

| File / Pattern | Reason |
|---------------|--------|
| `**/models/**` | Data models / schemas |
| `**/migrations/**` | Database migrations |
| `**/firestore.rules` | Firestore security rules |

### INFRA — Deployment & Infrastructure

| File / Pattern | Reason |
|---------------|--------|
| `**/firebase.json` | Firebase project configuration |
| `**/Dockerfile*` | Container definitions |
| `**/.github/workflows/**` | CI/CD pipelines |
| `**/cloudflare/**` | Edge workers and DNS config |

### TENANT — Tenant Isolation

| File / Pattern | Reason |
|---------------|--------|
| `**/middleware/tenant*` | Tenant resolution middleware |
| `**/tenantContext*` | Tenant context utilities |
| `**/slugFunctions*` | Subdomain/slug resolution |

### ENV — Environment & Secrets

| File / Pattern | Reason |
|---------------|--------|
| `**/.env*` | Environment variables |
| `**/secrets/**` | Secret management |
| `**/serviceAccount*` | Service account keys |

### PAYMENT — Financial & Billing

| File / Pattern | Reason |
|---------------|--------|
| `**/stripe/**` | Payment processing |
| `**/billing/**` | Billing logic |
| `**/subscription*` | Subscription management |

### SECURITY — Security Boundaries

| File / Pattern | Reason |
|---------------|--------|
| `**/cors*` | CORS configuration |
| `**/rateLimit*` | Rate limiting |
| `**/helmet*` | Security headers |

---

## How to Customize

1. Remove categories that don't apply to your project
2. Add project-specific files to existing categories
3. Add new categories if needed (use UPPERCASE names)
4. Keep reasons concise — they appear in Ghost reviews

---

## Rules

- Ant MUST flag critical surface hits in FOOTPRINT
- Operator MUST issue `CRITICAL SURFACE OVERRIDE` token
- Ghost MUST verify override token exists for each critical surface touched
- Inspector MUST audit critical surface changes against category rules
- No critical surface change without explicit operator approval
