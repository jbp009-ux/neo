<#
.SYNOPSIS
    Refreshes a project's NEO governance files from the NEO main folder.

.DESCRIPTION
    Re-copies roles, shared modules, templates, and scripts from the NEO main
    source into the target project's .neo/ directory. Preserves all
    project-specific data (inbox, outbox, audit, archive, runtime, STATE.md,
    RUN_INDEX.md, TODO, CRITICAL_SURFACES.md).

    Also creates any missing directories that were added in newer NEO versions,
    and migrates legacy NEO_STATE.json to STATE.md if found.

.PARAMETER ProjectPath
    Absolute path to the target project root (e.g., d:\projects\sonny).

.PARAMETER DryRun
    If set, shows what would be updated without making changes.

.EXAMPLE
    .\neo-refresh.ps1 -ProjectPath "d:\projects\sonny"
    .\neo-refresh.ps1 -ProjectPath "d:\projects\sonny" -DryRun
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$ProjectPath,

    [switch]$DryRun
)

$ErrorActionPreference = "Stop"

# ── Source paths ──────────────────────────────────────────────────────
$NeoRoot = Join-Path $PSScriptRoot ".."
$SourceRoles     = Join-Path $NeoRoot "roles"
$SourceShared    = Join-Path $NeoRoot "shared"
$SourceTemplates = Join-Path $NeoRoot "templates"
$SourceScripts   = Join-Path $NeoRoot "scripts"
$SourcePrompts   = Join-Path $NeoRoot "prompts"

# ── Target paths ─────────────────────────────────────────────────────
$TargetNeo = Join-Path $ProjectPath ".neo"

if (-not (Test-Path $TargetNeo)) {
    Write-Host "ERROR: $TargetNeo does not exist. Run neo-init.ps1 first." -ForegroundColor Red
    exit 1
}

$mode = if ($DryRun) { "DRY RUN" } else { "LIVE" }
Write-Host "" -ForegroundColor Cyan
Write-Host "  NEO REFRESH v2.2 [$mode] — Syncing governance" -ForegroundColor Cyan
Write-Host "  Target: $ProjectPath" -ForegroundColor Cyan
Write-Host ""

# ── 1. Sync governance directories ───────────────────────────────────
$governanceDirs = @(
    @{ Name = "roles";     Source = $SourceRoles;     Target = Join-Path $TargetNeo "roles" },
    @{ Name = "shared";    Source = $SourceShared;    Target = Join-Path $TargetNeo "shared" },
    @{ Name = "templates"; Source = $SourceTemplates; Target = Join-Path $TargetNeo "templates" },
    @{ Name = "scripts";   Source = $SourceScripts;   Target = Join-Path $TargetNeo "scripts" },
    @{ Name = "prompts";   Source = $SourcePrompts;   Target = Join-Path $TargetNeo "prompts" }
)

$totalUpdated = 0
$totalSkipped = 0
$totalNew = 0

foreach ($dir in $governanceDirs) {
    Write-Host "  Checking $($dir.Name)..." -ForegroundColor White

    $sourceFiles = Get-ChildItem $dir.Source -File -Recurse
    foreach ($sf in $sourceFiles) {
        $relativePath = $sf.FullName.Substring($dir.Source.Length)
        $targetFile   = Join-Path $dir.Target $relativePath

        $needsUpdate = $false

        if (-not (Test-Path $targetFile)) {
            $needsUpdate = $true
            $reason = "NEW"
            $totalNew++
        } else {
            $sourceHash = (Get-FileHash $sf.FullName -Algorithm SHA256).Hash
            $targetHash = (Get-FileHash $targetFile -Algorithm SHA256).Hash
            if ($sourceHash -ne $targetHash) {
                $needsUpdate = $true
                $reason = "CHANGED"
            }
        }

        if ($needsUpdate) {
            $totalUpdated++
            if ($DryRun) {
                Write-Host "    [$reason] $($dir.Name)$relativePath" -ForegroundColor Yellow
            } else {
                $targetDir = Split-Path $targetFile -Parent
                if (-not (Test-Path $targetDir)) {
                    New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
                }
                Copy-Item -Path $sf.FullName -Destination $targetFile -Force
                Write-Host "    [$reason] $($dir.Name)$relativePath" -ForegroundColor Green
            }
        } else {
            $totalSkipped++
        }
    }
}

# ── 2. Create missing directories (for older deployments) ─────────────
Write-Host ""
Write-Host "  Checking structure..." -ForegroundColor White

$requiredDirs = @(
    "inbox",
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

$dirsCreated = 0
foreach ($rd in $requiredDirs) {
    $full = Join-Path $TargetNeo $rd
    if (-not (Test-Path $full)) {
        if ($DryRun) {
            Write-Host "    [MISSING] Would create: $rd" -ForegroundColor Yellow
        } else {
            New-Item -ItemType Directory -Path $full -Force | Out-Null
            Write-Host "    [CREATED] $rd" -ForegroundColor Green
        }
        $dirsCreated++
    }
}

if ($dirsCreated -eq 0) {
    Write-Host "    All directories present." -ForegroundColor DarkGray
}

# ── 3. Migrate legacy NEO_STATE.json → STATE.md (if needed) ──────────
$legacyState = Join-Path $TargetNeo "NEO_STATE.json"
$newState = Join-Path $TargetNeo "STATE.md"

if ((Test-Path $legacyState) -and -not (Test-Path $newState)) {
    Write-Host ""
    Write-Host "  Legacy migration detected:" -ForegroundColor Yellow

    if ($DryRun) {
        Write-Host "    [MIGRATE] Would convert NEO_STATE.json -> STATE.md" -ForegroundColor Yellow
    } else {
        $projectName = (Split-Path $ProjectPath -Leaf).ToUpper()
        $today = Get-Date -Format "yyyy-MM-dd"

        # Read what we can from the legacy JSON
        $legacyData = Get-Content $legacyState -Raw | ConvertFrom-Json
        $nextTaskId = if ($legacyData.nextTaskId) { $legacyData.nextTaskId - 1 } else { 0 }
        $taskIdStr = "TASK-" + $nextTaskId.ToString("000")

        $stateContent = @"
# NEO STATE: $projectName

**Last Run:** 0
**Last Task ID:** $taskIdStr
**Status:** INITIALIZED
**Migrated From:** NEO_STATE.json
**Migration Date:** $today
"@

        Set-Content -Path $newState -Value $stateContent -Encoding UTF8
        Remove-Item $legacyState -Force
        Write-Host "    [MIGRATED] NEO_STATE.json -> STATE.md (task ID: $taskIdStr)" -ForegroundColor Green
    }
}

# ── 4. Create RUN_INDEX.md if missing ─────────────────────────────────
$indexFile = Join-Path $TargetNeo "RUN_INDEX.md"
if (-not (Test-Path $indexFile)) {
    if ($DryRun) {
        Write-Host "    [MISSING] Would create RUN_INDEX.md" -ForegroundColor Yellow
    } else {
        $projectName = (Split-Path $ProjectPath -Leaf).ToUpper()
        $today = Get-Date -Format "yyyy-MM-dd"

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

        Set-Content -Path $indexFile -Value $indexContent -Encoding UTF8
        Write-Host "    [CREATED] RUN_INDEX.md" -ForegroundColor Green
    }
}

# ── 5. Seed hive mind indexes if missing (v2.1 upgrade) ──────────────
$indexDir = Join-Path $TargetNeo "index"
$masterFile = Join-Path $indexDir "MASTER_INDEX_001.md"

if (-not (Test-Path $masterFile)) {
    Write-Host ""
    Write-Host "  Hive Mind upgrade (v2.1):" -ForegroundColor Yellow

    if ($DryRun) {
        Write-Host "    [SEED] Would create 7 index files in index/" -ForegroundColor Yellow
    } else {
        # MASTER_INDEX_001.md
        $masterContent = @"
<!-- MASTER_INDEX shard 001 — max 500 entries per shard -->
<!-- Format: TASK_ID|DATE|ANT_TYPE|RISK|FILES_TOUCHED|VERDICT|EVIDENCE_SCORE|PHEROMONE_SUMMARY|FINGERPRINT -->
<!-- Search: grep "filename" index/MASTER_INDEX*.md -->
"@
        Set-Content -Path $masterFile -Value $masterContent -Encoding UTF8

        # FILE_OWNERSHIP seed
        $foContent = @"
<!-- FILE_OWNERSHIP index — sharded by directory prefix -->
<!-- BECCA creates shards as needed: FILE_OWNERSHIP_src_functions.md, etc. -->
<!-- This seed file can be deleted once real shards exist -->
"@
        Set-Content -Path (Join-Path $indexDir "FILE_OWNERSHIP_SEED.md") -Value $foContent -Encoding UTF8

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
            Set-Content -Path (Join-Path $indexDir "PHEROMONE_$sev.md") -Value $phContent -Encoding UTF8
        }

        Write-Host "    [SEEDED] 7 index files in index/" -ForegroundColor Green
    }
}

# Add Last Pheromone ID to STATE.md if missing (v2.1 upgrade)
$stateFile = Join-Path $TargetNeo "STATE.md"
if (Test-Path $stateFile) {
    $stateText = Get-Content $stateFile -Raw
    if ($stateText -notmatch "Last Pheromone ID") {
        if ($DryRun) {
            Write-Host "    [UPGRADE] Would add Last Pheromone ID to STATE.md" -ForegroundColor Yellow
        } else {
            $stateText = $stateText -replace "(\*\*Last Task ID:\*\* [^\r\n]+)", "`$1`n**Last Pheromone ID:** PH-000"
            Set-Content -Path $stateFile -Value $stateText -Encoding UTF8
            Write-Host "    [UPGRADE] Added Last Pheromone ID to STATE.md" -ForegroundColor Green
        }
    }
}

# ── Summary ──────────────────────────────────────────────────────────
Write-Host ""
Write-Host "  SUMMARY:" -ForegroundColor Cyan
Write-Host "    Updated:  $totalUpdated file(s) ($totalNew new)" -ForegroundColor $(if ($totalUpdated -gt 0) { "Yellow" } else { "Green" })
Write-Host "    Skipped:  $totalSkipped file(s) (unchanged)" -ForegroundColor DarkGray
Write-Host "    Dirs:     $dirsCreated created" -ForegroundColor $(if ($dirsCreated -gt 0) { "Yellow" } else { "DarkGray" })
Write-Host "    Preserved: inbox, outbox, audit, archive, runtime, index, STATE.md, RUN_INDEX.md, TODO, CRITICAL_SURFACES.md" -ForegroundColor DarkGray
Write-Host ""

if ($DryRun -and ($totalUpdated -gt 0 -or $dirsCreated -gt 0)) {
    Write-Host "  Run without -DryRun to apply these changes." -ForegroundColor Yellow
    Write-Host ""
}
