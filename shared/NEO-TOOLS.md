# NEO-TOOLS v1.11.0
## Tool Permissions — Role-Based Access Control

**Purpose:** Which tools each NEO role can use, critical surface protections, error recovery
**Scope:** Loaded by ALL NEO roles (BECCA, Ant, Ghost, Inspector)

---

## 1) Tool Permission Matrix

| Tool | BECCA | Ant | Ghost | Inspector |
|------|-------|-----|-------|-----------|
| **Read** (files) | ✅ Full | ✅ Full | ✅ Full | ✅ Full |
| **Edit** (files) | 🔒 `.neo/` only | ✅ Full | ❌ Forbidden | ❌ Forbidden |
| **Write** (new files) | 🔒 `.neo/` only | ✅ Full | ❌ Forbidden | ❌ Forbidden |
| **Glob** (find files) | ✅ Full | ✅ Full | ✅ Full | ✅ Full |
| **Grep** (search) | ✅ Full | ✅ Full | ✅ Full | ✅ Full |
| **Bash** (commands) | 🔒 Read-Only | ✅ Full | 🔒 Read-Only | 🔒 Read-Only |
| **Git** (version control) | 🔒 Read + branch | ✅ Full | 🔒 Read-Only | 🔒 Read-Only |
| **npm/build** | ❌ Forbidden | ✅ Full | 🔒 Run checks only | ❌ Forbidden |
| **Tests** | ❌ Forbidden | ✅ Full | 🔒 Run only (no write) | ❌ Forbidden |
| **Lint/Format** | ❌ Forbidden | ✅ Full | 🔒 Check only | 🔒 Check only |
| **Type check** | ❌ Forbidden | ✅ Full | 🔒 Check only | 🔒 Check only |

### Permission Legend

| Symbol | Meaning |
|--------|---------|
| ✅ Full | Can read and write/execute |
| 🔒 Read-Only | Can run checks/reads but NOT modify |
| ❌ Forbidden | Cannot use at all |

---

## 2) Role-Specific Tool Rules

### BECCA (Orchestrator)
```
BECCA TOOL AUTHORITY:
├── Read/Glob/Grep: ✅ — Read any file (RECON, health checks, state reads)
├── Edit/Write: 🔒 — ONLY .neo/ files (TODO, STATE, indexes, outbox)
│   ├── ✅ .neo/TODO_*.md
│   ├── ✅ .neo/STATE.md
│   ├── ✅ .neo/RUN_INDEX.md
│   ├── ✅ .neo/index/*
│   ├── ✅ .neo/outbox/*
│   └── ❌ ALL SOURCE CODE — Forbidden. No exceptions.
├── Bash: 🔒 — Read-only (git status, git log, ls)
├── Git: 🔒 — Read + branch creation (run/<NNN>)
│
├── BECCA ORGANIZES. BECCA DOES NOT EXECUTE.
│   If you are BECCA and about to Edit a source file → STOP.
│   You are violating your role boundary.
│   Dispatch an Ant to do the work.
│
└── FORBIDDEN:
    ├── ❌ Edit/Write source code — EVER
    ├── ❌ Bash builds, installs, deploys — Ants do this
    ├── ❌ Git commit/push — Ants do this
    ├── ❌ npm install/build — Ants do this
    └── ❌ Test runs — Ants do this
```

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
| BECCA edits source code | `🔑 REJECTED: BECCA cannot modify source files — dispatch an Ant` |
| BECCA runs build/test/deploy | `🔑 REJECTED: BECCA cannot execute — dispatch an Ant` |
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

The 🐛 Debugger Ant has a **restricted** tool set for file operations but a **complete diagnostic lab** with runtime inspection tools.

```
DEBUGGER ANT TOOL AUTHORITY:
├── Read/Glob/Grep: ✅ — Investigate code
├── Bash: 🔒 — Run tests, read logs (NO modifications)
├── Tests: 🔒 — Run existing tests (NO writing new tests)
├── Lint/Format/Type check: 🔒 — Run checks only
│
├── CHROME DEVTOOLS MCP: ✅ — Live runtime inspection
│   ├── take_snapshot            — A11y tree / DOM structure snapshot
│   ├── take_screenshot          — Visual state capture (evidence)
│   ├── list_console_messages    — Runtime errors, warnings, logs
│   ├── get_console_message      — Detailed console message by ID
│   ├── list_network_requests    — All HTTP requests (failed API calls, 4xx/5xx)
│   ├── get_network_request      — Request/response details (headers, body, status)
│   ├── evaluate_script          — Inspect runtime state (variables, DOM, call stack)
│   ├── navigate_page            — Navigate to the broken page/route
│   ├── click                    — Interact to reproduce the bug
│   ├── fill                     — Fill inputs to reproduce form bugs
│   ├── press_key                — Keyboard interaction for reproduction
│   ├── hover                    — Hover to trigger popover/tooltip bugs
│   ├── wait_for                 — Wait for async operations to complete
│   ├── list_pages               — Check open tabs/pages
│   ├── select_page              — Switch to specific page context
│   ├── emulate                  — Test viewport, network throttling, geolocation
│   └── performance_start_trace  — Performance profiling (CWV, slow renders)
│
├── PLAYWRIGHT MCP: ✅ — Bug reproduction in isolated browser
│   ├── browser_navigate        — Go to the broken URL
│   ├── browser_click           — Click through reproduction steps
│   ├── browser_type            — Type into inputs for reproduction
│   ├── browser_select_option   — Choose dropdowns
│   ├── browser_press_key       — Keyboard input
│   ├── browser_hover           — Hover for tooltip/popover bugs
│   ├── browser_snapshot        — Accessibility tree (structured DOM)
│   ├── browser_screenshot      — Visual evidence capture
│   ├── browser_console_messages — Console errors/warnings
│   ├── browser_network_requests — Network request/response capture
│   ├── browser_tab_list        — List open tabs
│   ├── browser_tab_new         — Open new tab for comparison
│   ├── browser_tab_select      — Switch tabs
│   ├── browser_go_back         — Navigate back
│   ├── browser_go_forward      — Navigate forward
│   └── browser_wait            — Wait for navigation/element
│
├── SENTRY MCP: ✅ — Production error investigation (READ ONLY)
│   ├── Search issues by error message
│   ├── Get error events + stack traces
│   ├── Get breadcrumbs (what happened before the crash)
│   ├── Check release health (did a deploy cause this?)
│   ├── Performance: transaction summaries, span details
│   └── Seer: AI-powered root cause analysis
│
├── FIREBASE MCP: ✅ — Backend data inspection (READ ONLY)
│   ├── Firestore: query collections, read documents (check data state)
│   ├── Auth: look up users by UID/email (verify permissions/claims)
│   ├── Cloud Functions: view logs (backend error investigation)
│   ├── Storage: list files, get metadata
│   └── Hosting: view deployment history
│
├── CONTEXT7 MCP: ✅ — Library documentation lookup
│   ├── resolve-library-id — Find library ID
│   └── get-library-docs — Fetch current docs (verify API correctness)
│
├── CI/CD TOOLS: ✅ — Pipeline investigation (READ ONLY)
│   ├── gh run list              — Check recent CI runs
│   ├── gh run view <ID>         — View run details
│   ├── gh run view --log-failed — Read failure logs
│   ├── vercel ls --yes          — Check deployment status
│   └── vercel logs <url>        — Read deployment logs
│
├── Debugger DIAGNOSES. Debugger does NOT FIX.
│   Produce TEST_REPORT, hand off to appropriate Ant type.
│
└── FORBIDDEN:
    ├── ❌ Edit/Write — Cannot modify any files
    ├── ❌ Git commit/push — Cannot change version control
    ├── ❌ npm install/build — Cannot modify dependencies
    ├── ❌ Firebase MCP (write) — Read only, no data modifications
    └── ❌ Chrome DevTools (modify) — Inspect only, no DOM mutation via scripts
```

**The Debugger Ant has read-only file permissions (same as Ghost) but a full diagnostic lab:** Chrome DevTools for live runtime inspection, Playwright for bug reproduction, Sentry for production errors, Firebase for backend data, and CI/CD tools for pipeline investigation.

### 4a) Debugger Diagnostic Protocol

The Debugger Ant follows a structured 5-phase diagnostic workflow:

```
DEBUGGER DIAGNOSTIC PROTOCOL:
│
├── PHASE 1: REPRODUCE (Chrome DevTools or Playwright)
│   Goal: Confirm you can trigger the bug reliably
│   ├── Navigate to the affected page/route
│   ├── Follow the operator's reproduction steps
│   ├── Capture: screenshot + console messages + network state
│   └── If cannot reproduce: document what was tried → HALT
│
├── PHASE 2: OBSERVE (Chrome DevTools + Sentry)
│   Goal: Capture runtime evidence of the failure
│   ├── Console errors/warnings at moment of failure
│   ├── Network requests: failed calls, unexpected responses, timeouts
│   ├── DOM state: missing elements, wrong attributes, stale renders
│   ├── Sentry: production error events, stack traces, breadcrumbs
│   └── Performance: if slow, run performance trace for CWV scores
│
├── PHASE 3: INVESTIGATE (Code + Data)
│   Goal: Trace the bug from symptom to root cause
│   ├── Read the code paths involved (Read/Glob/Grep)
│   ├── Run existing tests to check what passes/fails
│   ├── Query Firebase: check data state that caused the bug
│   ├── Check auth user state if permissions-related
│   ├── Check Cloud Functions logs for backend errors
│   └── Check Context7 if API usage might be outdated/wrong
│
├── PHASE 4: DIAGNOSE
│   Goal: Identify root cause with evidence chain
│   ├── Form hypothesis from Phase 1-3 evidence
│   ├── Run targeted tests to confirm/deny hypothesis
│   ├── Assign confidence level (HIGH/MEDIUM/LOW)
│   └── If LOW confidence: document what else needs investigation
│
└── PHASE 5: REPORT (TEST_REPORT)
    Goal: Hand off a complete, actionable diagnosis
    ├── Environment Snapshot (versions, browser, OS)
    ├── Reproduction Steps (exact steps to trigger)
    ├── Hypothesis + evidence chain
    ├── Test results (all tests run with outcomes)
    ├── Root cause diagnosis + confidence level
    ├── Recommended Ant type + approach for the fix
    └── All evidence indexed (screenshots, logs, traces)
```

### 4b) STOP Conditions (Debugger)

```
DEBUGGER STOP CONDITIONS:
├── Chrome DevTools MCP unavailable → NOTE in report, use Playwright instead
├── Playwright MCP unavailable → NOTE in report, use DevTools instead
├── Both browser MCPs unavailable → NOTE in report, diagnose from code + logs only
├── Sentry MCP unavailable → NOTE in report, skip production error lookup
├── Firebase MCP unavailable → NOTE in report, skip data state inspection
├── App not running (localhost) → STOP, request operator to start dev server
├── Auth required in browser → STOP, request operator to authenticate manually
├── Cannot reproduce the bug → HALT, document all attempts in TEST_REPORT
└── Evidence budget exhausted → STOP, request 🔑 DISCOVERY EXPANSION APPROVED
```

**Graceful degradation:** If MCP servers are unavailable, the Debugger continues with whatever tools ARE available. Only STOP on: app not running, auth needed, or evidence budget exhausted.

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

## 6) QA Ant Tool Permissions

The 🔍 QA Ant has **Debugger-level permissions** (read-only) plus access to **Playwright MCP** for browser automation:

```
QA ANT TOOL AUTHORITY:
├── Read/Glob/Grep: ✅ — Inspect all files (read builder Ant reports)
├── Bash: 🔒 — Run dev server check, read logs (NO modifications)
├── Tests: 🔒 — Run existing tests (NO writing new tests)
├── Lint/Format/Type check: 🔒 — Run checks only
│
├── PLAYWRIGHT MCP: ✅ — Full browser automation
│   ├── browser_navigate        — Go to URL
│   ├── browser_click           — Click elements (by text, role, selector)
│   ├── browser_type            — Type into input fields
│   ├── browser_select_option   — Choose dropdowns
│   ├── browser_press_key       — Keyboard input (Enter, Escape, Tab)
│   ├── browser_hover           — Hover over elements
│   ├── browser_snapshot        — Accessibility tree (structured DOM)
│   ├── browser_screenshot      — Visual screenshot capture
│   ├── browser_console_messages — Console errors/warnings
│   ├── browser_network_requests — Network request/response capture
│   ├── browser_tab_list        — List open tabs
│   ├── browser_tab_new         — Open new tab
│   ├── browser_tab_select      — Switch tabs
│   ├── browser_go_back         — Navigate back
│   ├── browser_go_forward      — Navigate forward
│   └── browser_wait            — Wait for navigation/element
│
├── QA Ant VERIFIES. QA Ant does NOT FIX.
│   Produce QA_REPORT, hand off to BECCA or builder Ant.
│
└── FORBIDDEN:
    ├── ❌ Edit/Write — Cannot modify any files
    ├── ❌ Git commit/push — Cannot change version control
    └── ❌ npm install/build — Cannot modify dependencies
```

**The QA Ant has the same file permissions as Debugger Ant** — read-only plus Playwright MCP for browser interaction. Both QA and Debugger Ants have Playwright; the difference is QA **verifies** (tests against acceptance criteria) while Debugger **reproduces** (triggers the bug to observe it).

### Playwright MCP Server Setup

Microsoft's official Playwright MCP server. Uses accessibility tree (structured, no vision model needed).

```bash
# Already configured in ~/.claude/mcp.json:
# "playwright": { "command": "npx", "args": ["-y", "@playwright/mcp@latest"] }

# First use: Playwright auto-installs Chromium
# Opens a VISIBLE browser window you can see
```

### STOP Conditions (Connection)

**If Playwright MCP not available:** QA Ant STOPS and requests `npx -y @playwright/mcp@latest` setup.
**If app not running (localhost):** QA Ant STOPS and requests operator to start dev server.
**If auth required:** QA Ant navigates to login, STOPS, requests operator to authenticate manually.

---

## 6b) Playwright MCP for All Ants (VERIFY Step)

**Any builder Ant** can use Playwright MCP during the VERIFY step for complex features that require browser verification. This is OPTIONAL — only use when:

- The feature involves UI interactions (forms, buttons, navigation)
- The feature involves API calls visible in the network tab
- The operator requests browser verification
- The Ant wants to self-verify before producing the report

```
BUILDER ANT — PLAYWRIGHT AT VERIFY (OPTIONAL):
├── browser_navigate — open the app at the feature URL
├── browser_click — click through the feature
├── browser_snapshot — verify expected elements exist
├── browser_screenshot — capture evidence for the report
├── browser_console_messages — check for errors
├── browser_network_requests — verify API calls succeed
│
└── RULES:
    ├── Only during VERIFY step (not during DISCOVERY or PATCH)
    ├── Evidence goes in Section 5 (VERIFICATION) of ANT_REPORT
    ├── Not required — but recommended for UI/API features
    └── If Playwright unavailable: skip, note in report
```

---

## 6b) DevTools Ant Tool Permissions (3 types)

The DevTools Ant program includes 3 specialized types — all **read-only**, all using **Chrome DevTools MCP**.

### Common Permissions (all 3 types)

```
FILE ACCESS:
├── ✅ Read any file (within PROJECT LOCK)
├── ❌ Edit/create/delete files — NEVER
└── ❌ Run code modifications — NEVER

CHROME DEVTOOLS MCP (chrome-devtools):
├── ✅ list_pages — check connection, see open pages
├── ✅ select_page — switch tab context
├── ✅ navigate_page — go to target route
├── ✅ new_page — open new tab
├── ✅ take_snapshot — a11y tree / DOM structure
├── ✅ take_screenshot — visual evidence capture
├── ✅ list_console_messages — runtime errors, warnings
├── ✅ get_console_message — full message details
├── ✅ list_network_requests — HTTP activity
├── ✅ get_network_request — request/response bodies
├── ✅ evaluate_script — READ-ONLY JS only (no mutations)
├── ✅ click, fill, press_key, hover — navigate app UI
├── ✅ wait_for — async content loading
├── ✅ emulate — viewport, network throttle, dark mode
├── ✅ performance_start_trace — CWV capture
├── ✅ performance_stop_trace — end trace
├── ✅ performance_analyze_insight — trace analysis
├── ❌ DOM mutation via evaluate_script — FORBIDDEN
└── ❌ Any write operation — FORBIDDEN
```

### Type-Specific Permissions

| Tool | 🛡️ Sentinel | ⚡ Perf | 🌐 Network |
|------|------------|--------|-----------|
| take_snapshot | ✅ every page | ✅ target pages | ✅ flow pages |
| take_screenshot | ✅ every page | ✅ baseline + throttled | ✅ flow evidence |
| list_console_messages | ✅ PRIMARY | ✅ if errors found | — |
| list_network_requests | ✅ PRIMARY | — | ✅ PRIMARY |
| get_network_request | ✅ failures only | — | ✅ ALL API calls |
| evaluate_script | ✅ basic checks | ✅ `performance.getEntries()` | ✅ state inspection |
| emulate | ✅ dark mode check | ✅ throttle (Slow 4G + 4x CPU) | — |
| performance_start_trace | — | ✅ PRIMARY | — |
| performance_analyze_insight | — | ✅ PRIMARY | — |

### Output

- 🛡️ Sentinel: produces DEVTOOLS_REPORT (full sentinel section)
- ⚡ Perf: produces PERF section of DEVTOOLS_REPORT
- 🌐 Network: produces NETWORK section of DEVTOOLS_REPORT

See `templates/DEVTOOLS_REPORT.md` for format.

### FORBIDDEN (all 3 types)

```
❌ Edit any file (code, config, or framework)
❌ DOM mutation via evaluate_script
❌ Process real payments (test/demo mode only)
❌ Send API requests (observe only, not generate)
❌ Modify application state
❌ Firebase write operations
```

---

## 7) CI/CD Verification Tools (MANDATORY at VERIFY)

Every Ant MUST check external CI/CD status after pushing code. **"Tests pass locally" is not enough.** The Ant must verify that the actual deployment pipeline succeeded.

### Why This Exists

Ants were reporting "everything went well" while Vercel deployments and GitHub Actions were failing. The operator had to manually check external platforms and relay failure information. This is the Ant's job.

### Available CLI Tools

```
GITHUB ACTIONS (via gh CLI — authenticated):
├── gh run list                    — List recent workflow runs (pass/fail status)
├── gh run view <ID>               — View specific run details
├── gh run view <ID> --log-failed  — Get actual failure logs
├── gh run watch <ID>              — Watch a running workflow
├── gh pr checks                   — Check status on a pull request
│
│   Examples:
│   gh run list --limit 5
│   → Shows: status, conclusion, title, branch, run ID
│
│   gh run view 22030330745 --log-failed
│   → Shows: exact error messages from the failed step
│
VERCEL (via vercel CLI — authenticated):
├── vercel ls --yes                — List recent deployments
├── vercel inspect <url>           — Deployment details
├── vercel logs <url>              — Deployment build logs
│
│   Example:
│   vercel ls --yes
│   → Shows: deployment URL, status, branch, timestamp
```

### CI/CD Check Protocol (MANDATORY)

After ANY code push or commit, the Ant MUST:

```
1. WAIT 30-60 seconds for CI to start
   → gh run list --limit 3 (check if new run appeared)

2. CHECK GitHub Actions status
   → gh run list --limit 5
   → Look for your commit message in the list
   → If status = "completed" + conclusion = "failure" → READ THE LOGS:
     gh run view <run-ID> --log-failed

3. CHECK Vercel deployment (if project uses Vercel)
   → vercel ls --yes
   → Look for your deployment
   → If status = "Error" → READ THE LOGS:
     vercel logs <deployment-url>

4. REPORT in Section 5 (VERIFICATION) of ANT_REPORT:
   | Platform | Status | Run/Deploy ID | Evidence |
   |----------|--------|---------------|----------|
   | GitHub Actions (CI) | PASS/FAIL | <run-ID> | <summary> |
   | GitHub Actions (Gitleaks) | PASS/FAIL | <run-ID> | <summary> |
   | Vercel | PASS/FAIL | <deploy-URL> | <summary> |

5. If ANY CI/CD check FAILS:
   → DO NOT report "everything went well"
   → READ the failure logs (gh run view --log-failed)
   → FIX the issue and push again
   → Re-check until all green
   → Report the failure AND the fix in your ANT_REPORT
```

### Permission Matrix for CI/CD Tools

| Tool | Ant | Ghost | Inspector | QA Ant |
|------|-----|-------|-----------|--------|
| `gh run list` | ✅ | ✅ (read) | ✅ (read) | ✅ (read) |
| `gh run view` | ✅ | ✅ (read) | ✅ (read) | ✅ (read) |
| `gh run view --log-failed` | ✅ | ✅ (read) | ✅ (read) | ✅ (read) |
| `vercel ls` | ✅ | ✅ (read) | ✅ (read) | ✅ (read) |
| `vercel logs` | ✅ | ✅ (read) | ✅ (read) | ✅ (read) |

**All roles can READ CI/CD status.** Only Ants can push code that triggers new runs.

---

## 8) MCP Data & Documentation Servers

Three MCP servers provide Ants (and other roles in read-only mode) with direct access to **production data**, **error monitoring**, and **up-to-date library documentation** — without leaving the IDE.

### Why These Exist

- **Firebase MCP** — Ants can query Firestore, check auth users, and inspect Cloud Functions directly instead of guessing at data state or asking the operator to check.
- **Sentry MCP** — Ants can look up production errors, stack traces, and performance data before/after changes. Ghost can cross-check whether a deploy introduced new errors.
- **Context7** — Ants get current library documentation (React, Next.js, Firebase, etc.) instead of relying on potentially outdated training data. Prevents hallucinated API calls.

### Server 1: Firebase MCP (Official — via firebase-tools)

Firebase's official MCP server. Uses existing Firebase CLI authentication (operator already logged in).

```
FIREBASE MCP CAPABILITIES:
├── Firestore: query collections, read documents, list subcollections
├── Auth: look up users by UID/email, list users
├── Cloud Functions: list functions, view logs, check deployment status
├── Storage: list files, get metadata
├── Hosting: list sites, view deployment history
├── Extensions: list installed extensions
│
├── CONFIG:
│   command: npx
│   args: ["-y", "firebase-tools@latest", "mcp"]
│   Auth: Uses existing Firebase CLI login (no extra token needed)
│
└── STOP CONDITIONS:
    ├── Not logged in to Firebase CLI → STOP, request `firebase login`
    └── No project selected → STOP, request `firebase use <project>`
```

### Server 2: Sentry MCP (Remote — OAuth)

Sentry's hosted MCP server. Uses OAuth authentication (browser login on first use).

```
SENTRY MCP CAPABILITIES:
├── Issues: list issues, get issue details, search by error message
├── Events: get error events, stack traces, breadcrumbs
├── Projects: list projects, get project details
├── Releases: list releases, get release health
├── Performance: transaction summaries, span details
├── Seer: AI-powered root cause analysis, fix suggestions
│
├── CONFIG:
│   type: http
│   url: https://mcp.sentry.dev/mcp
│   Auth: OAuth (browser login on first use, then cached)
│
├── ACTIVE PROJECTS (org: becca-os):
│   ├── sonny-functions — Sonny Cloud Functions (Firebase/Node.js)
│   └── rizend — Rizend frontend (Next.js)
│
└── STOP CONDITIONS:
    ├── Not authenticated → STOP, run `/mcp` to authenticate
    └── SENTRY_DSN not set in project → errors won't appear (see OPS_HARDENING.md)
```

### Server 3: Context7 (Library Documentation)

Up-to-date documentation for any library/framework. Prevents outdated API usage.

```
CONTEXT7 CAPABILITIES:
├── resolve-library-id — Find the Context7 ID for a library (e.g., "react", "firebase")
├── get-library-docs — Fetch current documentation for a specific library/topic
│
├── CONFIG:
│   command: npx
│   args: ["-y", "@upstash/context7-mcp@latest"]
│   Auth: May require API key from context7.com/dashboard
│         Add --api-key YOUR_KEY to args if required
│
├── USAGE:
│   Include "use context7" in your prompt when you need current docs
│   Example: "How does useFormStatus work in React 19? use context7"
│
└── STOP CONDITIONS:
    └── API key required but not set → STOP, request key from operator
```

### Permission Matrix for MCP Data Servers

| Tool | Ant | Ghost | Inspector | QA Ant | Debugger Ant |
|------|-----|-------|-----------|--------|-------------|
| Firebase MCP (read) | ✅ | ✅ (read) | ✅ (read) | ✅ (read) | ✅ (read) |
| Firebase MCP (write) | ✅ (with approval) | ❌ | ❌ | ❌ | ❌ |
| Sentry MCP (all) | ✅ (read) | ✅ (read) | ✅ (read) | ✅ (read) | ✅ (read) |
| Context7 (docs) | ✅ | ✅ | ✅ | ✅ | ✅ |

**All roles can READ from all three servers.** Only Ants can write via Firebase MCP (and only with operator approval at FOOTPRINT).

### When to Use Each Server

| Situation | Server | Example |
|-----------|--------|---------|
| Need to check Firestore data state | Firebase MCP | "What documents are in `menuPublished` for tenant X?" |
| Need to verify auth user exists | Firebase MCP | "Does UID abc123 have the `admin` custom claim?" |
| Investigating a production error | Sentry MCP | "What errors occurred in `createOrder` this week?" |
| Checking if a deploy caused new errors | Sentry MCP | "Any new issues since release abc123?" |
| Need current API docs for a library | Context7 | "What's the correct Next.js 16 middleware API?" |
| Unsure if an API exists or changed | Context7 | "Does Firebase Admin SDK have `getAuth().getUser()`?" |

---

## 9) Critical Surface Protections

### 9.1 What Are Critical Surfaces

Critical surfaces are project files that require **extra authorization** before an Ant can modify them. The operator defines critical surfaces per project.

### 9.2 Default Critical Surface Categories

| Category | Pattern Examples | Why Critical |
|----------|-----------------|-------------|
| **Auth / Security** | `**/auth/**`, `**/security/**`, `*.rules` | Access control, permissions |
| **Data Layer** | `**/migrations/**`, `**/schemas/**`, `*.prisma` | Data integrity, schema changes |
| **Deploy / Infra** | `Dockerfile*`, `*.yml` (CI/CD), `deploy.*` | Production safety |
| **Environment** | `.env*`, `**/secrets/**`, `**/config/prod.*` | Credential safety |
| **Tenant Isolation** | `**/middleware/tenant*`, `**/multi-tenant/**` | Cross-tenant safety |

### 9.3 Critical Surface Rules for Each Role

| Role | Rule |
|------|------|
| **Ant** | MUST flag critical surfaces in FOOTPRINT. Cannot edit without `🔑 CRITICAL SURFACE OVERRIDE` |
| **Ghost** | MUST verify that all critical surface edits had OVERRIDE tokens |
| **Inspector** | MUST audit critical surface edits for compliance |
| **Debugger Ant** | Cannot edit ANY file (including critical surfaces) — read-only |

### 9.4 Multi-Tenant Critical Surfaces

In multi-tenant projects, **additional surfaces** are critical:

| Surface | Why |
|---------|-----|
| Tenant middleware (routing, filtering) | Controls which tenant sees what |
| Data access layer (query builders, ORMs) | Must always filter by tenant |
| API boundary (route handlers, controllers) | Entry point for tenant context |
| Shared caches / queues | Could leak data between tenants |
| Authentication providers | Could cross tenant boundaries |

**Any file that handles tenant-specific data is automatically a critical surface.**

### 9.5 Project-Specific Configuration

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

**If this file doesn't exist, the default categories (Section 8.2) apply.**

---

## 9b) Protected Feature Surfaces

### 9b.1 What Are Protected Feature Surfaces

**Protected Feature Surfaces** extend Critical Surfaces to cover **groups of files** that together implement a user-facing feature. While Critical Surfaces protect individual sensitive files (auth, deploy, env), Protected Feature Surfaces protect **entire capabilities** (voice system, order flow, payment flow).

### 9b.2 How They Differ from Critical Surfaces

| Aspect | Critical Surface | Protected Feature Surface |
|--------|-----------------|--------------------------|
| **Scope** | Single file | Group of 3+ related files |
| **Protects** | Sensitive areas (auth, deploy) | User-facing capabilities |
| **Override token** | `🔑 CRITICAL SURFACE OVERRIDE: <file>` | `🔑 FEATURE REMOVAL OVERRIDE: <feature>` |
| **Trigger** | Any edit to the file | Deletion or disabling of files in the group |
| **Definition** | `.neo/CRITICAL_SURFACES.md` | `.neo/PROTECTED_FEATURES.md` |
| **Auto-detection** | By file category | Any 3+ related files = automatic |

### 9b.3 Role Responsibilities for Protected Features

| Role | Responsibility |
|------|---------------|
| **Ant** | Include FEATURE IMPACT table in FOOTPRINT. Include FEATURE INVENTORY in VERIFY. Flag any feature removal. Request `🔑 FEATURE REMOVAL OVERRIDE` if deleting |
| **Ghost** | Verify Feature Impact is complete. Cross-check Feature Inventory counts independently. Independently verify non-existence claims. Detect scope contraction |
| **Inspector** | Audit that overrides were obtained for all feature removals. Verify V-11 compliance |
| **Operator** | Define protected features in `.neo/PROTECTED_FEATURES.md`. Issue `🔑 FEATURE REMOVAL OVERRIDE` only after reviewing file count, LOC, and rollback plan |

### 9b.4 Enforcement

| Violation | Response |
|-----------|----------|
| Ant deletes protected feature files without override | `🔑 REJECTED: V-11 — Feature removal without FEATURE REMOVAL OVERRIDE` |
| Ant omits Feature Impact from FOOTPRINT | `🔑 REJECTED: Feature Impact table is mandatory in FOOTPRINT` |
| Ant omits Feature Inventory from VERIFY | `🔑 REJECTED: Feature Inventory table is mandatory in VERIFY` |
| Ghost approves without checking feature counts | Inspector flags as compliance failure |

**Cross-reference:** Protected Features defined in `NEO-SURGICAL.md` v1.2.0 Section 6b. Feature Impact Analysis defined in `NEO-GATES.md` v1.6.0 Section 12b.

---

## 10) Error Recovery Cheat Sheet

When things go wrong during a task, the Ant should reference this cheat sheet BEFORE improvising a fix.

### Common Failures and Recovery Steps

| # | Failure | Symptom | Recovery |
|---|---------|---------|----------|
| E-01 | **Build fails after PATCH** | `npm run build` exits non-zero | Read error output → fix the specific error → rebuild → if 2nd fix doesn't work: rollback to checkpoint |
| E-02 | **Tests fail after PATCH** | Jest/Vitest shows failures | Read which test failed → check if YOUR change caused it (compare with pre-patch test run) → fix or rollback |
| E-03 | **CI/CD fails (GitHub Actions)** | `gh run list` shows failure | `gh run view <ID> --log-failed` → read actual error → fix → push → recheck |
| E-04 | **CI/CD fails (Vercel)** | `vercel ls` shows Error | `vercel logs <url>` → read build error → fix → push → recheck |
| E-05 | **Lint/type errors** | `tsc` or `eslint` errors | Fix type/lint errors → don't suppress with `@ts-ignore` or `eslint-disable` unless justified in FOOTPRINT |
| E-06 | **Wrong file edited** | File not in FOOTPRINT was changed | `git checkout -- <file>` to restore → only edit FOOTPRINT files |
| E-07 | **Git conflict** | Merge conflict markers in files | Read the conflict → resolve manually (don't just pick "ours") → test after resolution |
| E-08 | **MCP server unavailable** | Tool call fails/times out | Note "MCP unavailable" in report → skip MCP-dependent checks → do NOT fabricate MCP results |
| E-09 | **Evidence budget exhausted** | Hit 5 files / 200 lines / 10 greps | STOP → request `🔑 DISCOVERY EXPANSION APPROVED` → do NOT silently read more |
| E-10 | **STOP condition triggered** | Any S-01 → S-36 fired | STOP immediately → present STOP reason → wait for operator token → do NOT "acknowledge and continue" |
| E-11 | **Data looks wrong** | Collection/document seems empty or malformed | DO NOT "fix" it → investigate intent (LAW 1) → report finding → ask operator |
| E-12 | **Previous Ant's work conflicts** | Your changes would overwrite prior task work | Check PRESERVES list → adjust your approach to preserve prior work → if impossible: escalate to operator |

### Recovery Priority Order

```
1. UNDERSTAND what went wrong (read the error, don't guess)
2. CHECK if your change caused it (diff against pre-patch state)
3. FIX the specific issue (don't rewrite surrounding code)
4. If fix doesn't work after 2 attempts: ROLLBACK to checkpoint
5. If rollback isn't clean: escalate to operator
```

### What NOT to Do During Recovery

| Don't | Why |
|-------|-----|
| Don't add `@ts-ignore` / `eslint-disable` | Hides the problem, Ghost will catch it |
| Don't delete failing tests | Tests exist for a reason — fix the code, not the test |
| Don't `--force` or `--no-verify` | Bypasses safety checks, violates NEO protocol |
| Don't expand scope to "fix everything" | Scope creep — log as separate task |
| Don't fabricate passing output | Fabricated evidence = AUTO REJECT + trust violation |

---

## 11) Quick Reference

```
┌─────────────────────────────────────────────────────────────────────────────┐
│  NEO-TOOLS v1.11.0 — QUICK REFERENCE                                       │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  BECCA:        ✅ Read  🔒 Edit/Write (.neo/ only)  ❌ Source code EVER     │
│                🔒 Bash (read only)  ❌ Build/test/deploy/commit/push        │
│                BECCA dispatches Ants. BECCA does NOT execute.               │
│  ANT:          ✅ Read/Edit/Write/Bash/Git/npm/test/lint                   │
│                🔧 Playwright MCP at VERIFY (optional, for UI features)    │
│  FIGMA ANT:    ✅ Same as Ant + 2 Figma MCPs + Chrome DevTools            │
│  QA ANT:       ✅ Read  🔒 Bash (read only)  + Playwright MCP (full)     │
│                ❌ Edit/Write — read-only, QA_REPORT output                │
│  DEBUGGER ANT: ✅ Read  🔒 Bash/tests/lint (run only)  ❌ Edit/Write      │
│                🔬 Chrome DevTools (console, network, DOM, perf trace)    │
│                🎭 Playwright (bug reproduction in isolated browser)       │
│                📡 Sentry/Firebase/Context7 (prod errors, data, docs)     │
│                🔧 CI/CD tools (gh run, vercel ls — read only)            │
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
│  • Debugger Ant + QA Ant: read-only — cannot edit ANY file                  │
│                                                                             │
│  DEBUGGER LAB (Section 4 — full diagnostic toolkit):                        │
│  • Chrome DevTools: console, network, DOM snapshot, screenshot, perf       │
│  • Playwright: reproduce bugs in isolated browser (click, type, wait)      │
│  • Sentry: production errors, stack traces, breadcrumbs, Seer AI          │
│  • Firebase: Firestore queries, auth users, Functions logs (READ ONLY)    │
│  • CI/CD: gh run list/view, vercel ls/logs (READ ONLY)                    │
│  • Protocol: REPRODUCE → OBSERVE → INVESTIGATE → DIAGNOSE → REPORT       │
│  • Graceful degradation: if MCP unavailable, continue with other tools    │
│                                                                             │
│  PLAYWRIGHT MCP (@playwright/mcp):                                          │
│  • QA Ant: FULL access — navigate, click, type, screenshot, network        │
│  • Debugger Ant: FULL access — reproduce bugs, capture evidence            │
│  • Builder Ants: OPTIONAL at VERIFY — browser_navigate, click, screenshot  │
│  • Opens visible Chromium window. Auth: operator logs in manually.          │
│                                                                             │
│  CI/CD VERIFICATION (MANDATORY at VERIFY):                                  │
│  • gh run list — check GitHub Actions pass/fail after every push           │
│  • gh run view <ID> --log-failed — read failure logs, fix, re-push         │
│  • vercel ls --yes — check Vercel deployment status                        │
│  • "Tests pass locally" is NOT enough. External CI must be green.          │
│  • Report CI/CD status in ANT_REPORT Section 5 (VERIFICATION)              │
│  • If CI fails: FIX IT. Don't report "everything went well."               │
│                                                                             │
│  MCP DATA SERVERS (3 servers):                                              │
│  • firebase: Firestore queries, auth users, functions logs, storage        │
│    (command: npx firebase-tools@latest mcp — uses existing CLI auth)       │
│  • sentry: production errors, stack traces, releases, Seer analysis        │
│    (remote: https://mcp.sentry.dev/mcp — OAuth, browser login)             │
│  • context7: up-to-date library docs (React, Next.js, Firebase, etc.)     │
│    (command: npx @upstash/context7-mcp — may need API key)                 │
│  • All roles: READ access. Ant: write via Firebase (with approval).        │
│                                                                             │
│  PROTECTED FEATURE SURFACES (Section 9b — NEO-SURGICAL.md 6b):             │
│  • Groups of 3+ files implementing a user-facing capability                │
│  • Deletion requires 🔑 FEATURE REMOVAL OVERRIDE: <feature>               │
│  • Ant: Feature Impact (FOOTPRINT) + Feature Inventory (VERIFY)            │
│  • Ghost: independently verify counts + non-existence claims               │
│  • V-11 violation = auto-reject (feature removal without override)          │
│  • Registry: .neo/PROTECTED_FEATURES.md (per project)                      │
│                                                                             │
│  ERROR RECOVERY CHEAT SHEET (Section 10):                                   │
│  E-01→E-12: Common failures + recovery steps                               │
│  Priority: Understand → Check if you caused it → Fix → Rollback           │
│  NEVER: @ts-ignore, delete tests, --force, expand scope, fabricate        │
│                                                                             │
│  RULES:                                                                     │
│  • BECCA NEVER modifies source code (only .neo/ files)                     │
│  • Ghost and Inspector NEVER modify files                                   │
│  • Debugger Ant + QA Ant NEVER modify files                                │
│  • No role deploys to production                                            │
│  • Violations → 🔑 REJECTED                                                │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---
