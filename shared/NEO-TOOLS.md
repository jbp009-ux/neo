# NEO-TOOLS v1.3.0
## Tool Permissions — Role-Based Access Control

**Purpose:** Which tools each NEO role can use, critical surface protections
**Scope:** Loaded by ALL NEO roles (Ant, Ghost, Inspector)

---

## 1) Tool Permission Matrix

| Tool | Ant | Ghost | Inspector |
|------|-----|-------|-----------|
| **Read** (files) | ✅ Full | ✅ Full | ✅ Full |
| **Edit** (files) | ✅ Full | ❌ Forbidden | ❌ Forbidden |
| **Write** (new files) | ✅ Full | ❌ Forbidden | ❌ Forbidden |
| **Glob** (find files) | ✅ Full | ✅ Full | ✅ Full |
| **Grep** (search) | ✅ Full | ✅ Full | ✅ Full |
| **Bash** (commands) | ✅ Full | 🔒 Read-Only | 🔒 Read-Only |
| **Git** (version control) | ✅ Full | 🔒 Read-Only | 🔒 Read-Only |
| **npm/build** | ✅ Full | 🔒 Run checks only | ❌ Forbidden |
| **Tests** | ✅ Full | 🔒 Run only (no write) | ❌ Forbidden |
| **Lint/Format** | ✅ Full | 🔒 Check only | 🔒 Check only |
| **Type check** | ✅ Full | 🔒 Check only | 🔒 Check only |

### Permission Legend

| Symbol | Meaning |
|--------|---------|
| ✅ Full | Can read and write/execute |
| 🔒 Read-Only | Can run checks/reads but NOT modify |
| ❌ Forbidden | Cannot use at all |

---

## 2) Role-Specific Tool Rules

### Ant (Worker)
```
ANT TOOL AUTHORITY:
├── Read/Edit/Write: ✅ — Core working tools
├── Bash: ✅ — Build, test, deploy commands
├── Git: ✅ — Commit, branch, push (with operator approval)
├── npm/build: ✅ — Install, build, test
├── Lint/Format: ✅ — Fix and verify
│
└── RESTRICTIONS:
    ├── No force-push without explicit operator approval
    ├── No dependency changes without operator approval
    ├── No production deployments
    └── No security rule modifications without escalation
```

### Ghost (Reviewer)
```
GHOST TOOL AUTHORITY:
├── Read/Glob/Grep: ✅ — Inspect all files
├── Bash: 🔒 — Run checks, view output (no modifications)
├── Git: 🔒 — View log, diff, status (no commits)
├── Lint/Format/Type check: 🔒 — Run checks, report pass/fail
│
├── Ghost REVIEWS, Ghost does NOT FIX
│   If lint/format/type fails → report finding (not fix it)
│
└── FORBIDDEN:
    ├── ❌ Edit/Write — Cannot modify any files
    ├── ❌ Git commit/push — Cannot change version control
    └── ❌ npm install/build — Cannot modify dependencies
```

### Inspector (Auditor)
```
INSPECTOR TOOL AUTHORITY:
├── Read/Glob/Grep: ✅ — Inspect all files
├── Lint/Format/Type check: 🔒 — Run checks only
│
├── Inspector REPORTS, Inspector does NOT FIX
│   Findings are recommendations, not actions
│
└── FORBIDDEN:
    ├── ❌ Edit/Write — Cannot modify any files
    ├── ❌ Bash (destructive) — No builds, installs, deploys
    ├── ❌ Git (write) — No commits, pushes
    └── ❌ npm — No installs or builds
```

---

## 3) Enforcement

### Violation Detection

If a role uses a tool outside its permissions:

| Violation | Response |
|-----------|----------|
| Ghost edits a file | `🔑 REJECTED: Ghost cannot modify files` |
| Inspector runs build | `🔑 REJECTED: Inspector cannot run builds` |
| Ant force-pushes | `🔑 REJECTED: Force-push requires operator approval` |
| Any role deploys to prod | `🔑 REJECTED: Production deployment forbidden` |

### Who Checks

- **Ghost** checks Ant's tool usage during review
- **Inspector** checks all roles' tool usage during audit
- **Operator** has final authority on tool permission exceptions

---

## 4) Debugger Ant Tool Permissions

The 🐛 Debugger Ant has a **restricted** tool set compared to standard Ants.

```
DEBUGGER ANT TOOL AUTHORITY:
├── Read/Glob/Grep: ✅ — Investigate code
├── Bash: 🔒 — Run tests, read logs (NO modifications)
├── Tests: 🔒 — Run existing tests (NO writing new tests)
├── Lint/Format/Type check: 🔒 — Run checks only
│
├── Debugger DIAGNOSES. Debugger does NOT FIX.
│   Produce TEST_REPORT, hand off to appropriate Ant type.
│
└── FORBIDDEN:
    ├── ❌ Edit/Write — Cannot modify any files
    ├── ❌ Git commit/push — Cannot change version control
    └── ❌ npm install/build — Cannot modify dependencies
```

**The Debugger Ant has the same permissions as Ghost** — read-only investigation with test execution.

---

## 5) Figma Ant Tool Permissions

The 🖌️ Figma Ant has **standard Ant permissions** plus access to **TWO Figma MCP servers**:

1. **figma-official** — Figma's remote MCP server (design context, variables, Code Connect, screenshots)
2. **figma-edit** — Claude Talk to Figma WebSocket bridge (two-way: read designs + build inside Figma)

```
FIGMA ANT TOOL AUTHORITY:
├── Read/Edit/Write: ✅ — Core working tools (same as standard Ant)
├── Bash: ✅ — Build, test commands (same as standard Ant)
├── Git: ✅ — Commit, branch (same as standard Ant)
├── npm/build: ✅ — Install, build, test (same as standard Ant)
├── Lint/Format: ✅ — Fix and verify (same as standard Ant)
│
├── SERVER 1: FIGMA OFFICIAL MCP (figma-official)
│   Remote server at https://mcp.figma.com/mcp (HTTP transport, OAuth)
│
│   🏛️ DESIGN CONTEXT & INSPECTION:
│   ├── get_design_context       — Full design context for a Figma node/file
│   ├── get_variable_defs        — Design variables (colors, spacing, typography tokens)
│   ├── get_screenshot           — Screenshot of any Figma node/frame
│   ├── get_metadata             — File metadata (name, last modified, version)
│   ├── whoami                   — Current authenticated Figma user info
│   └── get_figjam              — FigJam board content
│
│   🔗 CODE CONNECT:
│   ├── get_code_connect_map     — Read existing Code Connect mappings
│   ├── add_code_connect_map     — Create new Code Connect mapping
│   ├── get_code_connect_suggestions — AI suggestions for component-to-code links
│   └── send_code_connect_mappings — Push Code Connect mappings to Figma
│
│   📐 DESIGN SYSTEM:
│   └── create_design_system_rules — Create design system rules in Figma
│
├── SERVER 2: FIGMA EDIT MCP (figma-edit)
│   WebSocket bridge via Claude Talk to Figma (port 3055)
│
│   📖 READ (Document & Inspection):
│   ├── join_channel             — Connect to Figma via channel ID
│   ├── get_document_info        — Analyze full document structure
│   ├── get_selection            — Read current user selection
│   ├── get_node_info            — Individual element details (size, style, position)
│   ├── get_nodes_info           — Multiple elements info at once
│   ├── get_styles               — Read document styles (colors, text, effects)
│   ├── get_local_components     — Read project component library
│   ├── get_remote_components    — Read team/shared component library
│   ├── scan_text_nodes          — Find all text nodes in document
│   ├── get_styled_text_segments — Read text styling per segment
│   └── export_node_as_image     — Export frame/component as image
│
│   ✏️ CREATE (Build inside Figma):
│   ├── create_rectangle         — Create rectangle shape
│   ├── create_frame             — Create frame (layout container)
│   ├── create_ellipse           — Create ellipse/circle shape
│   ├── create_polygon           — Create polygon shape
│   ├── create_star              — Create star shape
│   ├── create_text              — Create text node
│   ├── create_component_instance — Instantiate from component library
│   ├── clone_node               — Duplicate existing element
│   ├── group_nodes              — Group elements together
│   ├── ungroup_nodes            — Ungroup elements
│   ├── insert_child             — Nest element inside another
│   └── flatten_node             — Flatten to vector
│
│   🎨 MODIFY (Style & Layout):
│   ├── set_fill_color           — Set element fill color
│   ├── set_stroke_color         — Set element stroke color
│   ├── set_selection_colors     — Recursive recoloring across selection
│   ├── set_corner_radius        — Set border radius
│   ├── set_auto_layout          — Set auto-layout (flex) properties
│   ├── set_effects              — Set shadows, blur, etc.
│   ├── set_effect_style_id      — Apply effect style
│   ├── move_node                — Reposition element
│   ├── resize_node              — Resize element
│   └── delete_node              — Remove element
│
│   📝 TEXT (Typography):
│   ├── set_text_content         — Change text content
│   ├── set_multiple_text_contents — Batch text updates
│   ├── set_text_align           — Set text alignment
│   ├── set_font_name            — Set font family
│   ├── set_font_size            — Set font size
│   ├── set_font_weight          — Set font weight
│   ├── set_letter_spacing       — Set letter spacing
│   ├── set_line_height          — Set line height
│   ├── set_paragraph_spacing    — Set paragraph spacing
│   ├── set_text_case            — Set text case (upper, lower, title)
│   ├── set_text_decoration      — Set underline/strikethrough
│   └── load_font_async          — Load font for use
│
├── CHROME DEVTOOLS MCP: ✅ — Live comparison (same as Color Expert)
│   ├── take_screenshot          — Capture implemented UI for comparison
│   ├── take_snapshot            — A11y tree inspection
│   └── evaluate_script          — Computed style checks
│
└── RESTRICTIONS:
    ├── CREATE/MODIFY in Figma requires operator approval at FOOTPRINT
    ├── No dependency additions without operator approval
    ├── No production deployments
    └── Must show Figma spec vs implementation comparison at VERIFY
```

### Figma MCP Server Setup

The Figma Ant uses **TWO MCP servers** simultaneously:

#### Server 1: Figma Official (Remote — No Local Setup Needed)

Figma's own remote MCP server. Uses OAuth (browser-based login, no API token).

```bash
# Add via CLI:
claude mcp add --transport http figma-official https://mcp.figma.com/mcp

# First use: opens browser for Figma OAuth login
```

**What it provides:** Design context, variables/tokens, Code Connect mappings, screenshots, metadata.
**When to use:** EXTRACTION phase — reading design context, variables, and generating Code Connect links.

#### Server 2: Figma Edit (Local WebSocket — Requires Setup)

Two-way bridge via Claude Talk to Figma plugin. Requires local WebSocket server + Figma plugin.

**Component 1: WebSocket Server (runs locally on port 3055)**
```bash
# Option A: Quick start via npx
npx claude-talk-to-figma-mcp

# Option B: Manual (for Windows)
git clone https://github.com/arinspunk/claude-talk-to-figma-mcp.git
cd claude-talk-to-figma-mcp
bun install
bun run build:win
bun socket
# Verify: http://localhost:3055/status
```

**Component 2: Figma Plugin (inside Figma)**
1. Open Figma → Plugins → Development → Import from manifest
2. Or search "Claude MCP Plugin" in the Figma community
3. Run the plugin — it shows a channel ID
4. Tell Claude: `join_channel("<channel-ID>")`

**What it provides:** Direct element inspection, creation, modification, and text editing inside Figma.
**When to use:** Detailed node inspection, building/modifying elements in Figma, two-way interaction.

#### MCP Config for Claude Code

Add both servers to `~/.claude/mcp.json`:
```json
{
  "mcpServers": {
    "figma-official": {
      "type": "http",
      "url": "https://mcp.figma.com/mcp"
    },
    "figma-edit": {
      "command": "npx",
      "args": ["-p", "claude-talk-to-figma-mcp@latest", "claude-talk-to-figma-mcp-server"]
    }
  }
}
```

#### STOP Conditions (Connection)

**If figma-official OAuth fails:** The Figma Ant STOPS and requests operator to authenticate via browser.
**If the WebSocket server is not running:** The Figma Ant STOPS and requests `bun socket` startup.
**If the Figma plugin is not connected:** The Figma Ant STOPS and requests plugin connection.
**If `join_channel` fails:** The Figma Ant STOPS and requests the channel ID from the operator.

---

## 6) Critical Surface Protections

### 6.1 What Are Critical Surfaces

Critical surfaces are project files that require **extra authorization** before an Ant can modify them. The operator defines critical surfaces per project.

### 6.2 Default Critical Surface Categories

| Category | Pattern Examples | Why Critical |
|----------|-----------------|-------------|
| **Auth / Security** | `**/auth/**`, `**/security/**`, `*.rules` | Access control, permissions |
| **Data Layer** | `**/migrations/**`, `**/schemas/**`, `*.prisma` | Data integrity, schema changes |
| **Deploy / Infra** | `Dockerfile*`, `*.yml` (CI/CD), `deploy.*` | Production safety |
| **Environment** | `.env*`, `**/secrets/**`, `**/config/prod.*` | Credential safety |
| **Tenant Isolation** | `**/middleware/tenant*`, `**/multi-tenant/**` | Cross-tenant safety |

### 6.3 Critical Surface Rules for Each Role

| Role | Rule |
|------|------|
| **Ant** | MUST flag critical surfaces in FOOTPRINT. Cannot edit without `🔑 CRITICAL SURFACE OVERRIDE` |
| **Ghost** | MUST verify that all critical surface edits had OVERRIDE tokens |
| **Inspector** | MUST audit critical surface edits for compliance |
| **Debugger Ant** | Cannot edit ANY file (including critical surfaces) — read-only |

### 6.4 Multi-Tenant Critical Surfaces

In multi-tenant projects, **additional surfaces** are critical:

| Surface | Why |
|---------|-----|
| Tenant middleware (routing, filtering) | Controls which tenant sees what |
| Data access layer (query builders, ORMs) | Must always filter by tenant |
| API boundary (route handlers, controllers) | Entry point for tenant context |
| Shared caches / queues | Could leak data between tenants |
| Authentication providers | Could cross tenant boundaries |

**Any file that handles tenant-specific data is automatically a critical surface.**

### 6.5 Project-Specific Configuration

Operators can define a `.neo/CRITICAL_SURFACES.md` file per project:

```markdown
# CRITICAL SURFACES — <Project Name>

## Files requiring CRITICAL SURFACE OVERRIDE
- src/middleware/auth.ts
- src/config/firebase.rules
- .github/workflows/*.yml
- docker-compose.yml
- src/lib/tenantContext.ts
```

**If this file doesn't exist, the default categories (Section 6.2) apply.**

---

## 7) Quick Reference

```
┌─────────────────────────────────────────────────────────────────────────────┐
│  NEO-TOOLS v1.3.0 — QUICK REFERENCE                                        │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ANT:          ✅ Read/Edit/Write/Bash/Git/npm/test/lint                   │
│  FIGMA ANT:    ✅ Same as Ant + 2 Figma MCPs + Chrome DevTools            │
│  DEBUGGER ANT: ✅ Read  🔒 Bash/tests/lint (run only)  ❌ Edit/Write      │
│  GHOST:        ✅ Read  🔒 Bash/Git/lint (check only)  ❌ Edit/Write      │
│  INSPECTOR:    ✅ Read  🔒 lint (check only)  ❌ Edit/Write/Bash/Git      │
│                                                                             │
│  FIGMA MCP — TWO SERVERS:                                                   │
│  • figma-official: design context, variables, Code Connect, screenshots    │
│    (remote: https://mcp.figma.com/mcp — OAuth, no token needed)            │
│  • figma-edit: two-way WebSocket bridge (Claude Talk to Figma)             │
│    READ:   get_document_info, get_node_info, get_styles, get_components   │
│    CREATE: create_frame, create_rectangle, create_text, clone_node        │
│    MODIFY: set_fill_color, set_auto_layout, move_node, resize_node        │
│    TEXT:   set_font_name, set_font_size, set_text_content                 │
│    (requires: WebSocket server port 3055 + Figma plugin connected)        │
│                                                                             │
│  CRITICAL SURFACES:                                                         │
│  • Auth/security, data layer, deploy/infra, env, tenant isolation           │
│  • Ant MUST flag in FOOTPRINT → needs 🔑 CRITICAL SURFACE OVERRIDE        │
│  • Ghost verifies overrides. Inspector audits.                              │
│  • Debugger Ant: read-only — cannot edit ANY file                           │
│                                                                             │
│  RULES:                                                                     │
│  • Ghost and Inspector NEVER modify files                                   │
│  • Debugger Ant NEVER modifies files                                        │
│  • No role deploys to production                                            │
│  • Violations → 🔑 REJECTED                                                │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Changelog

### [1.3.0] 2026-02-12
- Section 5 UPDATED: DUAL-SERVER Figma setup (matching IAMBecca architecture)
- Server 1: figma-official — Figma's remote MCP server (https://mcp.figma.com/mcp)
  - HTTP transport with OAuth (browser login, no API token)
  - 11 tools: get_design_context, get_variable_defs, get_code_connect_map,
    add_code_connect_map, get_screenshot, create_design_system_rules,
    get_metadata, get_figjam, whoami, get_code_connect_suggestions,
    send_code_connect_mappings
- Server 2: figma-edit — Claude Talk to Figma WebSocket bridge (unchanged from 1.2.1)
- MCP config updated: both servers in `~/.claude/mcp.json`
- Setup sections split: Server 1 (remote, no setup) + Server 2 (WebSocket + plugin)
- Quick Reference updated with dual-server layout
- ALL additions are MANUAL ONLY — no automation

### [1.2.1] 2026-02-12
- Section 5 UPDATED: Figma MCP tools corrected — TWO-WAY bridge (not read-only)
- Uses Claude Talk to Figma plugin (WebSocket bridge on port 3055)
- 4 tool categories: READ (11 tools), CREATE (12 tools), MODIFY (10 tools), TEXT (12 tools)
- Full tool list: join_channel, get_document_info, get_node_info, get_styles, get_components,
  create_frame, create_rectangle, create_text, set_fill_color, set_auto_layout, etc.
- Setup: WebSocket server + Figma plugin + channel ID (no API token needed)
- MCP config: `claude mcp add -s user ClaudeTalkToFigma` or `.mcp.json`
- STOP conditions: server not running, plugin not connected, channel join failed
- Quick Reference updated with two-way tool categories
- ALL additions are MANUAL ONLY — no automation

### [1.2.0] 2026-02-12
- Section 5: Figma Ant Tool Permissions — initial version (read-only, corrected in 1.2.1)
- Chrome DevTools MCP access for live UI comparison (screenshot, snapshot, evaluate)
- Critical Surface sections renumbered 5→6
- Quick Reference section renumbered 6→7
- ALL additions are MANUAL ONLY — no automation

### [1.1.0] 2026-02-09
- Section 4: Debugger Ant tool permissions (read-only, same as Ghost)
- Section 5: Critical Surface Protections — auth, data, deploy, env, tenant isolation
- Section 5.4: Multi-Tenant Critical Surfaces — tenant middleware, data access, API boundary
- Section 5.5: Project-Specific Configuration — `.neo/CRITICAL_SURFACES.md`
- Updated Quick Reference with Debugger Ant and critical surfaces
- ALL additions are MANUAL ONLY — no automation

### [1.0.0] 2026-02-09
- Initial release
- Adapted from IAMBecca IAMBECCA-TOOLS.md v2.1.0
- Simplified 3-role permission matrix
- ✅ Full / 🔒 Read-Only / ❌ Forbidden system
- Per-role tool authority blocks
- Violation detection and response
