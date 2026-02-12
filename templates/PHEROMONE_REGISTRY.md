# PHEROMONE_REGISTRY — <SEVERITY>

<!--
FORMAT: Severity-grouped warnings with resolution tracking

SEVERITY FILES (one per level):
- PHEROMONE_NUCLEAR.md  — ⚫ Tenant isolation / credential / security boundary
- PHEROMONE_HIGH.md     — 🔴 Significant risk
- PHEROMONE_MEDIUM.md   — 🟠 Moderate risk
- PHEROMONE_LOW.md      — 🟡 Minor risk
- PHEROMONE_INFO.md     — 🟢 Observations

PHEROMONE ID:
- Global sequential: PH-001, PH-002, ... (never reused, never reset)
- Track next ID in STATE.md

STATUS VALUES:
- ACTIVE           — Current warning, Ants MUST acknowledge
- RESOLVED_TASK-NNN — Fixed by specified task, audit trail only

CATEGORIES:
- ISOLATION       — Tenant isolation issues
- CREDENTIAL      — Secrets in code/logs/configs
- SECURITY        — Auth bypasses, boundary violations
- VALIDATION      — Missing input validation
- PERFORMANCE     — Performance risks, unbounded queries
- DATA_INTEGRITY  — Consistency risks, race conditions
- DEPENDENCY      — Risky dependency patterns
- ARCHITECTURE    — Structural concerns, coupling

RULES:
- Append-only (ACTIVE entries); status updates allowed (ACTIVE → RESOLVED)
- ONLY BECCA writes to this file (during CLOSE)
- Resolved pheromones are NEVER deleted — audit trail
- ⚫ NUCLEAR pheromones trigger STOP rule in Ants
- See shared/NEO-HIVE.md for full specification

SEARCHING:
  grep "ACTIVE" .neo/index/PHEROMONE_*.md | grep "auth.ts"   # Active on file
  grep "ACTIVE" .neo/index/PHEROMONE_NUCLEAR.md               # All active NUCLEAR
  grep -c "ACTIVE" .neo/index/PHEROMONE_*.md                  # Count by severity
-->

| ID | Task | File:Line | Category | Message | Status |
|----|------|-----------|----------|---------|--------|

