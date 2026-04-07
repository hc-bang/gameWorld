# ─────────────────────────────────────────────────────
# 📦 게임 월드 — 로컬 개발 서버 실행 스크립트
# Purpose : Python HTTP Server를 이용하여 정적 파일을 서빙합니다.
# Usage   : .\.scripts\run-local.ps1
# Requires: Python 3.x
# Note    : Windows의 Microsoft Store python 가상 앨리어스를 우회하기 위해
#           py(Python Launcher) → python3 → python 순으로 실제 설치 여부를 검증합니다.
# ─────────────────────────────────────────────────────

# Python 실행 명령어 탐색: 실제로 버전 정보를 반환하는 명령만 신뢰
function Find-Python {
    foreach ($cmd in @("py", "python3", "python")) {
        if (Get-Command $cmd -ErrorAction SilentlyContinue) {
            $result = & $cmd --version 2>&1
            # 실제 Python 버전 정보가 출력되는지 확인 (MS Store 앨리어스는 실행 자체가 실패)
            if ($result -match "Python 3") {
                return $cmd
            }
        }
    }
    return $null
}

$pythonCmd = Find-Python

if (-not $pythonCmd) {
    Write-Host ""
    Write-Host "❌ Python 3.x를 찾을 수 없습니다." -ForegroundColor Red
    Write-Host ""
    Write-Host "   해결 방법:" -ForegroundColor Yellow
    Write-Host "   1. https://www.python.org/downloads 에서 Python 설치" -ForegroundColor White
    Write-Host "      (설치 시 'Add Python to PATH' 옵션 반드시 체크!)" -ForegroundColor DarkGray
    Write-Host "   2. 설치 후 새 PowerShell 창에서 다시 실행하세요." -ForegroundColor White
    Write-Host ""
    Write-Host "   ※ Windows 설정 > 앱 > 앱 실행 별칭에서 python 앨리어스를 비활성화하면" -ForegroundColor DarkGray
    Write-Host "      Microsoft Store 가상 명령어 충돌을 방지할 수 있습니다." -ForegroundColor DarkGray
    exit 1
}

Write-Host "✅ Python 실행기 확인됨: $pythonCmd ($(& $pythonCmd --version))" -ForegroundColor DarkGray

function Start-Server($port) {
    Write-Host ""
    Write-Host "🚀 게임 월드 로컬 서버를 포트 $port 에서 시작합니다..." -ForegroundColor Cyan
    Write-Host "🌐 브라우저에서 http://localhost:$port 로 접속하세요." -ForegroundColor Green
    Write-Host "   (종료: Ctrl+C)" -ForegroundColor DarkGray
    Write-Host ""
    & $pythonCmd -m http.server $port
    return $LASTEXITCODE
}

# 포트 80으로 먼저 시도 (관리자 권한 필요), 실패 시 8080 폴백
$exitCode = Start-Server 80
if ($exitCode -ne 0) {
    Write-Host ""
    Write-Host "⚠️  포트 80 실행 실패 (관리자 권한 필요). 포트 8080으로 재시도합니다..." -ForegroundColor Yellow
    Start-Server 8080
}
