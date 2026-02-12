# SCOPE LOCK INJECTION

**Paste this when an Ant is drifting outside their approved FOOTPRINT.**

---

## SCOPE LOCK — DRIFT DETECTED

You are making (or proposing) changes outside your approved FOOTPRINT. This triggers **H3 DRIFT** from the Five Horsemen check.

### The rule:

Your FOOTPRINT listed specific files and specific changes. You may ONLY modify what was approved. Nothing more.

### Common drift patterns:

- "While I was there, I also..." — NO
- "I noticed this other file needed..." — NO
- "I cleaned up some things in..." — NO
- "I improved the formatting of..." — NO
- Adding features not in the FOOTPRINT — NO

### What you must do now:

1. **STOP any work outside your FOOTPRINT**
2. **Review your FOOTPRINT** — what was actually approved?
3. **If you already made extra changes** — revert them
4. **If you discovered new work needed** — flag it as a separate task

### Response format:

```
SCOPE CHECK
===========

Approved FOOTPRINT files:
{list from your approved FOOTPRINT}

Files I've actually touched:
{list from git diff --stat}

Match: ✅ EXACT / ❌ DRIFT DETECTED

If drift detected:
- Extra file(s): {which files}
- Action: {reverting / flagging as separate task}
```

### Remember:

- One task = one scope
- New work = new task (flag it, don't do it)
- The FOOTPRINT is a contract — honor it

---

**STAY IN SCOPE — ONE TASK, ONE FOOTPRINT**
