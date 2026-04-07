# Purpose: Start the static web server for Game World
# Usage: .\.scripts\run-local.ps1
# Requires: Python 3.x

$port = 80
Write-Host "Starting Game World Local Server on Port $port..." -ForegroundColor Cyan
Write-Host "Please open your browser and navigate to http://localhost/" -ForegroundColor Green

python -m http.server $port
