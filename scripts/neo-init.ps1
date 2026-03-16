<#
.SYNOPSIS
    Initializes the NEO pipeline in a target project.

.DESCRIPTION
    Deploys the full NEO governance system (roles, shared modules, templates,
    scripts) into a .neo/ directory inside the target project. Creates all
    working directories, STATE.md, and RUN_INDEX.md.

    Optionally archives existing governance/prompt files found in the project
    before deploying NEO, so nothing is lost.

.PARAMETER ProjectPath
    Absolute path to the target project root (e.g., d:\projects\sonny).

.PARAMETER Force
    If set, overwrites an existing .neo/ directory. Without this flag the
    script will abort if .neo/ already exists.

.PARAMETER ArchiveExisting
    If set, searches for existing governance/prompt files in the project
    and archives them to .neo/archive/legacy/ before deploying NEO.

.EXAMPLE
    .\neo-init.ps1 -ProjectPath "d:\projects\sonny"
    .\neo-init.ps1 -ProjectPath "d:\projects\sonny" -Force -ArchiveExisting
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$ProjectPath,

    [switch]$Force,
    [switch]$ArchiveExisting
)

$ErrorActionPreference = "Stop"

# ── UTF-8 without BOM helper (PowerShell 5.x adds BOM with -Encoding UTF8) ──
$Utf8NoBom = New-Object System.Text.UTF8Encoding $false
function Write-Utf8NoBom {
    param([string]$Path, [string]$Content)
    [System.IO.File]::WriteAllText($Path, $Content, $Utf8NoBom)
}

# ── Source paths ──────────────────────────────────────────────────────
$NeoRoot = Join-Path $PSScriptRoot ".."
$SourceRoles     = Join-Path $NeoRoot "roles"
$SourceShared    = Join-Path $NeoRoot "shared"
$SourceTemplates = Join-Path $NeoRoot "templates"
$SourceScripts   = Join-Path $NeoRoot "scripts"
$SourcePrompts   = Join-Path $NeoRoot "prompts"
$SourceInjections = Join-Path $NeoRoot "injections"
$SourceCards      = Join-Path $NeoRoot "cards"

# ── Target paths ─────────────────────────────────────────────────────
$TargetNeo = Join-Path $ProjectPath ".neo"

if ((Test-Path $TargetNeo) -and -not $Force) {
    Write-Host "ERROR: $TargetNeo already exists. Use -Force to overwrite." -ForegroundColor Red
    exit 1
}

Write-Host "" -ForegroundColor Cyan
Write-Host "  NEO INIT v2.5 — Deploying pipeline" -ForegroundColor Cyan
Write-Host "  Target: $ProjectPath" -ForegroundColor Cyan
Write-Host ""

# ── 0. Archive existing governance (if requested) ─────────────────────
if ($ArchiveExisting) {
    Write-Host "  Scanning for existing governance files..." -ForegroundColor Yellow

    $legacyDir = Join-Path $TargetNeo "archive\legacy"
    $legacyPatterns = @(
        @{ Name = "governance";  Path = Join-Path $ProjectPath "governance" },
        @{ Name = "prompts";     Path = Join-Path $ProjectPath "prompts" }
    )

    $archivedCount = 0
    foreach ($pattern in $legacyPatterns) {
        if (Test-Path $pattern.Path) {
            if (-not (Test-Path $legacyDir)) {
                New-Item -ItemType Directory -Path $legacyDir -Force | Out-Null
            }
            $dest = Join-Path $legacyDir $pattern.Name
            Copy-Item -Path $pattern.Path -Destination $dest -Recurse -Force
            $archivedCount++
            Write-Host "    Archived: $($pattern.Name)/ -> .neo/archive/legacy/$($pattern.Name)/" -ForegroundColor Yellow
        }
    }

    if ($archivedCount -eq 0) {
        Write-Host "    No existing governance files found." -ForegroundColor DarkGray
    } else {
        Write-Host "    Archived $archivedCount governance directory(s)." -ForegroundColor Yellow
    }
    Write-Host ""
}

# ── 1. Copy governance files (roles, shared, templates, scripts) ──────
$governanceDirs = @(
    @{ Source = $SourceRoles;     Target = Join-Path $TargetNeo "roles" },
    @{ Source = $SourceShared;    Target = Join-Path $TargetNeo "shared" },
    @{ Source = $SourceTemplates; Target = Join-Path $TargetNeo "templates" },
    @{ Source = $SourceScripts;   Target = Join-Path $TargetNeo "scripts" },
    @{ Source = $SourcePrompts;   Target = Join-Path $TargetNeo "prompts" },
    @{ Source = $SourceInjections; Target = Join-Path $TargetNeo "injections" },
    @{ Source = $SourceCards;      Target = Join-Path $TargetNeo "cards" }
)

foreach ($dir in $governanceDirs) {
    if (Test-Path $dir.Target) { Remove-Item $dir.Target -Recurse -Force }
    Copy-Item -Path $dir.Source -Destination $dir.Target -Recurse
    $count = (Get-ChildItem $dir.Target -File).Count
    Write-Host "  Copied $count files -> $($dir.Target)" -ForegroundColor Green
}

# ── 2. Create project-specific working directories ───────────────────
$workDirs = @(
    "inbox",
    "inbox\ideas",
    "inbox\ideas\completed",
    "outbox\ants",
    "outbox\ghost",
    "outbox\inspector",
    "audit\evidence",
    "audit\reviews",
    "audit\gate-logs",
    "archive",
    "runtime",
    "index"
)

foreach ($wd in $workDirs) {
    $full = Join-Path $TargetNeo $wd
    if (-not (Test-Path $full)) {
        New-Item -ItemType Directory -Path $full -Force | Out-Null
        Write-Host "  Created $full" -ForegroundColor DarkGray
    }
}

# ── 2b. Copy INBOX_README.md to inbox/ideas/ ────────────────────────
$inboxReadmeSrc = Join-Path $SourceTemplates "INBOX_README.md"
$inboxReadmeDst = Join-Path $TargetNeo "inbox\ideas\README.md"
if (Test-Path $inboxReadmeSrc) {
    Copy-Item -Path $inboxReadmeSrc -Destination $inboxReadmeDst -Force
    Write-Host "  Copied INBOX_README.md -> inbox/ideas/README.md" -ForegroundColor Green
}

# ── 3. Write STATE.md ────────────────────────────────────────────────
$projectName = (Split-Path $ProjectPath -Leaf).ToUpper()
$stateFile = Join-Path $TargetNeo "STATE.md"
$today = Get-Date -Format "yyyy-MM-dd"

$stateContent = @"
# NEO STATE: $projectName

**Last Run:** 0
**Last Task ID:** TASK-000
**Last Pheromone ID:** PH-000
**Last Lesson ID:** L-000
**Last Rejection ID:** REJ-000
**Status:** INITIALIZED
**Initialized:** $today
**Source:** $NeoRoot
**CLOSE_PROGRESS:** NONE
**CLOSE_LAST_CARD:** —
**CLOSE_LAST_CHECKPOINT:** —
"@

Write-Utf8NoBom -Path $stateFile -Content $stateContent
Write-Host "  Wrote STATE.md" -ForegroundColor Green

# ── 4. Write RUN_INDEX.md from template ──────────────────────────────
$indexFile = Join-Path $TargetNeo "RUN_INDEX.md"

$indexContent = @"
# RUN INDEX: $projectName

**Project:** $projectName
**Path:** $ProjectPath
**Created:** $today
**Last Updated:** $today

---

## COMPLETED RUNS

<!-- BECCA appends entries here on each CLOSE. -->

---

## QUICK STATS

| Metric | Value |
|--------|-------|
| **Total Runs** | 0 |
| **Total Tasks** | 0 |
| **Task ID Range** | -- |
| **First Run** | -- |
| **Last Run** | -- |

---

## NOTES

<!-- Cross-run observations, recurring patterns, deferred findings -->
"@

Write-Utf8NoBom -Path $indexFile -Content $indexContent
Write-Host "  Wrote RUN_INDEX.md" -ForegroundColor Green

# ── 5. Remove legacy NEO_STATE.json if present ────────────────────────
$legacyState = Join-Path $TargetNeo "NEO_STATE.json"
if (Test-Path $legacyState) {
    Remove-Item $legacyState -Force
    Write-Host "  Removed legacy NEO_STATE.json (replaced by STATE.md)" -ForegroundColor Yellow
}

# ── 6. Write .gitignore inside .neo ──────────────────────────────────
$gitignore = @"
# NEO pipeline — ignore working data, keep governance
/inbox/
/outbox/
/audit/
/archive/
/runtime/
/index/
STATE.md
RUN_INDEX.md
TODO_*.md
CRITICAL_SURFACES.md
"@

Write-Utf8NoBom -Path (Join-Path $TargetNeo ".gitignore") -Content $gitignore
Write-Host "  Wrote .neo/.gitignore" -ForegroundColor Green

# ── 7. Seed hive mind index files ─────────────────────────────────────
$indexDir = Join-Path $TargetNeo "index"

# MASTER_INDEX_001.md
$masterContent = @"
<!-- MASTER_INDEX shard 001 — max 500 entries per shard -->
<!-- Format: TASK_ID|DATE|ANT_TYPE|RISK|FILES_TOUCHED|VERDICT|EVIDENCE_SCORE|PHEROMONE_SUMMARY|FINGERPRINT -->
<!-- Search: grep "filename" index/MASTER_INDEX*.md -->
"@
Write-Utf8NoBom -Path (Join-Path $indexDir "MASTER_INDEX_001.md") -Content $masterContent

# FILE_OWNERSHIP shards (created on demand by BECCA — seed with empty marker)
$foContent = @"
<!-- FILE_OWNERSHIP index — sharded by directory prefix -->
<!-- BECCA creates shards as needed: FILE_OWNERSHIP_src_functions.md, etc. -->
<!-- This seed file can be deleted once real shards exist -->
"@
Write-Utf8NoBom -Path (Join-Path $indexDir "FILE_OWNERSHIP_SEED.md") -Content $foContent

# PHEROMONE severity shards (5 files)
$phSeverities = @("NUCLEAR", "HIGH", "MEDIUM", "LOW", "INFO")
foreach ($sev in $phSeverities) {
    $phContent = @"
<!-- PHEROMONE_$sev — Active pheromones at $sev severity -->
<!-- Format: | ID | Task | File:Line | Category | Message | Status | -->
<!-- Status: ACTIVE or RESOLVED_TASK-NNN -->

| ID | Task | File:Line | Category | Message | Status |
|----|------|-----------|----------|---------|--------|
"@
    Write-Utf8NoBom -Path (Join-Path $indexDir "PHEROMONE_$sev.md") -Content $phContent
}

# LESSONS_INDEX seed (general domain)
$lessonsContent = @"
# LESSONS_INDEX — general

<!-- Lessons that don't fit a specific domain shard -->
<!-- Format: ## L-NNN: <title> (TASK-NNN, YYYY-MM-DD) -->
"@
Write-Utf8NoBom -Path (Join-Path $indexDir "LESSONS_INDEX_general.md") -Content $lessonsContent

# REJECTION_INDEX seed
$rejContent = @"
# REJECTION_INDEX — All Rejections Across Runs

<!-- Format: ## REJ-NNN: <short reason> (TASK-NNN, YYYY-MM-DD) -->
<!-- Categories: EVIDENCE | COMPLIANCE | SURGICAL | NUCLEAR | HIVE | QUALITY | DOD -->
"@
Write-Utf8NoBom -Path (Join-Path $indexDir "REJECTION_INDEX.md") -Content $rejContent

# FINDINGS_INDEX seed
$findingsContent = @"
# FINDINGS_INDEX — Aggregated Ghost/Inspector Findings Across Runs

| Finding Type | Category | Severity | Count | First Seen | Last Seen | Source | Status |
|--------------|----------|----------|-------|------------|-----------|--------|--------|
"@
Write-Utf8NoBom -Path (Join-Path $indexDir "FINDINGS_INDEX.md") -Content $findingsContent

Write-Host "  Seeded 10 index files in index/" -ForegroundColor Green

# ── 8. Generate CLAUDE.md in project root ────────────────────────────
$claudeFile = Join-Path $ProjectPath "CLAUDE.md"
$claudeTemplate = Join-Path $NeoRoot "templates\CLAUDE_PROJECT.md"

if (Test-Path $claudeTemplate) {
    Write-Host ""
    Write-Host "  Generating CLAUDE.md..." -ForegroundColor White

    # Backup existing CLAUDE.md if it exists and isn't NEO-generated
    if (Test-Path $claudeFile) {
        $existingContent = Get-Content $claudeFile -Raw
        if ($existingContent -notmatch "NEO Governed Project") {
            $backupPath = Join-Path $TargetNeo "archive\legacy\CLAUDE.md.bak"
            $backupDir = Split-Path $backupPath -Parent
            if (-not (Test-Path $backupDir)) {
                New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
            }
            Copy-Item -Path $claudeFile -Destination $backupPath -Force
            Write-Host "    [BACKUP] Existing CLAUDE.md archived to .neo/archive/legacy/" -ForegroundColor Yellow
        }
    }

    # Read template and replace placeholders with project-specific values
    $claudeContent = Get-Content $claudeTemplate -Raw
    $claudeContent = $claudeContent -replace '\{\{PROJECT_NAME\}\}', $projectName
    $claudeContent = $claudeContent -replace '\{\{PROJECT_PATH\}\}', $ProjectPath

    # Fill in stack/commands/invariants/paths with placeholder guidance
    $claudeContent = $claudeContent -replace '\{\{STACK\}\}', '(Update this with your project stack)'
    $claudeContent = $claudeContent -replace '\{\{COMMANDS\}\}', '(Update this with your project commands)'
    $claudeContent = $claudeContent -replace '\{\{NUCLEAR_INVARIANTS\}\}', '(Update this with your project nuclear invariants)'
    $claudeContent = $claudeContent -replace '\{\{KEY_PATHS\}\}', '(Update this with your project key paths)'

    Write-Utf8NoBom -Path $claudeFile -Content $claudeContent
    Write-Host "    [CREATED] CLAUDE.md in project root" -ForegroundColor Green
    Write-Host "    NOTE: Edit CLAUDE.md to add project-specific stack, commands, and invariants" -ForegroundColor Yellow
} else {
    Write-Host "    [SKIP] templates/CLAUDE_PROJECT.md not found - CLAUDE.md not generated" -ForegroundColor Yellow
}

# ── Done ─────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "  NEO pipeline initialized in: $TargetNeo" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Deployed:" -ForegroundColor Green
Write-Host "    roles/       4 roles (BECCA, Ant, Ghost, Inspector)" -ForegroundColor Green
Write-Host "    shared/      9 modules (Activation, Gates, Evidence, Outputs, Tools, Hive, Surgical, HiveMind-Global, Five-Horsemen)" -ForegroundColor Green
Write-Host "    templates/   18 templates" -ForegroundColor Green
Write-Host "    scripts/     neo-init.ps1, neo-refresh.ps1" -ForegroundColor Green
Write-Host "    prompts/     Specialized Ant prompts (Color Expert, Figma, QA, Debugger, Prompt Architect)" -ForegroundColor Green
Write-Host "    injections/  7 safety injections (paste mid-session)" -ForegroundColor Green
Write-Host "    cards/       33 protocol cards (phase-specific instructions)" -ForegroundColor Green
Write-Host "    index/       10 hive mind index files (seeded)" -ForegroundColor Green
Write-Host "    STATE.md     Run counter + task ID + pheromone ID tracker" -ForegroundColor Green
Write-Host "    RUN_INDEX.md BECCA's institutional memory" -ForegroundColor Green
Write-Host "    CLAUDE.md    Claude Code guide (project root - tells Claude about NEO)" -ForegroundColor Green
Write-Host ""
Write-Host "  Next steps:" -ForegroundColor Yellow
Write-Host "    1. Edit CLAUDE.md in project root - add stack, commands, nuclear invariants" -ForegroundColor Yellow
Write-Host "    2. (Optional) Copy templates/CRITICAL_SURFACES.md to .neo/ and customize" -ForegroundColor Yellow
Write-Host "    3. Tell BECCA: 'deep dive into $projectName'" -ForegroundColor Yellow
Write-Host "    4. BECCA will RECON, dispatch Scout, create TODO" -ForegroundColor Yellow
Write-Host "    5. Say 'I AM' to activate each role in the pipeline" -ForegroundColor Yellow
Write-Host ""
Write-Host "  To update governance later:" -ForegroundColor DarkGray
Write-Host "    .neo\scripts\neo-refresh.ps1 -ProjectPath ""$ProjectPath""" -ForegroundColor DarkGray
Write-Host ""
