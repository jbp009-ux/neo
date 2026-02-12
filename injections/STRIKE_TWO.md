# STRIKE TWO INJECTION

**Paste this when authorizing a second patch attempt after Strike 1.**

---

## STRIKE 2 — FINAL ATTEMPT

Operator has authorized one more PATCH attempt. This is **Strike 2 — your last chance**.

### Critical rules for Strike 2:

1. **This is your LAST attempt** — there is no Strike 3
2. **Be more conservative** — smaller change than your first attempt
3. **Double-check everything** — verify syntax, imports, types before presenting
4. **If this fails → RESTORE** — no negotiation, no "one more try"

### Before presenting your Strike 2 patch:

- [ ] Have I understood WHY Strike 1 failed?
- [ ] Is this fix addressing the root cause?
- [ ] Is this change SMALLER than my first attempt?
- [ ] Have I verified the syntax is correct?
- [ ] Have I checked all imports exist?

### Response format:

```
STRIKE 2 PATCH
==============

What failed in Strike 1: {brief explanation}
Root cause: {what actually went wrong}
This fix: {how this addresses the root cause}

Why this is safer:
- {reason 1}
- {reason 2}

PATCH:
{your conservative, well-checked changes}

I understand: If this fails, I will immediately STOP and RESTORE.
```

### If Strike 2 fails:

You will immediately:
1. STOP
2. Restore to CHECKPOINT
3. Document the failure in your REPORT

---

**FINAL ATTEMPT — BE CONSERVATIVE — BE PRECISE**
