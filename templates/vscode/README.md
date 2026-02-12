# NEO VS Code Templates

VS Code configuration files deployed to target projects via `neo-init.ps1`.

## Files

| File | Purpose | Keyboard Shortcut |
|------|---------|-------------------|
| `tasks.json` | Build/test/lint tasks | `Ctrl+Shift+B` (build), `Ctrl+Shift+T` (test) |
| `settings.json` | Editor settings — format on save, ESLint auto-fix | — |
| `extensions.json` | Recommended extensions | — |

## Tasks Available

| Task | What It Does |
|------|--------------|
| **Build** | `npm run build` — default build task |
| **Dev Server** | `npm run dev` — starts dev server in background |
| **Lint** | `npm run lint` — ESLint check |
| **Test** | `npm run test` — run test suite |
| **Type Check** | `npx tsc --noEmit` — TypeScript check |
| **NEO: Claude Code** | Launches Claude Code in a terminal |
| **NEO: Build + Test + Lint** | Runs all three sequentially |

## Customization

After deployment, projects should customize:

1. **Test command** — change `npm run test` to project-specific test command
2. **Build command** — adjust if using different build tool
3. **Add project-specific tasks** — e.g., Firebase deploy, Docker, etc.

## Deployment

`neo-init.ps1` copies these to `$ProjectPath/.vscode/` (only if `.vscode/` doesn't already exist — won't overwrite).
