# NEO-TOOLS v1.1.0
## Tool Permissions — Role-Based Access Control

**Purpose:** Which tools each NEO role can use, critical surface protections
**Scope:** Loaded by ALL NEO roles (Ant, Ghost, Inspector)

---

## 1) Tool Permission Matrix

| Tool | Ant | Ghost | Inspector |
|------|-----|-------|-----------|
| **Read** (files) | ✅ Full | ✅ Full | ✅ Full |
| **Edit** (files) | ✅ Full | ❌ Forbidden | ❌ Forbidden |
| **Write** (new files) | ✅ Full | ❌ Forbidden | ❌ Forbidden |
| **Glob** (find files) | ✅ Full | ✅ Full | ✅ Full |
| **Grep** (search) | ✅ Full | ✅ Full | ✅ Full |
| **Bash** (commands) | ✅ Full | 🔒 Read-Only | 🔒 Read-Only |
| **Git** (version control) | ✅ Full | 🔒 Read-Only | 🔒 Read-Only |
| **npm/build** | ✅ Full | 🔒 Run checks only | ❌ Forbidden |
| **Tests** | ✅ Full | 🔒 Run only (no write) | ❌ Forbidden |
| **Lint/Format** | ✅ Full | 🔒 Check only | 🔒 Check only |
| **Type check** | ✅ Full | 🔒 Check only | 🔒 Check only |

### Permission Legend

| Symbol | Meaning |
|--------|---------|
| ✅ Full | Can read and write/execute |
| 🔒 Read-Only | Can run checks/reads but NOT modify |
| ❌ Forbidden | Cannot use at all |

---

## 2) Role-Specific Tool Rules

### Ant (Worker)
```
ANT TOOL AUTHORITY:
├── Read/Edit/Write: ✅ — Core working tools
├── Bash: ✅ — Build, test, deploy commands
├── Git: ✅ — Commit, branch, push (with operator approval)
├── npm/build: ✅ — Install, build, test
├── Lint/Format: ✅ — Fix and verify
│
└── RESTRICTIONS:
    ├── No force-push without explicit operator approval
    ├── No dependency changes without operator approval
    ├── No production deployments
    └── No security rule modifications without escalation
```

### Ghost (Reviewer)
```
GHOST TOOL AUTHORITY:
├── Read/Glob/Grep: ✅ — Inspect all files
├── Bash: 🔒 — Run checks, view output (no modifications)
├── Git: 🔒 — View log, diff, status (no commits)
├── Lint/Format/Type check: 🔒 — Run checks, report pass/fail
│
├── Ghost REVIEWS, Ghost does NOT FIX
│   If lint/format/type fails → report finding (not fix it)
│
└── FORBIDDEN:
    ├── ❌ Edit/Write — Cannot modify any files
    ├── ❌ Git commit/push — Cannot change version control
    └── ❌ npm install/build — Cannot modify dependencies
```

### Inspector (Auditor)
```
INSPECTOR TOOL AUTHORITY:
├── Read/Glob/Grep: ✅ — Inspect all files
├── Lint/Format/Type check: 🔒 — Run checks only
│
├── Inspector REPORTS, Inspector does NOT FIX
│   Findings are recommendations, not actions
│
└── FORBIDDEN:
    ├── ❌ Edit/Write — Cannot modify any files
    ├── ❌ Bash (destructive) — No builds, installs, deploys
    ├── ❌ Git (write) — No commits, pushes
    └── ❌ npm — No installs or builds
```

---

## 3) Enforcement

### Violation Detection

If a role uses a tool outside its permissions:

| Violation | Response |
|-----------|----------|
| Ghost edits a file | `🔑 REJECTED: Ghost cannot modify files` |
| Inspector runs build | `🔑 REJECTED: Inspector cannot run builds` |
| Ant force-pushes | `🔑 REJECTED: Force-push requires operator approval` |
| Any role deploys to prod | `🔑 REJECTED: Production deployment forbidden` |

### Who Checks

- **Ghost** checks Ant's tool usage during review
- **Inspector** checks all roles' tool usage during audit
- **Operator** has final authority on tool permission exceptions

---

## 4) Debugger Ant Tool Permissions

The 🐛 Debugger Ant has a **restricted** tool set compared to standard Ants.

```
DEBUGGER ANT TOOL AUTHORITY:
├── Read/Glob/Grep: ✅ — Investigate code
├── Bash: 🔒 — Run tests, read logs (NO modifications)
├── Tests: 🔒 — Run existing tests (NO writing new tests)
├── Lint/Format/Type check: 🔒 — Run checks only
│
├── Debugger DIAGNOSES. Debugger does NOT FIX.
│   Produce TEST_REPORT, hand off to appropriate Ant type.
│
└── FORBIDDEN:
    ├── ❌ Edit/Write — Cannot modify any files
    ├── ❌ Git commit/push — Cannot change version control
    └── ❌ npm install/build — Cannot modify dependencies
```

**The Debugger Ant has the same permissions as Ghost** — read-only investigation with test execution.

---

## 5) Critical Surface Protections

### 5.1 What Are Critical Surfaces

Critical surfaces are project files that require **extra authorization** before an Ant can modify them. The operator defines critical surfaces per project.

### 5.2 Default Critical Surface Categories

| Category | Pattern Examples | Why Critical |
|----------|-----------------|-------------|
| **Auth / Security** | `**/auth/**`, `**/security/**`, `*.rules` | Access control, permissions |
| **Data Layer** | `**/migrations/**`, `**/schemas/**`, `*.prisma` | Data integrity, schema changes |
| **Deploy / Infra** | `Dockerfile*`, `*.yml` (CI/CD), `deploy.*` | Production safety |
| **Environment** | `.env*`, `**/secrets/**`, `**/config/prod.*` | Credential safety |
| **Tenant Isolation** | `**/middleware/tenant*`, `**/multi-tenant/**` | Cross-tenant safety |

### 5.3 Critical Surface Rules for Each Role

| Role | Rule |
|------|------|
| **Ant** | MUST flag critical surfaces in FOOTPRINT. Cannot edit without `🔑 CRITICAL SURFACE OVERRIDE` |
| **Ghost** | MUST verify that all critical surface edits had OVERRIDE tokens |
| **Inspector** | MUST audit critical surface edits for compliance |
| **Debugger Ant** | Cannot edit ANY file (including critical surfaces) — read-only |

### 5.4 Multi-Tenant Critical Surfaces

In multi-tenant projects, **additional surfaces** are critical:

| Surface | Why |
|---------|-----|
| Tenant middleware (routing, filtering) | Controls which tenant sees what |
| Data access layer (query builders, ORMs) | Must always filter by tenant |
| API boundary (route handlers, controllers) | Entry point for tenant context |
| Shared caches / queues | Could leak data between tenants |
| Authentication providers | Could cross tenant boundaries |

**Any file that handles tenant-specific data is automatically a critical surface.**

### 5.5 Project-Specific Configuration

Operators can define a `.neo/CRITICAL_SURFACES.md` file per project:

```markdown
# CRITICAL SURFACES — <Project Name>

## Files requiring CRITICAL SURFACE OVERRIDE
- src/middleware/auth.ts
- src/config/firebase.rules
- .github/workflows/*.yml
- docker-compose.yml
- src/lib/tenantContext.ts
```

**If this file doesn't exist, the default categories (Section 5.2) apply.**

---

## 6) Quick Reference

```
┌─────────────────────────────────────────────────────────────────────────────┐
│  NEO-TOOLS v1.1.0 — QUICK REFERENCE                                        │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ANT:          ✅ Read/Edit/Write/Bash/Git/npm/test/lint                   │
│  DEBUGGER ANT: ✅ Read  🔒 Bash/tests/lint (run only)  ❌ Edit/Write      │
│  GHOST:        ✅ Read  🔒 Bash/Git/lint (check only)  ❌ Edit/Write      │
│  INSPECTOR:    ✅ Read  🔒 lint (check only)  ❌ Edit/Write/Bash/Git      │
│                                                                             │
│  CRITICAL SURFACES:                                                         │
│  • Auth/security, data layer, deploy/infra, env, tenant isolation           │
│  • Ant MUST flag in FOOTPRINT → needs 🔑 CRITICAL SURFACE OVERRIDE        │
│  • Ghost verifies overrides. Inspector audits.                              │
│  • Debugger Ant: read-only — cannot edit ANY file                           │
│                                                                             │
│  RULES:                                                                     │
│  • Ghost and Inspector NEVER modify files                                   │
│  • Debugger Ant NEVER modifies files                                        │
│  • No role deploys to production                                            │
│  • Violations → 🔑 REJECTED                                                │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Changelog

### [1.1.0] 2026-02-09
- Section 4: Debugger Ant tool permissions (read-only, same as Ghost)
- Section 5: Critical Surface Protections — auth, data, deploy, env, tenant isolation
- Section 5.4: Multi-Tenant Critical Surfaces — tenant middleware, data access, API boundary
- Section 5.5: Project-Specific Configuration — `.neo/CRITICAL_SURFACES.md`
- Updated Quick Reference with Debugger Ant and critical surfaces
- ALL additions are MANUAL ONLY — no automation

### [1.0.0] 2026-02-09
- Initial release
- Adapted from IAMBecca IAMBECCA-TOOLS.md v2.1.0
- Simplified 3-role permission matrix
- ✅ Full / 🔒 Read-Only / ❌ Forbidden system
- Per-role tool authority blocks
- Violation detection and response
