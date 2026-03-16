# ANT BACKUP CARD
**CARD_ID:** ANT-BACKUP | **Phase:** BACKUP | **Role:** Ant
**INPUTS:** 🔑 APPROVED FOOTPRINT, Data Op Classification table, target environment, backup destination
> Load this card ONLY when FOOTPRINT contains data operations (DATA_WRITE/DELETE/MIGRATION/SEED/CONFIG_WRITE).

## 1. WHEN TRIGGERED
□ ANY file classified as DATA_WRITE, DATA_DELETE, MIGRATION, SEED, or CONFIG_WRITE
□ No backup = no PATCH (S-23) — this is NON-NEGOTIABLE (LAW 2)

## 2. CREATE BACKUP
□ Identify what to back up (collections, files, configs in scope)
□ For 🔴 HIGH risk: TWO-LAYER backup (git + desktop copy)
□ For all others: git-based backup sufficient
□ Record backup details

## 3. BACKUP PROOF (present to operator)
```
| Field          | Value                    |
|----------------|--------------------------|
| Timestamp      | <ISO 8601>               |
| Location       | <actual path or export>  |
| Scope          | <what was backed up>     |
| Restore method | <exact commands/steps>   |
| Verified       | YES / NO + how verified  |
| Size           | <record count or size>   |
```

## 4. RESTORE TEST (MANDATORY for DELETE/MIGRATION)
□ If data op is DATA_DELETE or MIGRATION:
  → Run restore in test environment
  → Verify: records backed up == records restored
  → Verify: sample record matches original
  → Record PASS/FAIL

```
| Field              | Value            |
|--------------------|------------------|
| Environment        | <where tested>   |
| Records backed up  | <N>              |
| Records restored   | <N>              |
| Sample verified    | YES / NO         |
| Result             | PASS / FAIL      |
```

## STOP CONDITIONS THIS PHASE
- S-23: Backup not created before data operation → BLOCKER

## NEXT

```
🛑 END RESPONSE HERE. Write this as your LAST line:
⏸️ Gate: 🔑 BACKUP OK?
Do NOT produce PATCH output in this same response.
Do NOT proceed until the operator responds with approval.
```

Present backup proof (+ restore test if applicable) to operator.
Load **ANT_PATCH** card only AFTER operator approves in their next message.
