# ==============================================================================
# URAH NETWORK - Bộ quét Tĩnh An Ninh Mã Nguồn (Automated SAST Grep Scanner)
# Tuân thủ: OWASP API Security Top 10 (2023), OWASP LLM (2025), CWE Top Risks
# ==============================================================================

[CmdletBinding()]
param (
    [Parameter(Position = 0)]
    [string]$TargetDir = ".",

    [switch]$SecureVibes = $false
)

$targetPath = (Resolve-Path $TargetDir).Path
Write-Host "==============================================================================" -ForegroundColor Cyan
Write-Host "🔍 [URAH NETWORK] BẮT ĐẦU QUÉT BẢO MẬT MÃ NGUỒN TẠI: $targetPath" -ForegroundColor Cyan
Write-Host "==============================================================================" -ForegroundColor Cyan

$issuesCount = 0

function Scan-Pattern {
    param (
        [string]$Category,
        [string]$Description,
        [string]$Pattern,
        [string]$SearchSubDir,
        [string]$Includes = "*.ts,*.tsx,*.js,*.jsx"
    )

    $searchPath = Join-Path $targetPath $SearchSubDir
    if (-not (Test-Path $searchPath)) {
        return
    }

    $includeList = $Includes.Split(',')
    $results = Get-ChildItem -Path $searchPath -Recurse -File -Include $includeList -ErrorAction SilentlyContinue |
        Where-Object { $_.FullName -notmatch "node_modules|\.next|dist|coverage|build|\.git" } |
        Select-String -Pattern $Pattern

    if ($results) {
        $count = $results.Count
        $script:issuesCount += $count
        Write-Host "`n⚠️ [$Category] ${Description} (Phát hiện: $count vị trí)" -ForegroundColor Red
        $results | Select-Object -First 5 | ForEach-Object {
            $relPath = Resolve-Path -Relative $_.Path
            Write-Host "   ${relPath}:$($_.LineNumber): $($_.Line.Trim())" -ForegroundColor Yellow
        }
        if ($count -gt 5) {
            Write-Host "   ... và $($count - 5) kết quả khác." -ForegroundColor Gray
        }
    } else {
        Write-Host "✅ [$Category] ${Description}: Không phát hiện vi phạm." -ForegroundColor Green
    }
}

Write-Host "`n--- [1. QUÉT AN NINH BACKEND] ---" -ForegroundColor Magenta
Scan-Pattern -Category "CWE-330" -Description "Sinh Token/OTP ngẫu nhiên yếu (Math.random)" -Pattern 'Math\.random\(' -SearchSubDir "backend"
Scan-Pattern -Category "API3:2023" -Description "Mass Assignment / Thiếu Class DTO (@Body body: any)" -Pattern '@Body\(\)\s+[a-zA-Z0-9_]+\s*:\s*(any|\{[^}]*\})' -SearchSubDir "backend"
Scan-Pattern -Category "CWE-22" -Description "Nguy cơ Path Traversal (path.join với user input thô)" -Pattern 'path\.(join|resolve)\([^,\n]+,\s*(req\.|body\.|query\.|params\.)' -SearchSubDir "backend"
Scan-Pattern -Category "API7:2023" -Description "CORS mở toàn bộ (*)" -Pattern 'origin\s*:\s*(\*|true|[''"]\*[''"])' -SearchSubDir "backend"

Write-Host "`n--- [2. QUÉT AN NINH FRONTEND] ---" -ForegroundColor Magenta
Scan-Pattern -Category "CWE-522" -Description "Rò rỉ lưu JWT Token vào LocalStorage" -Pattern 'localStorage\.setItem\([''"](token|accessToken|jwt|auth)' -SearchSubDir "frontend"
Scan-Pattern -Category "CWE-79" -Description "Nguy cơ DOM XSS (dangerouslySetInnerHTML)" -Pattern 'dangerouslySetInnerHTML' -SearchSubDir "frontend"
Scan-Pattern -Category "CWE-200" -Description "Rò rỉ Secret Key trong biến môi trường Client" -Pattern 'NEXT_PUBLIC_(SECRET|KEY|PRIVATE|TOKEN|PASSWORD)' -SearchSubDir "frontend"
Scan-Pattern -Category "CWE-1022" -Description "Reverse Tabnabbing (target=_blank thiếu noopener)" -Pattern 'target=[''"]_blank[''"](?!.*noopener)' -SearchSubDir "frontend"
Scan-Pattern -Category "CWE-601" -Description "Open Redirect không kiểm tra URL nội bộ" -Pattern 'window\.location\.href\s*=\s*(router\.query|searchParams|redirect)' -SearchSubDir "frontend"

if ($SecureVibes) {
    Write-Host "`n--- [3. CHẠY KIỂM THỬ ĐA TÁC TỬ SECUREVIBES (5-PASS PIPELINE)] ---" -ForegroundColor Magenta
    $securevibesCmd = Get-Command "securevibes" -ErrorAction SilentlyContinue
    if ($securevibesCmd) {
        Write-Host "🚀 Đang khởi chạy SecureVibes CLI..." -ForegroundColor Yellow
        Push-Location $targetPath
        try {
            securevibes scan .
            Write-Host "✅ Hoàn tất! Báo cáo chi tiết đã được tạo tại: $targetPath\.securevibes\scan_report.md" -ForegroundColor Green
        } finally {
            Pop-Location
        }
    } else {
        Write-Host "⚠️ Chưa tìm thấy công cụ 'securevibes' trên máy." -ForegroundColor Yellow
        Write-Host "   Cài đặt nhanh bằng lệnh: pip install securevibes" -ForegroundColor Cyan
        Write-Host "   Hoặc sử dụng AI Agent với Skill 'securevibes-audit' để thực hiện quy trình 5-pass tự động." -ForegroundColor White
    }
}

Write-Host "`n==============================================================================" -ForegroundColor Cyan
if ($issuesCount -eq 0) {
    Write-Host "🎉 CHÚC MỪNG: Không phát hiện lỗi an ninh phổ biến nào trong mã nguồn!" -ForegroundColor Green
} else {
    Write-Host "⚠️ TỔNG KẾT: Phát hiện $issuesCount cảnh báo an ninh cần rà soát và khắc phục." -ForegroundColor Red
}
Write-Host "==============================================================================" -ForegroundColor Cyan
