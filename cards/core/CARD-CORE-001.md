# CARD-CORE-001: Load Policy Pack + Pheromones

**Purpose:** Ensure the agent has full context before doing any work
**Phase:** CHECKPOINT (before any other phase)
**Required:** YES — always

## INPUTS REQUIRED
- Project `.neo/` directory path
- Role file path (from TODO)
- Task packet (from `.neo/inbox/`)

## STEPS (max 5)
1. Read your role file from `roles/` — confirm your identity and permissions
2. Load shared modules listed in your role file (NEO-GATES, NEO-EVIDENCE, NEO-SURGICAL, etc.)
3. Read active pheromones: `.neo/index/PHEROMONE_NUCLEAR.md`, `PHEROMONE_HIGH.md`
4. Read HIVE CONTEXT from task packet (file history, scored lessons, rejection patterns)
5. Confirm policy loaded — state which modules read and which pheromones noted

## OUTPUT REQUIRED
- List of modules loaded (with versions)
- Active pheromones acknowledged (especially NUCLEAR)
- Lessons from HIVE CONTEXT acknowledged

## ACCEPTANCE CRITERIA
| # | Check | Pass/Fail |
|---|-------|-----------|
| 1 | Role file read and identity stated | |
| 2 | All required shared modules loaded (count matches role file) | |
| 3 | NUCLEAR pheromones acknowledged (or "none active") | |
| 4 | HIVE CONTEXT lessons referenced (or "no lessons injected") | |

## FAIL MODE
FAIL_BLOCKING — Agent cannot proceed to DISCOVERY without policy context. Re-run this card.

## MANUAL REFERENCES (per step)
- Step 1: `roles/NEO-ANT.md` (or role for this agent) — Identity section + shared module list
- Step 2: `shared/` directory — each module listed in role file header (GATES, EVIDENCE, SURGICAL, HIVE, etc.)
- Step 3: `shared/NEO-HIVE.md` — PHEROMONE_REGISTRY index format; `.neo/index/PHEROMONE_*.md` files
- Step 4: `shared/NEO-HIVE.md` — HIVE CONTEXT structure; `templates/TASK_PACKET.md` — HIVE CONTEXT section
- Step 5: `shared/NEO-ACTIVATION.md` — "I AM" protocol and identity confirmation
