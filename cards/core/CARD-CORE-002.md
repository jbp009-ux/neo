# CARD-CORE-002: Backup-First Proof

**Purpose:** Ensure data is backed up before any destructive or data-modifying operation
**Phase:** BACKUP (between FOOTPRINT and PATCH)
**Required:** CONDITIONAL — required when ANY file in FOOTPRINT has Data Op ≠ CODE_ONLY/READ_ONLY

## INPUTS REQUIRED
- FOOTPRINT with Data Op Classification table
- Target environment (EMULATOR / STAGING / PRODUCTION)
- Backup destination path

## STEPS (max 5)
1. Identify ALL files with data operations (DATA_WRITE, DATA_DELETE, MIGRATION, SEED, CONFIG_WRITE)
2. Execute backup for each data target (export document/collection, copy config)
3. Verify backup exists and is non-empty (file size > 0, record count matches)
4. If DATA_DELETE or MIGRATION: perform actual restore test (not attestation-only)
5. Document: timestamp, location, scope, restore method, verification result

## OUTPUT REQUIRED
- Backup proof table (per NEO-SURGICAL.md LAW 2)
- Restore test result (if applicable)
- `🔑 BACKUP APPROVED` token in gate log

## ACCEPTANCE CRITERIA
| # | Check | Pass/Fail |
|---|-------|-----------|
| 1 | Every data-op file has a corresponding backup | |
| 2 | Backup files exist and are non-empty | |
| 3 | Restore test passed (if DELETE/MIGRATION) | |
| 4 | `🔑 BACKUP APPROVED` present in gate log | |

## FAIL MODE
FAIL_BLOCKING — No patch without backup. If backup fails, STOP and report to operator.

## MANUAL REFERENCES (per step)
- Step 1: `shared/NEO-EVIDENCE.md` — Data Op Classification table (valid types: CODE_ONLY, DATA_WRITE, DATA_DELETE, MIGRATION, SEED, CONFIG_WRITE)
- Step 2: `shared/NEO-SURGICAL.md` — LAW 2: Backup-First (backup methods + requirements)
- Step 3: `shared/NEO-EVIDENCE.md` — Backup Evidence Requirements (non-empty, record count)
- Step 4: `shared/NEO-SURGICAL.md` — LAW 2: Restore Test (actual restore, not attestation-only)
- Step 5: `templates/ANT_REPORT.md` — Section 3b: Backup Proof format

## WAIVER CONDITION
If ALL files in FOOTPRINT are CODE_ONLY or READ_ONLY, this card may be waived with a CARD_WAIVER citing the Data Op Classification table as evidence.
