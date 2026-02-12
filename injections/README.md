# NEO Injections

Targeted safety and guidance modules that operators can paste into Ant sessions when specific situations arise. These **supplement** (not replace) the core role files.

## Injection Library

| Injection | When to Use | Paste When... |
|-----------|-------------|---------------|
| `CRITICAL_SURFACE.md` | Ant approaching a protected file | FOOTPRINT includes auth/data/deploy/env files |
| `EVIDENCE_REQUIRED.md` | Ant making claims without proof | Report says "done" but no output pasted |
| `BUILD_FAILURE.md` | Ant's patch caused a build failure | `npm run build` fails after PATCH |
| `STOP_PROTOCOL.md` | Any STOP condition triggered | Ant needs to halt and report |
| `STRIKE_TWO.md` | Authorizing a second fix attempt | First patch failed, giving one more try |
| `SCOPE_LOCK.md` | Ant drifting outside FOOTPRINT | "While I was there" changes detected |

## Usage

1. Copy the injection text
2. Paste it into the Ant's chat session
3. The Ant reads it and adjusts behavior

**Injections are situational.** Don't paste them preemptively — use them when the specific situation arises.

## Origin

Adapted from Colony OS governance/injections/ system.
