# FILE_OWNERSHIP — <directory>

<!--
FORMAT: Per-file sections with modification history table

SHARDING:
- One file per directory prefix (first two path segments)
- src/functions/auth.ts → FILE_OWNERSHIP_src_functions.md
- src/app/login/page.tsx → FILE_OWNERSHIP_src_app.md
- firestore.rules (root) → FILE_OWNERSHIP_root.md
- BECCA creates new shards on demand during CLOSE

CHANGE TYPES:
- READ    — File was analyzed but not modified
- MODIFY  — File was changed (code edits)
- CREATE  — File was newly created
- DELETE  — File was removed

RULES:
- Append-only within each file section
- ONLY BECCA writes to this file (during CLOSE)
- New file sections created as encountered
- See shared/NEO-HIVE.md for full specification

SEARCHING:
  grep -A 20 "## src/functions/auth.ts" .neo/index/FILE_OWNERSHIP_src_functions.md
  grep "MODIFY" .neo/index/FILE_OWNERSHIP_*.md
-->

<!--
EXAMPLE:

## src/functions/sonnyAI.ts
| Task | Date | Ant Type | Change | Risk | Pheromones |
|------|------|----------|--------|------|------------|
| TASK-001 | 2026-02-10 | 📊 Analyst | READ | 🟢 LOW | None |
| TASK-005 | 2026-02-11 | 🔥 Fire Ant | MODIFY | 🔴 HIGH | ⚫ NUCLEAR: cross-tenant query |

## src/functions/cartFunctions.ts
| Task | Date | Ant Type | Change | Risk | Pheromones |
|------|------|----------|--------|------|------------|
| TASK-001 | 2026-02-10 | 📊 Analyst | READ | 🟢 LOW | None |
-->

