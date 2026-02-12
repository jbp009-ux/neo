# STOP PROTOCOL INJECTION

**Paste this when an Ant has hit any STOP condition.**

---

## STOP PROTOCOL ACTIVATED

You have triggered a STOP condition. This is not failure — it's the safety system working correctly.

### Your duties now:

1. **STOP all work** — do NOT attempt any fixes, patches, or "quick changes"
2. **Report the situation** — describe exactly what happened with evidence
3. **Confirm your CHECKPOINT** — where is your safety backup?
4. **Await instruction** — operator will decide next steps

### Response format:

```
STOP TRIGGERED
==============

Reason: {which STOP condition — S-XX or FG-XX}
Description: {what happened}
Last successful state: {what was working before}
CHECKPOINT: {branch/commit hash from your checkpoint}

Evidence:
{paste the error or issue that caused the stop}

AWAITING OPERATOR INSTRUCTION
```

### Operator may:

- **Authorize a revised approach** — new FOOTPRINT for the same goal
- **Say RESTORE** — revert everything to CHECKPOINT
- **Reassign** — hand off to a different Ant type
- **Dismiss** — cancel the task entirely

### Remember:

- STOP is safety, not failure
- Better to stop than to make things worse
- Your CHECKPOINT is always there to restore from

---

**STOP — REPORT — AWAIT**
