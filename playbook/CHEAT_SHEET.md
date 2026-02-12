# NEO CHEAT SHEET
## Quick Reference for Daily Operations

---

## Start a Run

```
YOU: "BECCA ACTIVATE" or "deep dive into [project]"
→ BECCA does RECON → shows summary → dispatches Scout
→ Scout creates TODO → YOU approve
→ For each task: "I AM" cycles through Ant → Ghost → Inspector
→ When all done: "I AM" for BECCA CLOSE
```

---

## Gate Approval Commands

| Say This | To Do This |
|----------|-----------|
| `I AM` | Activate next role (Ant/Ghost/Inspector/BECCA) |
| `approved` / `Y` | Approve current gate |
| `rejected` / `N` | Reject — Ant loops back |
| `1`, `2`, `3` | Pick an option from BECCA's list |

---

## Pipeline Order (per task)

```
ANT: Checkpoint → Discovery → Footprint → Backup? → Patch → Verify → Report
        ↓            ↓           ↓           ↓         ↓        ↓         ↓
      (auto)       (stop)     (approve)  (approve)  (approve) (approve) (approve)

GHOST: Review (8 sections) → Verdict
        ↓                       ↓
      (reads)              (approve/reject)

INSPECTOR: Audit → Verdict
             ↓        ↓
           (reads)  (pass/fail)
```

---

## Common Operations

### Deploy a Function (Sonny)
```bash
firebase deploy --only functions:functionName
```

### Deploy a Function (Rizend)
```bash
firebase deploy --only functions:functionName
```

### Run Tests (Sonny)
```bash
cd functions && npm test                    # All 896 tests
cd functions && npx jest --testPathPattern="cartFunctions"  # Specific
npm run test:rules                          # Security rules
```

### Start Emulators
```bash
firebase emulators:start    # Auth:9099, Functions:5001, Firestore:8080, UI:4000
```

### Refresh NEO Files (after framework updates)
```powershell
.\neo-refresh.ps1 -ProjectPath "d:\projects\sonny"
.\neo-refresh.ps1 -ProjectPath "d:\projects\trainer-os"
```

---

## Severity Levels (Know These)

```
⚫ NUCLEAR  — Total stop. Data loss / security breach risk.
   BLOCKER  — Task cannot pass. Must be fixed.
🔴 HIGH     — Significant risk. Extra review needed.
🟠 MEDIUM   — Moderate concern. Monitor.
🟡 LOW      — Minor. Fix when convenient.
🟢 INFO     — Observation. No action needed.
```

---

## When You See These, Pay Attention

| Signal | What It Means |
|--------|-------------|
| "⚫ NUCLEAR pheromone active" | Ant found danger — you must approve or block |
| "Evidence score: XX%" | Below 70% = weak evidence. Below 50% = auto-reject. |
| "MISMATCH" in Ghost 4b | Ant's test results don't match reality — fake evidence |
| "MANUAL_DRIFT" | Operator Manual is out of date — Leafcutter needed |
| "Data Op: DATA_WRITE" | Ant will modify data — backup gate will trigger |
| "CRITICAL SURFACE" | Ant is touching a high-risk file |

---

## Project Quick Facts

| | **Sonny** | **Rizend** |
|--|-----------|-----------|
| Path | `d:\projects\sonny\` | `d:\projects\trainer-os\` |
| Domain | `*.sonny8.ai` | `rizend.com` |
| Stack | Next.js 16 + Firebase | Next.js 14 + Firebase |
| AI | Gemini 2.0 Flash | Anthropic SDK |
| Functions | 94 | 155+ |
| Collections | 63+ | 80+ |
| Tests | 896 | — |
| NEO Runs | 5 (20 tasks) | 3 (13 tasks) |
| Nuclear Lock | Menu data (PH-MENU-001) | — |
| Frontend Host | Firebase Hosting | Cloudflare Pages |

---

## File Locations

| What | Where |
|------|-------|
| NEO Framework | `d:\projects\neo\` |
| Role Definitions | `d:\projects\neo\roles\` |
| Shared Modules | `d:\projects\neo\shared\` |
| Templates | `d:\projects\neo\templates\` |
| **This Playbook** | `d:\projects\neo\playbook\` |
| Global Hivemind | `d:\projects\neo\shared\NEO-HIVEMIND-GLOBAL.md` |
| Sonny Manual | `d:\projects\sonny\.neo\OPERATOR_MANUAL_SONNY.md` |
| Rizend Manual | `d:\projects\trainer-os\.neo\OPERATOR_MANUAL_TRAINER.md` |
| Sonny State | `d:\projects\sonny\.neo\STATE.md` |
| Rizend State | `d:\projects\trainer-os\.neo\STATE.md` |

---

## Emergency Procedures

| Situation | Do This |
|-----------|---------|
| Chat crashed mid-run | Start fresh session. BECCA reads STATE.md and resumes. |
| Ant did something wrong | Ghost will catch it. If not, Inspector will. If BOTH miss it, reject manually. |
| Wrong project locked | Start a new run on the correct project. |
| Nuclear pheromone blocking | Read the pheromone details. Resolve the risk, then clear. |
| Manual out of date | Run MANUAL_DRIFT inspection. Dispatch Leafcutter. |
| Need to undo Ant's changes | `git stash pop` or `git checkout .` — Ant created a checkpoint. |
