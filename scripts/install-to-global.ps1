# ==============================================================================
# URAH NETWORK - Cài đặt Skills & Rules vào Global Config của Máy Cá Nhân
# Hỗ trợ: Antigravity IDE / Gemini Code Assist
# ==============================================================================

[CmdletBinding()]
param (
    [switch]$Force = $false
)

$ErrorActionPreference = "Stop"

Write-Host "==============================================================================" -ForegroundColor Cyan
Write-Host "🚀 [URAH NETWORK] BẮT ĐẦU CÀI ĐẶT AGENT STANDARDS & SECURITY SKILLS TO GLOBAL" -ForegroundColor Cyan
Write-Host "==============================================================================" -ForegroundColor Cyan

$userHome = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::UserProfile)
$globalGeminiDir = Join-Path $userHome ".gemini"
$globalConfigDir = Join-Path $globalGeminiDir "config"
$globalSkillsDir = Join-Path $globalConfigDir "skills"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$sourceSkillsDir = Join-Path $repoRoot "skills"
$sourceGeminiMd = Join-Path $repoRoot "GEMINI.md"

# 1. Đảm bảo thư mục tồn tại
if (-not (Test-Path $globalSkillsDir)) {
    New-Item -ItemType Directory -Path $globalSkillsDir -Force | Out-Null
    Write-Host "📁 Đã tạo thư mục: $globalSkillsDir" -ForegroundColor Yellow
}

# 2. Sao chép Skills
$skills = @("backend-security-audit", "frontend-security-audit", "securevibes-audit")
foreach ($skill in $skills) {
    $srcPath = Join-Path $sourceSkillsDir $skill
    $destPath = Join-Path $globalSkillsDir $skill
    if (Test-Path $srcPath) {
        Copy-Item -Path $srcPath -Destination $globalSkillsDir -Recurse -Force
        Write-Host "✅ Đã cài đặt Skill: $skill -> $destPath" -ForegroundColor Green
    } else {
        Write-Host "⚠️ Không tìm thấy skill nguồn: $srcPath" -ForegroundColor Red
    }
}

# 3. Đồng bộ file Rule Global (GEMINI.md)
$destGeminiMd = Join-Path $globalGeminiDir "GEMINI.md"
if (Test-Path $sourceGeminiMd) {
    if ((Test-Path $destGeminiMd) -and (-not $Force)) {
        $backupPath = Join-Path $globalGeminiDir "GEMINI.md.bak_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
        Copy-Item -Path $destGeminiMd -Destination $backupPath -Force
        Write-Host "💾 Đã tạo bản sao lưu quy tắc cũ: $backupPath" -ForegroundColor Yellow
    }
    Copy-Item -Path $sourceGeminiMd -Destination $destGeminiMd -Force
    Write-Host "✅ Đã cập nhật Global Rules: $destGeminiMd" -ForegroundColor Green
}

Write-Host "`n🎉 [HOÀN TẤT] Hệ thống đã sẵn sàng! Mọi Agent trong IDE sẽ tự động nhận diện:" -ForegroundColor Cyan
Write-Host "   • Skill: backend-security-audit" -ForegroundColor White
Write-Host "   • Skill: frontend-security-audit" -ForegroundColor White
Write-Host "   • Global Rules: GEMINI.md (Architecture, Security, Code Quality)" -ForegroundColor White
