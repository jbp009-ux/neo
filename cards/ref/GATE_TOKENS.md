# GATE TOKENS — Complete Token Vocabulary
> All roles reference this card. Tokens require 🔑 prefix. Human-issued ONLY.

## PIPELINE GATE TOKENS

| Token | Issued By | Unlocks |
|-------|-----------|---------|
| `🔑 DISCOVERY APPROVED` | Operator | L1 permissions (read + verify) |
| `🔑 DISCOVERY EXPANSION APPROVED` | Operator | Extended DISCOVERY budget |
| `🔑 FOOTPRINT APPROVED` | Operator | PATCH state |
| `🔑 FOOTPRINT APPROVED WITH CHANGES: <text>` | Operator | PATCH state (modified) |
| `🔑 BACKUP APPROVED` | Operator | PATCH state (data ops) |
| `🔑 PATCH APPROVED` | Operator | VERIFY state |
| `🔑 VERIFY APPROVED` | Operator | REPORT state |
| `🔑 REPORT APPROVED` | Operator | Ghost REVIEW |
| `🔑 GHOST APPROVED` | Ghost/Operator | Inspector or COMPLETE |
| `🔑 INSPECTOR PASS` | Inspector/Operator | COMPLETE |
| `🔑 TASK COMPLETE` | Operator | Pipeline ends |
| `🔑 RUN COMPLETE` | BECCA | Run closes — all tasks done |
| `🔑 QA REPORT COMPLETE` | QA Ant | QA cycle done |
| `🔑 GHOST APPROVED WITH NOTES: <notes>` | Ghost | Approved but with advisory notes |

## PLANNER TOKENS

| Token | Issued By | Unlocks |
|-------|-----------|---------|
| `🔑 PLAN SKELETON OK` | Operator | DETAIL pass |
| `🔑 TASK BATCH <N> OK` | Operator | Next batch or RUN PLAN |
| `🔑 RUN PLAN APPROVED` | Operator | First Ant dispatch |

## DEVTOOLS TOKENS

| Token | Issued By | Unlocks |
|-------|-----------|---------|
| `🔑 DEVTOOLS CHIEF COMPLETE` | BECCA | Specialist dispatch |
| `🔑 DEVTOOLS SPECIALISTS COMPLETE` | BECCA | DevTools verdict |
| `🔑 DEVTOOLS VERIFICATION APPROVED` | BECCA | CLOSE continues |

## CDEX TOKENS

| Token | Purpose |
|-------|---------|
| `OUTPUT_INVALID` | Card output failed validation |
| `CARD_WAIVER` | CORE card intentionally skipped (requires justification) |
| `FAIL_BLOCKING` | DevTools finding blocks merge |

## OVERRIDE TOKENS

| Token | Purpose |
|-------|---------|
| `🔑 CRITICAL SURFACE OVERRIDE: <file>` | Allow editing a critical surface (single-use, single-file) |
| `🔑 WIPE OVERRIDE: <collection>` | Allow collection overwrite |
| `🔑 FEATURE REMOVAL OVERRIDE: <feature>` | Allow removal of a protected feature |
| `🔑 PRODUCTION CONFIRMED` | Allow destructive op targeting production |
| `🔑 NUCLEAR RESOLVED: <action>` | Clear NUCLEAR HALT — pipeline resumes |
| `🔑 BRANCH_PROTECTION_BYPASS APPROVED` | Allow push to protected branch |
| `🔑 CROSS-PROJECT READ` | Allow reading files in another governed project |

## CONTROL TOKENS

| Token | Purpose |
|-------|---------|
| `🔑 CONTINUE` | Clear a STOP condition |
| `🔑 GO` | Clear a STOP condition (alias) |
| `🔑 ROLLBACK` | Revert changes to pre-patch state |
| `🔑 STOP` | Halt all pipeline activity |

## REJECTION TOKENS

| Token | Effect |
|-------|--------|
| `🔑 REJECTED: <reason>` | Step must be revised |
| `🔑 GHOST REJECTED: <reason>` | Back to Ant |
| `🔑 GHOST CHANGES REQUESTED: <list>` | Back to Ant for specific fixes |
| `🔑 INSPECTOR FAIL: <reason>` | Operator decides |

## TOKEN RULES
□ Must start with 🔑 emoji — no exceptions
□ Human-issued only — no self-approval
□ One per gate — exactly one token per transition
□ Exact verbatim — paraphrases are INVALID (V-12)
□ "looks good" / "ok" / "LGTM" = NOT a token → STOP, request exact token
□ `<text>` / `<reason>` portions are freeform — only the prefix must be exact
