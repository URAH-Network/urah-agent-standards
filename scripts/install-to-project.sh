#!/usr/bin/env bash
# ==============================================================================
# URAH NETWORK - Install Skills & Rules to a Target Project (Linux/macOS)
# ==============================================================================
set -euo pipefail

if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <target_project_path>"
    exit 1
fi

TARGET_PROJECT="$1"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

DEST_AGENTS="${TARGET_PROJECT}/.agents"

echo "🚀 [URAH NETWORK] Installing Agent Standards to ${DEST_AGENTS}..."

mkdir -p "${DEST_AGENTS}/skills"
mkdir -p "${DEST_AGENTS}/rules"

cp -r "${REPO_ROOT}/skills/backend-security-audit" "${DEST_AGENTS}/skills/"
cp -r "${REPO_ROOT}/skills/frontend-security-audit" "${DEST_AGENTS}/skills/"
cp -r "${REPO_ROOT}/skills/securevibes-audit" "${DEST_AGENTS}/skills/"
cp -r "${REPO_ROOT}/rules/"* "${DEST_AGENTS}/rules/"
cp "${REPO_ROOT}/GEMINI.md" "${DEST_AGENTS}/AGENTS.md"

echo "🎉 Done! Project ${TARGET_PROJECT} is now standardized with URAH Agent Standards."
