# Repair: pub get + flutter build web (China pub mirror). No flutter clean.
# Run from repo root:  .\tool\repair_web_build.ps1
# If build folder is locked: close Chrome tabs on localhost, stop python serve, kill dart.exe, retry.

$ErrorActionPreference = "Stop"
$repo = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
Set-Location $repo

$env:PUB_HOSTED_URL = "https://pub.flutter-io.cn"
$env:FLUTTER_STORAGE_BASE_URL = "https://storage.flutter-io.cn"

Write-Host ""
Write-Host "Using pub mirror: pub.flutter-io.cn (keep these env vars in this window)" -ForegroundColor Cyan
Write-Host ""

Write-Host "==> flutter pub get" -ForegroundColor Cyan
flutter pub get
if ($LASTEXITCODE -ne 0) {
    Write-Host "pub get failed: check proxy/VPN/firewall or try mobile hotspot." -ForegroundColor Red
    exit $LASTEXITCODE
}

Write-Host "==> flutter build web --release --no-web-resources-cdn" -ForegroundColor Cyan
flutter build web --release --no-web-resources-cdn
if ($LASTEXITCODE -ne 0) {
    Write-Host "build failed: see errors above." -ForegroundColor Red
    exit $LASTEXITCODE
}

$index = Join-Path $repo "build\web\index.html"
if (-not (Test-Path $index)) {
    Write-Host "Missing build\web\index.html - paste full build log." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "OK. Start preview:" -ForegroundColor Green
Write-Host "  python tool\serve_web.py 8082" -ForegroundColor Yellow
Write-Host "  Open: " -NoNewline -ForegroundColor Yellow
Write-Host 'http://127.0.0.1:8082/#/home' -ForegroundColor Yellow
Write-Host ""
