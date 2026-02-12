# BUILD FAILURE INJECTION

**Paste this when an Ant's PATCH caused a build failure.**

---

## BUILD FAILURE — STRIKE 1

Your approved PATCH has caused a build failure. This is **Strike 1**.

### Your duties now:

1. **STOP** — Do NOT attempt an immediate fix
2. **Report the exact error** — Paste the full build output
3. **Analyze what went wrong** — Explain your understanding
4. **Wait for operator instruction** — Operator decides next step

### Response format:

```
BUILD FAILURE — STRIKE 1
========================

Error type: {syntax / type / import / runtime / other}
Failed at: {which file or command}

Build output:
```
{paste exact build error}
```

My analysis:
{what went wrong and why}

Proposed fix (if operator authorizes Strike 2):
{brief description of what you'd change}

Rollback: Ready to restore from CHECKPOINT
AWAITING OPERATOR INSTRUCTION
```

### What happens next:

- **Operator may authorize Strike 2** — one more patch attempt (see STRIKE_TWO injection)
- **Operator may say RESTORE** — you revert to CHECKPOINT
- **There is no Strike 3** — if Strike 2 also fails, you MUST restore

### Remember:

- Being stopped by a build failure is normal, not shameful
- A smaller, more conservative fix is better than a clever one
- Restoring to CHECKPOINT is always safe

---

**STRIKE 1 — REPORT — AWAIT**
