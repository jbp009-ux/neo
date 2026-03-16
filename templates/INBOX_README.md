# NEO Inbox — Ideas Folder

## What Is This?

Drop your big idea documents here. The Planner Ant reads these during the PLAN phase and decomposes them into small, sequenced, Ant-sized tasks.

## How To Use

1. Create or place your document in `.neo/inbox/ideas/`
2. Start a NEO run (BECCA ACTIVATE)
3. BECCA's Scout surveys the project, then BECCA assesses whether to activate the Planner
4. The Planner reads your documents, cross-references the codebase and Hive Mind, and produces a run plan

## Accepted Formats

| Format | Extension | Notes |
|--------|-----------|-------|
| Markdown | `.md` | Preferred — read directly |
| PDF | `.pdf` | Max 20 pages per file |
| Images | `.png`, `.jpg` | Read visually — mockups, wireframes, screenshots |
| Text | `.txt` | Plain text requirements |

## Tips

- **Be specific.** "Add voice ordering" is better than "improve the app."
- **Include acceptance criteria** if you have them.
- **One idea per file** keeps planning clean.
- **Large documents** (>500 lines) will be summarized first — the Planner will ask which sections to focus on.

## After Planning

- Task packets are written to `.neo/inbox/TASK_<ID>.md`
- The run plan is written to `.neo/RUN_PLAN_<NNN>.md`

## After Run Completes

When BECCA CLOSE finishes, your idea documents are **archived** automatically:

```
inbox/ideas/completed/run-150/feature-plan.pdf
inbox/ideas/completed/run-150/mockup.png
```

Documents move from `ideas/` → `ideas/completed/run-<NNN>/` so the inbox is clean for the next run. Completed docs stay in `completed/` for future reference — they are never deleted.
