# NEO — Pipeline Governance Framework

## THIS IS THE FRAMEWORK SOURCE, NOT A GOVERNED PROJECT

This repository IS the NEO Pipeline Governance Framework itself. It contains the role definitions, shared modules, templates, and deployment scripts that get deployed to target projects.

```
DO NOT run BECCA ACTIVATE here. This is the source, not a target.
DO NOT create a .neo/ directory here. Projects get .neo/, not the framework.
```

---

## WHAT THIS REPO CONTAINS

```
neo/
├── roles/                    ← The 4 role protocols
│   ├── NEO-BECCA.md         ← Orchestrator (v1.8.0)
│   ├── NEO-ANT.md           ← Worker (v1.10.0)
│   ├── NEO-GHOST.md         ← Reviewer (v1.9.0)
│   └── NEO-INSPECTOR.md    ← Auditor (v1.5.0)
│
├── shared/                   ← Modules loaded by every role
│   ├── NEO-ACTIVATION.md   ← "I AM" protocol & TODO coordination
│   ├── NEO-GATES.md        ← State machine & approval tokens
│   ├── NEO-EVIDENCE.md     ← Evidence requirements
│   ├── NEO-OUTPUTS.md      ← Output formats
│   ├── NEO-TOOLS.md        ← Tool permissions per role
│   ├── NEO-HIVE.md         ← Hive Mind indexes & write contracts
│   ├── NEO-SURGICAL.md     ← 3 Laws of Surgical Change
│   └── NEO-HIVEMIND-GLOBAL.md ← Cross-project shared knowledge
│
├── templates/                ← Templates for all artifacts
│   ├── ANT_REPORT.md
│   ├── GHOST_REVIEW.md
│   ├── INSPECTOR_REPORT.md
│   ├── PROJECT_TODO.md
│   ├── OPERATOR_MANUAL.md
│   ├── CLAUDE_PROJECT.md    ← Template for project CLAUDE.md files
│   ├── MANUAL_DRIFT_REPORT.md
│   └── ... (7 more)
│
├── prompts/                  ← Specialized role prompts
│   └── COLOR_EXPERT_ANT.md
│
├── scripts/                  ← Deployment scripts
│   ├── neo-init.ps1         ← First-time deploy to a project
│   └── neo-refresh.ps1      ← Update an existing project's NEO files
│
├── playbook/                 ← Operator training materials
│   ├── OPERATOR_PLAYBOOK.md ← Main training manual
│   ├── NEO_SYSTEM_GUIDE.md  ← End-to-end system guide
│   ├── SONNY_BRIEFING.md    ← Sonny project briefing
│   ├── RIZEND_BRIEFING.md   ← RIZEND project briefing
│   └── CHEAT_SHEET.md       ← Quick reference
│
└── CLAUDE.md                 ← This file
```

---

## GOVERNED PROJECTS

NEO is currently deployed to these projects:

| Project | Path | Domain | Stack |
|---------|------|--------|-------|
| **Sonny** | `d:\projects\sonny\` | `*.sonny8.ai` | Next.js 16 + Firebase + Gemini |
| **RIZEND** | `d:\projects\trainer-os\` | `rizend.com` | Next.js 14 + Firebase + Anthropic |

Each project has its own `.neo/` directory with the full governance system, Operator Manual, Hive Mind indexes, and run history.

---

## HOW TO WORK IN THIS REPO

### Editing Role Files
When the operator asks to modify a role (BECCA, Ant, Ghost, Inspector):
1. Edit the file in `roles/`
2. Increment the version number in the file header
3. Add a changelog entry at the bottom of the file
4. After changes: run `neo-refresh.ps1` on both projects to sync

### Editing Shared Modules
Same process as role files — edit in `shared/`, bump version, sync with refresh.

### Editing Templates
Templates in `templates/` are copied to projects during init/refresh. Edit here, sync to projects.

### Deploying NEO to a New Project
```powershell
.\scripts\neo-init.ps1 -ProjectPath "d:\projects\new-project"
```

### Refreshing NEO on Existing Projects
```powershell
.\scripts\neo-refresh.ps1 -ProjectPath "d:\projects\sonny"
.\scripts\neo-refresh.ps1 -ProjectPath "d:\projects\trainer-os"
```

---

## WHAT YOU CAN DO HERE

- Read and edit role files, shared modules, templates
- Read and edit playbook documents
- Read and edit deployment scripts
- Create new templates or prompts
- Update the Global Hivemind (`shared/NEO-HIVEMIND-GLOBAL.md`)

## WHAT YOU SHOULD NOT DO HERE

- Run BECCA ACTIVATE (this is the framework, not a project)
- Create a `.neo/` directory (projects get `.neo/`, not the framework)
- Run code builds/tests (there's no application code here)
- Modify governed project files from here (go to that project's directory)
