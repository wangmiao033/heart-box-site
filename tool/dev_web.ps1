# 心事匣 Web 开发模式（改界面用这个，比 release + python 更容易看到最新代码）
#
# 用法（在仓库根目录）：
#   .\tool\dev_web.ps1
# 指定端口：
#   .\tool\dev_web.ps1 -Port 8090
#
# 浏览器打开终端里提示的地址（默认 http://127.0.0.1:8082/）。
# 修改 lib 下 .dart 并保存后，在本终端窗口按：
#   r  → 热重载（Hot reload）
#   R  → 热重启（Hot restart，更彻底）
#
# 若仍像「没更新」：先按 R，再浏览器 Ctrl+Shift+R。
#
# 与 build_and_serve_web.ps1 区别：
#   - 本脚本：debug + 内置服务，适合日常改 UI
#   - 另一脚本：release + python 静态服务，接近线上表现

param(
    [int]$Port = 8082
)

$ErrorActionPreference = "Stop"
$repo = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
Set-Location $repo

$env:PUB_HOSTED_URL = "https://pub.flutter-io.cn"
$env:FLUTTER_STORAGE_BASE_URL = "https://storage.flutter-io.cn"

Write-Host ""
Write-Host "==> 开发 Web：http://127.0.0.1:$Port/" -ForegroundColor Green
Write-Host "    保存代码后在此窗口按  r  热重载，按  R  热重启（比反复 flutter build web 快）" -ForegroundColor Cyan
Write-Host ""

flutter run -d web-server `
    --web-port=$Port `
    --web-hostname=127.0.0.1 `
    --no-web-resources-cdn
