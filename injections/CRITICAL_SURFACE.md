# CRITICAL SURFACE INJECTION

**Paste this when an Ant's FOOTPRINT includes changes to a critical surface.**

---

## CRITICAL SURFACE DETECTED

Your FOOTPRINT includes a **critical surface** — a protected file that requires special authorization before you can edit it.

**You must STOP and get a CRITICAL SURFACE OVERRIDE before proceeding to PATCH.**

### Critical surfaces include (from NEO-TOOLS.md Section 9):

- **Auth / Security** — `**/auth/**`, `**/security/**`, `*.rules`, middleware
- **Data Layer** — `**/migrations/**`, `**/schemas/**`, `*.prisma`
- **Deploy / Infra** — `Dockerfile*`, `*.yml` (CI/CD), `deploy.*`
- **Environment** — `.env*`, `**/secrets/**`, `**/config/prod.*`
- **Tenant Isolation** — `**/middleware/tenant*`, `**/multi-tenant/**`
- **Project-specific** — See `.neo/CRITICAL_SURFACES.md` if it exists

### What you must do now:

1. **Do NOT proceed to PATCH** for any critical surface file
2. **You may still READ these files** — DISCOVERY reading is allowed
3. **Flag the critical surface in your FOOTPRINT** — which file, why it's critical
4. **Request CRITICAL SURFACE OVERRIDE** from the operator

### Response format:

```
CRITICAL SURFACE FLAGGED
========================
File: {path}
Category: {Auth/Data/Deploy/Env/Tenant/Project-Specific}
Proposed change: {what you intend to modify}
Risk: {what could go wrong}
Justification: {why this change is needed}

AWAITING: 🔑 CRITICAL SURFACE OVERRIDE
```

**Override must come from the operator.** Only then may you proceed — and with extra caution.

---

**CRITICAL = STOP — FLAG — AWAIT OVERRIDE**
