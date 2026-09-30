# ==============================================================================
# URAH NETWORK - Cài đặt Skills & Rules vào thư mục .agents của Dự án cụ thể
# ==============================================================================

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$TargetProject
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $TargetProject)) {
    Write-Error "❌ Đường dẫn dự án không tồn tại: $TargetProject"
}

$targetFullPath = (Resolve-Path $TargetProject).Path
Write-Host "==============================================================================" -ForegroundColor Cyan
Write-Host "🚀 [URAH NETWORK] CÀI ĐẶT AGENT STANDARDS CHO DỰ ÁN: $targetFullPath" -ForegroundColor Cyan
Write-Host "==============================================================================" -ForegroundColor Cyan

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$sourceAgentsDir = Join-Path $repoRoot ".agents"

$targetAgentsDir = Join-Path $targetFullPath ".agents"
$targetSkillsDir = Join-Path $targetAgentsDir "skills"
$targetRulesDir = Join-Path $targetAgentsDir "rules"

# 1. Tạo các thư mục đích
New-Item -ItemType Directory -Path $targetSkillsDir, $targetRulesDir -Force | Out-Null

# 2. Sao chép Skills
$skills = @("backend-security-audit", "frontend-security-audit", "securevibes-audit")
foreach ($skill in $skills) {
    $srcSkill = Join-Path (Join-Path $sourceAgentsDir "skills") $skill
    if (Test-Path $srcSkill) {
        Copy-Item -Path $srcSkill -Destination $targetSkillsDir -Recurse -Force
        Write-Host "✅ Đã đồng bộ Skill: $skill -> $targetSkillsDir\$skill" -ForegroundColor Green
    }
}

# 3. Sao chép Modular Rules
$srcRules = Join-Path $sourceAgentsDir "rules"
if (Test-Path $srcRules) {
    Copy-Item -Path (Join-Path $srcRules "*") -Destination $targetRulesDir -Force
    Write-Host "✅ Đã đồng bộ Rules -> $targetRulesDir" -ForegroundColor Green
}

# 4. Sao chép AGENTS.md
$srcAgentsMd = Join-Path $sourceAgentsDir "AGENTS.md"
if (Test-Path $srcAgentsMd) {
    Copy-Item -Path $srcAgentsMd -Destination (Join-Path $targetAgentsDir "AGENTS.md") -Force
    Write-Host "✅ Đã đồng bộ Workspace AGENTS.md" -ForegroundColor Green
}

Write-Host "`n🎉 [HOÀN TẤT] Dự án $targetFullPath đã được chuẩn hóa với bộ Agent Standards của URAH Network!" -ForegroundColor Cyan
