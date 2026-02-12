# MANUAL DRIFT REPORT: <PROJECT>

**Inspection Type:** MANUAL_DRIFT
**Date:** <YYYY-MM-DD>
**Inspector:** NEO Inspector
**Manual Version:** <version from OPERATOR_MANUAL header>
**Runs Since Last Drift Audit:** <N>

---

## Drift Checks

| # | Check | Manual Says | Codebase Says | Status |
|---|-------|------------|---------------|--------|
| 1 | Function count | <N from FUNCTIONS.md> | <actual count from index.ts exports> | ✅ OK / ⚠️ DRIFT |
| 2 | Collection count | <N from SCHEMA.md> | <actual count from firestore.rules match paths> | ✅ OK / ⚠️ DRIFT |
| 3 | Route count | <N from FRONTEND.md> | <actual page.tsx file count> | ✅ OK / ⚠️ DRIFT |
| 4 | Env var count | <N from ENVIRONMENT.md> | <actual count from .env.example or .env.template> | ✅ OK / ⚠️ DRIFT |
| 5 | Test file count | <N from TESTS.md> | <actual *.test.ts file count> | ✅ OK / ⚠️ DRIFT |
| 6 | Middleware exports | <list from MIDDLEWARE.md> | <actual exports from middleware/index.ts> | ✅ OK / ⚠️ DRIFT |
| 7 | Service integrations | <list from SERVICES.md> | <actual adapter imports/env vars> | ✅ OK / ⚠️ DRIFT |
| 8 | Danger Zone files exist | <paths from File Danger Index> | <file existence check> | ✅ OK / ⚠️ DRIFT |
| 9 | KIP patterns present | <patterns from KIP table> | <grep verification> | ✅ OK / ⚠️ DRIFT |
| 10 | Nuclear Invariants intact | <invariants from core manual> | <code verification> | ✅ OK / ⚠️ DRIFT |

---

## Drift Details

### Check <N>: <Check Name> — ⚠️ DRIFT

**Manual states:** <what the manual says>
**Codebase shows:** <what the codebase actually has>
**Delta:** <what's missing or extra>
**Evidence:** <file path + line number>

(Repeat for each DRIFT finding)

---

## Summary

| Metric | Value |
|--------|-------|
| Total checks | 10 |
| Passed | <N> |
| Drifted | <N> |
| Severity | <NONE / LOW / MEDIUM based on drift count> |

---

## Recommendation

<If drift found:>
Emit pheromone: `PH-<NNN> | MEDIUM | MANUAL_DRIFT | <detail>`
Dispatch 🌿 Leafcutter Ant to update manual sections: <list affected appendices>

<If no drift:>
Manual is current. No action needed.

---

## Pheromones Emitted

| ID | Severity | Category | Message |
|----|----------|----------|---------|
| (filled by Inspector if drift found) |
