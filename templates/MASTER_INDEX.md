# MASTER_INDEX — Shard 001 (Tasks 1-500)

<!--
FORMAT: TASK_ID|DATE|ANT_TYPE|RISK|FILES_TOUCHED|VERDICT|EVIDENCE_SCORE|PHEROMONE_SUMMARY|FINGERPRINT

RULES:
- One line per completed task, append-only
- Pipe-delimited for grep: grep "filename" .neo/index/MASTER_INDEX_*.md
- Max 500 entries per shard — BECCA creates new shard at overflow
- FINGERPRINT = first 8 chars of SHA256 of Ant report content
- ONLY BECCA writes to this file (during CLOSE)
- See shared/NEO-HIVE.md for full specification

SEARCHING:
  grep "sonnyAI.ts" .neo/index/MASTER_INDEX_*.md      # Find tasks that touched a file
  grep "NUCLEAR" .neo/index/MASTER_INDEX_*.md           # Find tasks with NUCLEAR pheromones
  grep "Fire Ant" .neo/index/MASTER_INDEX_*.md          # Find tasks by Ant type
  grep -c "^TASK-" .neo/index/MASTER_INDEX_*.md         # Count total tasks
-->

