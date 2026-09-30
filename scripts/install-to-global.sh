#!/usr/bin/env bash
# ==============================================================================
# URAH NETWORK - Install Skills & Rules to Global Config (Linux/macOS)
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

DEST_DIR="${HOME}/.gemini"
SKILLS_DEST="${DEST_DIR}/config/skills"

echo "🚀 [URAH NETWORK] Installing Agent Standards & Skills to ${DEST_DIR}..."

mkdir -p "${SKILLS_DEST}"

# Copy skills
cp -r "${REPO_ROOT}/skills/backend-security-audit" "${SKILLS_DEST}/"
cp -r "${REPO_ROOT}/skills/frontend-security-audit" "${SKILLS_DEST}/"
cp -r "${REPO_ROOT}/skills/securevibes-audit" "${SKILLS_DEST}/"

# Copy global rules
if [ -f "${DEST_DIR}/GEMINI.md" ]; then
    cp "${DEST_DIR}/GEMINI.md" "${DEST_DIR}/GEMINI.md.bak_$(date +%Y%m%d_%H%M%S)"
fi
cp "${REPO_ROOT}/GEMINI.md" "${DEST_DIR}/GEMINI.md"

echo "🎉 Done! Global skills and rules successfully updated."
