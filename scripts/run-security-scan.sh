#!/usr/bin/env bash
# ==============================================================================
# URAH NETWORK - Automated SAST Grep Scanner (Linux/macOS)
# ==============================================================================
set -euo pipefail

TARGET_DIR="${1:-.}"
echo "=============================================================================="
echo "🔍 [URAH NETWORK] RUNNING SECURITY SCAN AT: ${TARGET_DIR}"
echo "=============================================================================="

echo "--- [1. BACKEND CHECKS] ---"
if [ -d "${TARGET_DIR}/backend" ]; then
    echo "• Checking Weak Tokens (Math.random)..."
    grep -rnE "Math\.random\(" "${TARGET_DIR}/backend/src" || echo "  ✅ Clean"

    echo "• Checking Mass Assignment / Unsafe Body..."
    grep -rnE "@Body\(\)\s+[a-zA-Z0-9_]+\s*:\s*(any|\{[^}]*\})" "${TARGET_DIR}/backend/src" || echo "  ✅ Clean"

    echo "• Checking Path Traversal..."
    grep -rnE "path\.(join|resolve)\([^,\n]+,\s*(req\.|body\.|query\.|params\.)" "${TARGET_DIR}/backend/src" || echo "  ✅ Clean"

    echo "• Checking Wildcard CORS..."
    grep -rnE "origin\s*:\s*(\*|true|['\"]\*(['\"]))" "${TARGET_DIR}/backend/src" || echo "  ✅ Clean"
fi

echo -e "\n--- [2. FRONTEND CHECKS] ---"
if [ -d "${TARGET_DIR}/frontend" ]; then
    echo "• Checking LocalStorage Token Storage (CWE-522)..."
    grep -rnE "localStorage\.setItem\(['\"](token|accessToken|jwt|auth)" "${TARGET_DIR}/frontend/src" || echo "  ✅ Clean"

    echo "• Checking DOM XSS (dangerouslySetInnerHTML)..."
    grep -rnE "dangerouslySetInnerHTML" "${TARGET_DIR}/frontend/src" || echo "  ✅ Clean"

    echo "• Checking Client Leaked Secrets..."
    grep -rnE "NEXT_PUBLIC_(SECRET|KEY|PRIVATE|TOKEN|PASSWORD)" "${TARGET_DIR}/frontend" || echo "  ✅ Clean"

    echo "• Checking Reverse Tabnabbing..."
    grep -rnE "target=['\"]_blank['\"](?!.*noopener)" "${TARGET_DIR}/frontend/src" || echo "  ✅ Clean"

    echo "• Checking Open Redirect..."
    grep -rnE "window\.location\.href\s*=\s*(router\.query|searchParams|redirect)" "${TARGET_DIR}/frontend/src" || echo "  ✅ Clean"
fi

echo "=============================================================================="
echo "🎉 Scan complete."
