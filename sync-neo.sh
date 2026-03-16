#!/usr/bin/env bash
# sync-neo.sh — One-way sync of NEO framework files to all governed projects.
# Source of truth: d:\projects\neo\ (roles/ + shared/)
# Syncs TO project locations. NEVER syncs project data back.
#
# Usage:
#   bash sync-neo.sh           # sync all projects
#   bash sync-neo.sh --dry-run # show what would change, don't copy
#   bash sync-neo.sh --add /d/projects/newproject/.neo  # add a project

set -euo pipefail

# ─── CONFIG ──────────────────────────────────────────────────────────
SOURCE="/d/projects/neo"
PROJECTS_FILE="$SOURCE/.sync-projects"

# Framework files — ONLY these get synced. Nothing else.
ROLES=(NEO-ANT.md NEO-BECCA.md NEO-GHOST.md NEO-INSPECTOR.md)
SHARED=(NEO-ACTIVATION.md NEO-EVIDENCE.md NEO-GATES.md NEO-HIVE.md
        NEO-HIVEMIND-GLOBAL.md NEO-OUTPUTS.md NEO-SURGICAL.md NEO-TOOLS.md)

# ─── COLORS ──────────────────────────────────────────────────────────
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# ─── INIT PROJECTS FILE ─────────────────────────────────────────────
if [ ! -f "$PROJECTS_FILE" ]; then
  cat > "$PROJECTS_FILE" << 'EOF'
# NEO Sync — Project Locations
# One path per line. Lines starting with # are ignored.
# Path must point to the project's .neo/ or neo/ directory.
# Add new projects here, then run: bash sync-neo.sh
/d/projects/sonny/.neo
/d/projects/iambecca/neo
EOF
  echo -e "${GREEN}Created $PROJECTS_FILE with default projects.${NC}"
fi

# ─── PARSE ARGS ──────────────────────────────────────────────────────
DRY_RUN=false
ADD_PROJECT=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --dry-run) DRY_RUN=true; shift ;;
    --add)     ADD_PROJECT="$2"; shift 2 ;;
    *)         echo -e "${RED}Unknown arg: $1${NC}"; exit 1 ;;
  esac
done

# ─── ADD PROJECT ─────────────────────────────────────────────────────
if [ -n "$ADD_PROJECT" ]; then
  if grep -qF "$ADD_PROJECT" "$PROJECTS_FILE" 2>/dev/null; then
    echo -e "${YELLOW}Already registered: $ADD_PROJECT${NC}"
  else
    echo "$ADD_PROJECT" >> "$PROJECTS_FILE"
    echo -e "${GREEN}Added: $ADD_PROJECT${NC}"
    echo -e "Run ${CYAN}bash sync-neo.sh${NC} to sync now."
  fi
  exit 0
fi

# ─── READ PROJECTS ───────────────────────────────────────────────────
PROJECTS=()
while IFS= read -r line; do
  line="${line#"${line%%[![:space:]]*}"}"  # trim leading whitespace
  line="${line%"${line##*[![:space:]]}"}"  # trim trailing whitespace
  [[ -z "$line" || "$line" == \#* ]] && continue
  PROJECTS+=("$line")
done < "$PROJECTS_FILE"

if [ ${#PROJECTS[@]} -eq 0 ]; then
  echo -e "${RED}No projects in $PROJECTS_FILE${NC}"
  exit 1
fi

# ─── SYNC ────────────────────────────────────────────────────────────
echo ""
echo -e "${CYAN}╔══════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║       NEO FRAMEWORK SYNC                 ║${NC}"
echo -e "${CYAN}║  Source: $SOURCE ${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════╝${NC}"
echo ""

if $DRY_RUN; then
  echo -e "${YELLOW}── DRY RUN (no files will be modified) ──${NC}"
  echo ""
fi

TOTAL_COPIED=0
TOTAL_SKIPPED=0
TOTAL_ERRORS=0

for PROJECT in "${PROJECTS[@]}"; do
  echo -e "${CYAN}━━━ $PROJECT ━━━${NC}"

  if [ ! -d "$PROJECT" ]; then
    echo -e "  ${RED}SKIP — directory does not exist${NC}"
    echo ""
    continue
  fi

  COPIED=0
  SKIPPED=0

  # Ensure subdirectories exist
  if ! $DRY_RUN; then
    mkdir -p "$PROJECT/roles" 2>/dev/null || true
    mkdir -p "$PROJECT/shared" 2>/dev/null || true
  fi

  # Sync roles
  for file in "${ROLES[@]}"; do
    src="$SOURCE/roles/$file"
    if [ ! -f "$src" ]; then
      echo -e "  ${RED}MISSING at source: roles/$file${NC}"
      TOTAL_ERRORS=$((TOTAL_ERRORS + 1))
      continue
    fi

    src_hash=$(md5sum "$src" | cut -d' ' -f1)
    changed=false

    # Copy to roles/ subdirectory
    dst="$PROJECT/roles/$file"
    if [ -f "$dst" ]; then
      dst_hash=$(md5sum "$dst" | cut -d' ' -f1)
      if [ "$src_hash" != "$dst_hash" ]; then
        changed=true
        old_ver=$(grep -m1 -oP 'Version[:\s*]*\K[0-9]+\.[0-9]+\.[0-9]+' "$dst" 2>/dev/null || echo "?")
        new_ver=$(grep -m1 -oP 'Version[:\s*]*\K[0-9]+\.[0-9]+\.[0-9]+' "$src" 2>/dev/null || echo "?")
        echo -e "  ${GREEN}UPDATE${NC} roles/$file  ${YELLOW}$old_ver → $new_ver${NC}"
        if ! $DRY_RUN; then cp "$src" "$dst"; fi
        COPIED=$((COPIED + 1))
      else
        SKIPPED=$((SKIPPED + 1))
      fi
    else
      changed=true
      new_ver=$(grep -m1 -oP 'Version[:\s*]*\K[0-9]+\.[0-9]+\.[0-9]+' "$src" 2>/dev/null || echo "?")
      echo -e "  ${GREEN}ADD${NC}    roles/$file  ${YELLOW}v$new_ver${NC}"
      if ! $DRY_RUN; then cp "$src" "$dst"; fi
      COPIED=$((COPIED + 1))
    fi
  done

  # Sync shared modules
  for file in "${SHARED[@]}"; do
    src="$SOURCE/shared/$file"
    if [ ! -f "$src" ]; then
      echo -e "  ${RED}MISSING at source: shared/$file${NC}"
      TOTAL_ERRORS=$((TOTAL_ERRORS + 1))
      continue
    fi

    src_hash=$(md5sum "$src" | cut -d' ' -f1)

    # Copy to shared/ subdirectory
    dst="$PROJECT/shared/$file"
    if [ -f "$dst" ]; then
      dst_hash=$(md5sum "$dst" | cut -d' ' -f1)
      if [ "$src_hash" != "$dst_hash" ]; then
        old_ver=$(grep -m1 -oP 'Version[:\s*]*\K[0-9]+\.[0-9]+\.[0-9]+' "$dst" 2>/dev/null || echo "?")
        new_ver=$(grep -m1 -oP 'Version[:\s*]*\K[0-9]+\.[0-9]+\.[0-9]+' "$src" 2>/dev/null || echo "?")
        echo -e "  ${GREEN}UPDATE${NC} shared/$file  ${YELLOW}$old_ver → $new_ver${NC}"
        if ! $DRY_RUN; then cp "$src" "$dst"; fi
        COPIED=$((COPIED + 1))
      else
        SKIPPED=$((SKIPPED + 1))
      fi
    else
      new_ver=$(grep -m1 -oP 'Version[:\s*]*\K[0-9]+\.[0-9]+\.[0-9]+' "$src" 2>/dev/null || echo "?")
      echo -e "  ${GREEN}ADD${NC}    shared/$file  ${YELLOW}v$new_ver${NC}"
      if ! $DRY_RUN; then cp "$src" "$dst"; fi
      COPIED=$((COPIED + 1))
    fi

  done

  if [ $COPIED -eq 0 ]; then
    echo -e "  ${GREEN}All $SKIPPED files already current ✅${NC}"
  else
    echo -e "  ${GREEN}$COPIED updated${NC}, $SKIPPED already current"
  fi
  echo ""

  TOTAL_COPIED=$((TOTAL_COPIED + COPIED))
  TOTAL_SKIPPED=$((TOTAL_SKIPPED + SKIPPED))
done

# ─── SUMMARY ─────────────────────────────────────────────────────────
echo -e "${CYAN}══════════════════════════════════════════${NC}"
if [ $TOTAL_COPIED -eq 0 ] && [ $TOTAL_ERRORS -eq 0 ]; then
  echo -e "${GREEN}ALL PROJECTS IN SYNC ✅${NC}"
elif [ $TOTAL_ERRORS -gt 0 ]; then
  echo -e "${RED}$TOTAL_ERRORS errors | ${GREEN}$TOTAL_COPIED copied | $TOTAL_SKIPPED unchanged${NC}"
else
  echo -e "${GREEN}$TOTAL_COPIED files synced | $TOTAL_SKIPPED unchanged${NC}"
fi

if $DRY_RUN; then
  echo -e "${YELLOW}(dry run — no files were modified)${NC}"
fi

echo -e "${CYAN}Projects: ${#PROJECTS[@]} | Roles: ${#ROLES[@]} | Shared: ${#SHARED[@]}${NC}"
echo ""