# 心事匣：国内网络下 Web 本地预览（自动设 Pub 镜像，避免直连 pub.dev 出现 socket 失败）
# 若你手动执行 flutter pub get 报错「Got socket error … pub.dev」，请直接运行本脚本，不要省略镜像环境变量。
# 用法（在资源管理器中右键「使用 PowerShell 运行」，或在终端执行）：
#   cd H:\heart-box-app
#   .\tool\build_and_serve_web.ps1
# 指定端口：
#   .\tool\build_and_serve_web.ps1 -Port 8090

param(
    [int]$Port = 8082
)

$ErrorActionPreference = "Stop"
$repo = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
Set-Location $repo

$env:PUB_HOSTED_URL = "https://pub.flutter-io.cn"
$env:FLUTTER_STORAGE_BASE_URL = "https://storage.flutter-io.cn"

Write-Host "==> flutter pub get" -ForegroundColor Cyan
flutter pub get
if ($LASTEXITCODE -ne 0) {
    Write-Host "pub get 失败：请检查网络或代理后再试。" -ForegroundColor Red
    exit $LASTEXITCODE
}

Write-Host "==> flutter build web --release --no-web-resources-cdn" -ForegroundColor Cyan
flutter build web --release --no-web-resources-cdn
if ($LASTEXITCODE -ne 0) {
    Write-Host "build web 失败：请看上方报错。" -ForegroundColor Red
    exit $LASTEXITCODE
}

Write-Host "==> 本地服务 http://127.0.0.1:$Port/ （Ctrl+C 停止）" -ForegroundColor Green
Write-Host "    若设置页仍显示「四季」大卡片：先停服务，再执行本脚本重新 build；或改 UI 时用 .\tool\dev_web.ps1（保存后按 r 刷新）" -ForegroundColor Yellow
python (Join-Path $repo "tool\serve_web.py") $Port
