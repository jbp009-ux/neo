# NEO Git Hooks Templates

Git hooks that get deployed to target projects via `neo-init.ps1`.

## Hooks

| Hook | Purpose | Blocks on |
|------|---------|-----------|
| `pre-commit` | Runs `lint-staged` on staged files | Lint errors in changed files |
| `pre-push` | Runs `build` + `test` | Build errors or test failures |

## Setup in Target Project

### Option A: Via neo-init (Automatic)

`neo-init.ps1` installs Husky and copies these hooks to the project's `.husky/` directory.

### Option B: Manual Setup

```bash
# 1. Install Husky
npm install --save-dev husky lint-staged
npx husky init

# 2. Copy hooks
cp templates/git-hooks/pre-commit .husky/pre-commit
cp templates/git-hooks/pre-push .husky/pre-push

# 3. Add lint-staged config to package.json
```

### lint-staged Configuration

Add to target project's `package.json`:

```json
{
  "lint-staged": {
    "*.{ts,tsx,js,jsx}": ["eslint --fix", "prettier --write"],
    "*.{css,scss}": ["prettier --write"],
    "*.{json,md}": ["prettier --write"]
  }
}
```

## Customization

The `pre-push` hook runs `npm run build && npm test`. If a project uses different commands (e.g., `npm run build:prod` or `npm run test:rules:emu`), edit the hook in the project's `.husky/` directory after deployment.
