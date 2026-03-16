# ANT FOOTPRINT CARD
**CARD_ID:** ANT-FOOTPRINT | **Phase:** FOOTPRINT | **Role:** Ant
**INPUTS:** 🔑 APPROVED DISCOVERY, DISCOVERY findings, target files, Operator Manual
> Read this card after DISCOVERY is acknowledged. Follow every □ item.

## 1. DATA OPERATION CLASSIFICATION (every file)

| Op Type | Meaning | Backup? |
|---------|---------|---------|
| CODE_ONLY | Logic/UI changes, no data touched | NO |
| DATA_READ | Reads data but doesn't modify | NO |
| DATA_WRITE | Writes/updates data (PATCH semantics) | YES |
| DATA_DELETE | Removes data records | YES + restore test |
| MIGRATION | Schema/structure changes | YES + restore test |
| SEED | Creates initial/demo data | YES + restore test |
| CONFIG_WRITE | Modifies config (env, rules, deploy) | YES |

□ Classify EVERY file in scope:
  | File | Change Type | Data Op | Backup? | Write Semantics |
  |------|-------------|---------|---------|-----------------|

□ Write semantics: PATCH (default) / PUT (needs justification) / DELETE (needs confirmation)
  → PUT without justification: STOP (S-24)

## 2. TARGET ENVIRONMENT
□ Declare: `TARGET_ENVIRONMENT: EMULATOR / STAGING / PRODUCTION`
  → Missing declaration: STOP (S-35)
□ If PRODUCTION + destructive op: requires `🔑 PRODUCTION CONFIRMED` (S-36)

## 3. FEATURE IMPACT (mandatory)
□ List ALL user-facing features touched:
  | Feature | Current State | After Task | Impact | Override? |
  |---------|--------------|------------|--------|-----------|
□ Impact levels: ✅ NONE / 🟡 REDUCED / 🟠 RELOCATED / 🔴 REMOVAL
□ 🔴 REMOVAL requires `🔑 FEATURE REMOVAL OVERRIDE`

## 4. CRITICAL SURFACES
□ If any file is a critical surface (auth, data layer, deploy, env, tenant):
  → Flag: "⚠️ CRITICAL SURFACE: <file path>"
  → Requires `🔑 CRITICAL SURFACE OVERRIDE: <file>`
  → Override is single-use, single-file, single-task

## 5. RISK ASSESSMENT
□ 🔴 HIGH (Fire/Financial/Color): security/payment impact assessment required
□ 🟠 MEDIUM (Soldier): edge-case plan for validation scenarios
□ 🟡🟢 STANDARD/LOW: normal workflow

## 6. ROLLBACK PLAN
□ Document exact rollback steps (git checkout, stash pop, restore backup)

## 7. PHEROMONE EMISSION
□ Emit pheromone for ANY risk/concern found:
  `PHEROMONE: <SEVERITY> | <CATEGORY> | <FILE:LINE> | <MESSAGE>`
  Severities: ⚫ NUCLEAR / 🔴 HIGH / 🟠 MEDIUM / 🟡 LOW / 🟢 INFO

## 8. HORSEMEN CHECKS
□ H3 DRIFT: Am I modifying something not in the approved scope?
□ H4 PRIVILEGE CREEP: Am I requesting more access than needed?

## STOP CONDITIONS THIS PHASE
- S-13: Critical surface edit without override → HIGH
- S-24: PUT semantics without justification → MEDIUM
- S-35: TARGET_ENVIRONMENT missing → BLOCKER
- S-36: PRODUCTION destructive without 🔑 PRODUCTION CONFIRMED → ⚫ NUCLEAR

## NEXT

```
🛑 END RESPONSE HERE. Write this as your LAST line:
⏸️ Gate: 🔑 FOOTPRINT OK?
Do NOT produce PATCH output in this same response.
Do NOT proceed until the operator responds with approval.
```

Present FOOTPRINT to operator.
Load next card only AFTER operator approves in their next message:
- If data ops present → load **ANT_BACKUP** card.
- If no data ops → load **ANT_PATCH** card.
