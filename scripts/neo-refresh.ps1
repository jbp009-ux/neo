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

# ── UTF-8 without BOM helper (PowerShell 5.x adds BOM with -Encoding UTF8) ──
$Utf8NoBom = New-Object System.Text.UTF8Encoding $false
function Write-Utf8NoBom {
    param([string]$Path, [string]$Content)
    [System.IO.File]::WriteAllText($Path, $Content, $Utf8NoBom)
}

# ── Source paths ──────────────────────────────────────────────────────
$NeoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$SourceRoles     = Join-Path $NeoRoot "roles"
$SourceShared    = Join-Path $NeoRoot "shared"
$SourceTemplates = Join-Path $NeoRoot "templates"
$SourceScripts   = Join-Path $NeoRoot "scripts"
$SourcePrompts   = Join-Path $NeoRoot "prompts"
$SourceInjections = Join-Path $NeoRoot "injections"
$SourceCards      = Join-Path $NeoRoot "cards"

# ── Target paths ─────────────────────────────────────────────────────
$TargetNeo = Join-Path $ProjectPath ".neo"

if (-not (Test-Path $TargetNeo)) {
    Write-Host "ERROR: $TargetNeo does not exist. Run neo-init.ps1 first." -ForegroundColor Red
    exit 1
}

$mode = if ($DryRun) { "DRY RUN" } else { "LIVE" }
Write-Host "" -ForegroundColor Cyan
Write-Host "  NEO REFRESH v2.7 [$mode] - Syncing governance" -ForegroundColor Cyan
Write-Host "  Target: $ProjectPath" -ForegroundColor Cyan
Write-Host ""

# ── 1. Sync governance directories ───────────────────────────────────
$governanceDirs = @(
    @{ Name = "roles";     Source = $SourceRoles;     Target = Join-Path $TargetNeo "roles" },
    @{ Name = "shared";    Source = $SourceShared;    Target = Join-Path $TargetNeo "shared" },
    @{ Name = "templates"; Source = $SourceTemplates; Target = Join-Path $TargetNeo "templates" },
    @{ Name = "scripts";   Source = $SourceScripts;   Target = Join-Path $TargetNeo "scripts" },
    @{ Name = "prompts";   Source = $SourcePrompts;   Target = Join-Path $TargetNeo "prompts" },
    @{ Name = "injections"; Source = $SourceInjections; Target = Join-Path $TargetNeo "injections" },
    @{ Name = "cards";      Source = $SourceCards;      Target = Join-Path $TargetNeo "cards" }
)

$totalUpdated = 0
$totalSkipped = 0
$totalNew = 0
$hivemindMerged = $false

# ── Helper: Merge HIVEMIND-GLOBAL (append-only safe sync) ────────────
# BECCA appends project-local entries (GP-NNN, UA-NN, US-NN, lessons)
# during CLOSE. A naive copy would wipe those additions. This function
# takes the source as canonical, finds entries in target that aren't in
# source, and appends them so nothing is lost.
function Merge-HivemindGlobal {
    param(
        [string]$SourcePath,
        [string]$TargetPath,
        [switch]$WhatIf
    )

    $sourceLines = Get-Content $SourcePath
    $targetLines = Get-Content $TargetPath

    # Extract structured entry rows from a file (GP-NNN, UA-NN, US-NN, lesson rows)
    function Get-EntryRows {
        param([string[]]$Lines)
        $entries = [ordered]@{}
        $lessonRows = @()
        $currentSection = ""

        foreach ($line in $Lines) {
            # Track which section we're in
            if ($line -match '^## Cross-Project Pheromones') { $currentSection = "GP" }
            elseif ($line -match '^## Universal Anti-Patterns') { $currentSection = "UA" }
            elseif ($line -match '^## Universal Safe Patterns') { $currentSection = "US" }
            elseif ($line -match '^## Cross-Colony Lessons') { $currentSection = "LESSONS" }
            elseif ($line -match '^## Maintenance Rules') { $currentSection = "" }
            elseif ($line -match '^## Entry Lifecycle') { $currentSection = "" }
            elseif ($line -match '^## Changelog') { $currentSection = "" }

            # Extract ID-based entries (GP, UA, US)
            if ($line -match '^\|\s*(GP-\d+)\s*\|') {
                $entries[$matches[1]] = $line
            }
            elseif ($line -match '^\|\s*(UA-\d+)\s*\|') {
                $entries[$matches[1]] = $line
            }
            elseif ($line -match '^\|\s*(US-\d+)\s*\|') {
                $entries[$matches[1]] = $line
            }
            # Lesson rows: data rows in the lessons table (start with | date |)
            elseif ($currentSection -eq "LESSONS" -and $line -match '^\|\s*\d{4}-\d{2}-\d{2}' -and $line -notmatch '^\|.*Date.*\|') {
                $lessonRows += $line
            }
        }
        return @{ Entries = $entries; Lessons = $lessonRows }
    }

    $sourceData = Get-EntryRows -Lines $sourceLines
    $targetData = Get-EntryRows -Lines $targetLines

    # Find entries in target that are NOT in source (BECCA's local additions)
    $localGP = @()
    $localUA = @()
    $localUS = @()
    $localLessons = @()

    foreach ($id in $targetData.Entries.Keys) {
        if (-not $sourceData.Entries.Contains($id)) {
            if ($id -match '^GP-') { $localGP += $targetData.Entries[$id] }
            elseif ($id -match '^UA-') { $localUA += $targetData.Entries[$id] }
            elseif ($id -match '^US-') { $localUS += $targetData.Entries[$id] }
        }
    }

    # Find lesson rows in target that aren't in source (compare full row text)
    $sourceLessonSet = @{}
    foreach ($sl in $sourceData.Lessons) { $sourceLessonSet[$sl.Trim()] = $true }
    foreach ($tl in $targetData.Lessons) {
        if (-not $sourceLessonSet.ContainsKey($tl.Trim())) {
            $localLessons += $tl
        }
    }

    $totalLocal = $localGP.Count + $localUA.Count + $localUS.Count + $localLessons.Count

    if ($totalLocal -eq 0) {
        # No local additions - safe to overwrite
        if (-not $WhatIf) {
            Copy-Item -Path $SourcePath -Destination $TargetPath -Force
        }
        return @{ LocalCount = 0; Details = "No local additions - standard copy" }
    }

    # Merge: start with source content, inject local additions into correct sections
    $merged = @()
    $currentSection = ""

    for ($i = 0; $i -lt $sourceLines.Count; $i++) {
        $line = $sourceLines[$i]
        $merged += $line

        # Detect section boundaries to know WHERE to append
        if ($line -match '^## Cross-Project Pheromones') { $currentSection = "GP" }
        elseif ($line -match '^## Universal Anti-Patterns') { $currentSection = "UA" }
        elseif ($line -match '^## Universal Safe Patterns') { $currentSection = "US" }
        elseif ($line -match '^## Cross-Colony Lessons') { $currentSection = "LESSONS" }

        # Append local entries just before format instructions or section break
        if ($line -match '^\*\*Format for new entries:\*\*' -and $localGP.Count -gt 0) {
            # Insert GP entries before the format instruction
            $merged = $merged[0..($merged.Count-2)]  # Remove the format line we just added
            foreach ($entry in $localGP) { $merged += $entry }
            $merged += ""
            $merged += $line  # Re-add the format line
        }

        # For UA/US/Lessons: append after the last data row before the section separator
        # Detect the "---" that ends each section
        $nextLine = if ($i + 1 -lt $sourceLines.Count) { $sourceLines[$i + 1] } else { "" }

        if ($currentSection -eq "UA" -and $line -match '^\|' -and $nextLine -match '^$|^---') {
            if ($localUA.Count -gt 0) {
                foreach ($entry in $localUA) { $merged += $entry }
            }
        }
        elseif ($currentSection -eq "US" -and $line -match '^\|' -and $nextLine -match '^$|^---') {
            if ($localUS.Count -gt 0) {
                foreach ($entry in $localUS) { $merged += $entry }
            }
        }
        elseif ($currentSection -eq "LESSONS" -and $line -match '^\|.*\d{4}-\d{2}' -and ($nextLine -match '^$|^---')) {
            if ($localLessons.Count -gt 0) {
                foreach ($entry in $localLessons) { $merged += $entry }
            }
        }
    }

    if (-not $WhatIf) {
        Write-Utf8NoBom -Path $TargetPath -Content ($merged -join "`n")
    }

    $details = @()
    if ($localGP.Count -gt 0) { $details += "$($localGP.Count) pheromone(s)" }
    if ($localUA.Count -gt 0) { $details += "$($localUA.Count) anti-pattern(s)" }
    if ($localUS.Count -gt 0) { $details += "$($localUS.Count) safe pattern(s)" }
    if ($localLessons.Count -gt 0) { $details += "$($localLessons.Count) lesson(s)" }

    return @{ LocalCount = $totalLocal; Details = ($details -join ", ") }
}

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

            # Special handling for HIVEMIND-GLOBAL: merge instead of overwrite
            $isHivemind = $sf.Name -eq "NEO-HIVEMIND-GLOBAL.md" -and (Test-Path $targetFile)
            if ($isHivemind) {
                if ($DryRun) {
                    $mergeResult = Merge-HivemindGlobal -SourcePath $sf.FullName -TargetPath $targetFile -WhatIf
                    Write-Host "    [MERGE] $($dir.Name)$relativePath - $($mergeResult.Details)" -ForegroundColor Yellow
                } else {
                    $mergeResult = Merge-HivemindGlobal -SourcePath $sf.FullName -TargetPath $targetFile
                    if ($mergeResult.LocalCount -gt 0) {
                        Write-Host "    [MERGED] $($dir.Name)$relativePath - preserved $($mergeResult.LocalCount) local entries ($($mergeResult.Details))" -ForegroundColor Cyan
                        $hivemindMerged = $true
                    } else {
                        Write-Host "    [$reason] $($dir.Name)$relativePath" -ForegroundColor Green
                    }
                }
            } else {
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

# ── 2b. Ensure INBOX_README.md exists in inbox/ideas/ ─────────────────
$inboxReadmeSrc = Join-Path $SourceTemplates "INBOX_README.md"
$inboxReadmeDst = Join-Path $TargetNeo "inbox\ideas\README.md"
if ((Test-Path $inboxReadmeSrc) -and -not (Test-Path $inboxReadmeDst)) {
    if ($DryRun) {
        Write-Host "    [MISSING] Would copy: INBOX_README.md -> inbox/ideas/README.md" -ForegroundColor Yellow
    } else {
        Copy-Item -Path $inboxReadmeSrc -Destination $inboxReadmeDst -Force
        Write-Host "    [CREATED] inbox/ideas/README.md" -ForegroundColor Green
    }
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

        Write-Utf8NoBom -Path $newState -Content $stateContent
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

        Write-Utf8NoBom -Path $indexFile -Content $indexContent
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
        Write-Host "    [SEED] Would create 10 index files in index/" -ForegroundColor Yellow
    } else {
        # MASTER_INDEX_001.md
        $masterContent = @"
<!-- MASTER_INDEX shard 001 — max 500 entries per shard -->
<!-- Format: TASK_ID|DATE|ANT_TYPE|RISK|FILES_TOUCHED|VERDICT|EVIDENCE_SCORE|PHEROMONE_SUMMARY|FINGERPRINT -->
<!-- Search: grep "filename" index/MASTER_INDEX*.md -->
"@
        Write-Utf8NoBom -Path $masterFile -Content $masterContent

        # FILE_OWNERSHIP seed
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

        # LESSONS_INDEX seed
        $lessonsContent = @"
<!-- LESSONS_INDEX shard: general — domain-specific lessons from Ant reports -->
<!-- Format: ## L-NNN | Title | Task | Date | Ant Type | Files | Category | Lesson | Evidence -->
<!-- Categories: WHAT_WORKED, GOTCHA, FRAGILE, APPROACH, VERIFICATION, PROTOCOL -->
"@
        Write-Utf8NoBom -Path (Join-Path $indexDir "LESSONS_INDEX_general.md") -Content $lessonsContent

        # REJECTION_INDEX seed
        $rejectionContent = @"
# REJECTION INDEX

<!-- All Ghost/Inspector rejections across runs -->
<!-- Format: ## REJ-NNN entries with task, reviewer, category, deficiencies, resolution -->
<!-- Categories: EVIDENCE, COMPLIANCE, SURGICAL, NUCLEAR, HIVE, QUALITY, DOD -->
<!-- Resolution: FIXED_TASK-NNN, UNRESOLVED, DEFERRED -->
"@
        Write-Utf8NoBom -Path (Join-Path $indexDir "REJECTION_INDEX.md") -Content $rejectionContent

        # FINDINGS_INDEX seed
        $findingsContent = @"
# FINDINGS INDEX

<!-- Aggregated finding types across runs with running counts -->
<!-- Status: RECURRING (appeared this run), RESOLVED (absent 5+ runs), IMPROVING (count dropped 50%+) -->
<!-- Threshold: count >= 3 = FRAMEWORK SIGNAL, count >= 5 = PRIORITY -->

| Finding Type | Count | First Seen | Last Seen | Status | Example Tasks |
|-------------|-------|------------|-----------|--------|---------------|
"@
        Write-Utf8NoBom -Path (Join-Path $indexDir "FINDINGS_INDEX.md") -Content $findingsContent

        Write-Host "    [SEEDED] 10 index files in index/" -ForegroundColor Green
    }
}

# Add missing tracking IDs to STATE.md (v2.1+ upgrades)
$stateFile = Join-Path $TargetNeo "STATE.md"
if (Test-Path $stateFile) {
    $stateText = Get-Content $stateFile -Raw
    $stateChanged = $false

    if ($stateText -notmatch "Last Pheromone ID") {
        if (-not $DryRun) {
            $stateText = $stateText -replace "(\*\*Last Task ID:\*\* [^\r\n]+)", "`$1`n**Last Pheromone ID:** PH-000"
            $stateChanged = $true
        }
        Write-Host "    [UPGRADE] $(if ($DryRun) { 'Would add' } else { 'Added' }) Last Pheromone ID to STATE.md" -ForegroundColor $(if ($DryRun) { "Yellow" } else { "Green" })
    }

    if ($stateText -notmatch "Last Lesson ID") {
        if (-not $DryRun) {
            $stateText = $stateText -replace "(\*\*Last Pheromone ID:\*\* [^\r\n]+)", "`$1`n**Last Lesson ID:** L-000"
            $stateChanged = $true
        }
        Write-Host "    [UPGRADE] $(if ($DryRun) { 'Would add' } else { 'Added' }) Last Lesson ID to STATE.md" -ForegroundColor $(if ($DryRun) { "Yellow" } else { "Green" })
    }

    if ($stateText -notmatch "Last Rejection ID") {
        if (-not $DryRun) {
            $stateText = $stateText -replace "(\*\*Last Lesson ID:\*\* [^\r\n]+)", "`$1`n**Last Rejection ID:** REJ-000"
            $stateChanged = $true
        }
        Write-Host "    [UPGRADE] $(if ($DryRun) { 'Would add' } else { 'Added' }) Last Rejection ID to STATE.md" -ForegroundColor $(if ($DryRun) { "Yellow" } else { "Green" })
    }

    if ($stateChanged -and -not $DryRun) {
        Write-Utf8NoBom -Path $stateFile -Content $stateText
    }
}

# Seed missing index files for existing deployments (v2.4 upgrade)
$indexDir2 = Join-Path $TargetNeo "index"
if (Test-Path $indexDir2) {
    $lessonsFile = Join-Path $indexDir2 "LESSONS_INDEX_general.md"
    if (-not (Test-Path $lessonsFile)) {
        if ($DryRun) {
            Write-Host "    [SEED] Would create LESSONS_INDEX_general.md" -ForegroundColor Yellow
        } else {
            $lc = @"
<!-- LESSONS_INDEX shard: general — domain-specific lessons from Ant reports -->
<!-- Format: ## L-NNN | Title | Task | Date | Ant Type | Files | Category | Lesson | Evidence -->
<!-- Categories: WHAT_WORKED, GOTCHA, FRAGILE, APPROACH, VERIFICATION, PROTOCOL -->
"@
            Write-Utf8NoBom -Path $lessonsFile -Content $lc
            Write-Host "    [SEED] Created LESSONS_INDEX_general.md" -ForegroundColor Green
        }
    }

    $rejFile = Join-Path $indexDir2 "REJECTION_INDEX.md"
    if (-not (Test-Path $rejFile)) {
        if ($DryRun) {
            Write-Host "    [SEED] Would create REJECTION_INDEX.md" -ForegroundColor Yellow
        } else {
            $rc = @"
# REJECTION INDEX

<!-- All Ghost/Inspector rejections across runs -->
<!-- Categories: EVIDENCE, COMPLIANCE, SURGICAL, NUCLEAR, HIVE, QUALITY, DOD -->
"@
            Write-Utf8NoBom -Path $rejFile -Content $rc
            Write-Host "    [SEED] Created REJECTION_INDEX.md" -ForegroundColor Green
        }
    }

    $findFile = Join-Path $indexDir2 "FINDINGS_INDEX.md"
    if (-not (Test-Path $findFile)) {
        if ($DryRun) {
            Write-Host "    [SEED] Would create FINDINGS_INDEX.md" -ForegroundColor Yellow
        } else {
            $fc = @"
# FINDINGS INDEX

<!-- Aggregated finding types across runs with running counts -->

| Finding Type | Count | First Seen | Last Seen | Status | Example Tasks |
|-------------|-------|------------|-----------|--------|---------------|
"@
            Write-Utf8NoBom -Path $findFile -Content $fc
            Write-Host "    [SEED] Created FINDINGS_INDEX.md" -ForegroundColor Green
        }
    }
}

# ── 6. Sync CLAUDE.md to project root (v2.3 upgrade) ─────────────────
$claudeFile = Join-Path $ProjectPath "CLAUDE.md"
$claudeTemplate = Join-Path (Join-Path $NeoRoot "templates") "CLAUDE_PROJECT.md"
$claudeNeedsUpdate = $false

if (Test-Path $claudeTemplate) {
    if (-not (Test-Path $claudeFile)) {
        # No CLAUDE.md at all — generate from template
        $claudeNeedsUpdate = $true
        $claudeReason = "MISSING"
    } elseif ((Get-Content $claudeFile -Raw) -notmatch "NEO Governed Project") {
        # Exists but is from old PMX/Colony OS era — needs replacement
        $claudeNeedsUpdate = $true
        $claudeReason = "LEGACY (pre-NEO)"
    }
    # If it already has "NEO Governed Project", it's a NEO CLAUDE.md — leave it alone
    # (project-specific customizations should be preserved)
}

if ($claudeNeedsUpdate) {
    Write-Host ""
    Write-Host "  CLAUDE.md sync:" -ForegroundColor Yellow

    if ($DryRun) {
        Write-Host "    [$claudeReason] Would generate CLAUDE.md in project root" -ForegroundColor Yellow
    } else {
        # Backup existing CLAUDE.md if it exists
        if (Test-Path $claudeFile) {
            $backupDir = Join-Path $TargetNeo "archive\legacy"
            if (-not (Test-Path $backupDir)) {
                New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
            }
            $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
            Copy-Item -Path $claudeFile -Destination (Join-Path $backupDir "CLAUDE.md.$timestamp.bak") -Force
            Write-Host "    [BACKUP] Existing CLAUDE.md archived" -ForegroundColor Yellow
        }

        # Generate from template with project-specific placeholders
        $projectName = (Split-Path $ProjectPath -Leaf).ToUpper()
        $claudeContent = Get-Content $claudeTemplate -Raw
        $claudeContent = $claudeContent -replace '\{\{PROJECT_NAME\}\}', $projectName
        $claudeContent = $claudeContent -replace '\{\{PROJECT_PATH\}\}', $ProjectPath
        $claudeContent = $claudeContent -replace '\{\{STACK\}\}', '(Update this with your project stack)'
        $claudeContent = $claudeContent -replace '\{\{COMMANDS\}\}', '(Update this with your project commands)'
        $claudeContent = $claudeContent -replace '\{\{NUCLEAR_INVARIANTS\}\}', '(Update this with your project nuclear invariants)'
        $claudeContent = $claudeContent -replace '\{\{KEY_PATHS\}\}', '(Update this with your project key paths)'

        Write-Utf8NoBom -Path $claudeFile -Content $claudeContent
        Write-Host "    [$claudeReason] Generated CLAUDE.md in project root" -ForegroundColor Green
        Write-Host "    NOTE: Edit CLAUDE.md to add project-specific details" -ForegroundColor Yellow
    }
}

# ── 7. Version sync verification (v2.4) ──────────────────────────────
Write-Host ""
Write-Host "  Version sync check..." -ForegroundColor White

$versionMismatches = 0
$criticalFiles = @(
    @{ Name = "NEO-BECCA";     Source = Join-Path $SourceRoles "NEO-BECCA.md";     Target = Join-Path $TargetNeo "roles\NEO-BECCA.md" },
    @{ Name = "NEO-ANT";       Source = Join-Path $SourceRoles "NEO-ANT.md";       Target = Join-Path $TargetNeo "roles\NEO-ANT.md" },
    @{ Name = "NEO-GHOST";     Source = Join-Path $SourceRoles "NEO-GHOST.md";     Target = Join-Path $TargetNeo "roles\NEO-GHOST.md" },
    @{ Name = "NEO-INSPECTOR"; Source = Join-Path $SourceRoles "NEO-INSPECTOR.md"; Target = Join-Path $TargetNeo "roles\NEO-INSPECTOR.md" },
    @{ Name = "NEO-HIVE";      Source = Join-Path $SourceShared "NEO-HIVE.md";     Target = Join-Path $TargetNeo "shared\NEO-HIVE.md" },
    @{ Name = "NEO-GATES";     Source = Join-Path $SourceShared "NEO-GATES.md";    Target = Join-Path $TargetNeo "shared\NEO-GATES.md" },
    @{ Name = "NEO-TOOLS";     Source = Join-Path $SourceShared "NEO-TOOLS.md";    Target = Join-Path $TargetNeo "shared\NEO-TOOLS.md" },
    @{ Name = "NEO-ACTIVATION"; Source = Join-Path $SourceShared "NEO-ACTIVATION.md"; Target = Join-Path $TargetNeo "shared\NEO-ACTIVATION.md" },
    @{ Name = "NEO-EVIDENCE"; Source = Join-Path $SourceShared "NEO-EVIDENCE.md"; Target = Join-Path $TargetNeo "shared\NEO-EVIDENCE.md" },
    @{ Name = "NEO-FIVE-HORSEMEN"; Source = Join-Path $SourceShared "NEO-FIVE-HORSEMEN.md"; Target = Join-Path $TargetNeo "shared\NEO-FIVE-HORSEMEN.md" }
)

foreach ($cf in $criticalFiles) {
    if ((Test-Path $cf.Source) -and (Test-Path $cf.Target)) {
        $srcVersion = Select-String -Path $cf.Source -Pattern '^\*\*Version:\*\*\s+(.+)' | Select-Object -First 1
        $tgtVersion = Select-String -Path $cf.Target -Pattern '^\*\*Version:\*\*\s+(.+)' | Select-Object -First 1

        if ($srcVersion -and $tgtVersion) {
            $sv = $srcVersion.Matches[0].Groups[1].Value.Trim()
            $tv = $tgtVersion.Matches[0].Groups[1].Value.Trim()

            if ($sv -ne $tv) {
                Write-Host "    [MISMATCH] $($cf.Name): source=$sv target=$tv" -ForegroundColor Red
                $versionMismatches++
            }
        }
    }
}

if ($versionMismatches -eq 0) {
    Write-Host "    All critical file versions in sync." -ForegroundColor DarkGray
} else {
    Write-Host "    WARNING: $versionMismatches version mismatch(es) detected!" -ForegroundColor Red
    Write-Host "    Files may not have synced correctly. Check file hashes." -ForegroundColor Red
}

# ── Summary ──────────────────────────────────────────────────────────
Write-Host ""
Write-Host "  SUMMARY:" -ForegroundColor Cyan
Write-Host "    Updated:  $totalUpdated file(s) ($totalNew new)" -ForegroundColor $(if ($totalUpdated -gt 0) { "Yellow" } else { "Green" })
Write-Host "    Skipped:  $totalSkipped file(s) (unchanged)" -ForegroundColor DarkGray
Write-Host "    Dirs:     $dirsCreated created" -ForegroundColor $(if ($dirsCreated -gt 0) { "Yellow" } else { "DarkGray" })
Write-Host "    Cards:    cards/ synced (33 protocol cards)" -ForegroundColor DarkGray
if ($hivemindMerged) {
    Write-Host "    Hivemind: MERGED - local BECCA additions preserved (promote to source manually)" -ForegroundColor Cyan
}
Write-Host "    Preserved: inbox, outbox, audit, archive, runtime, index, STATE.md, RUN_INDEX.md, TODO, CRITICAL_SURFACES.md" -ForegroundColor DarkGray
Write-Host ""

if ($DryRun -and ($totalUpdated -gt 0 -or $dirsCreated -gt 0)) {
    Write-Host "  Run without -DryRun to apply these changes." -ForegroundColor Yellow
    Write-Host ""
}
