#!/usr/bin/env python3
"""
本地预览 build/web：
- 只监听 127.0.0.1，避免 [::] 与浏览器访问 127.0.0.1 不一致
- 为 .wasm 设置 application/wasm
- 所有响应加 Cache-Control: no-store，避免浏览器沿用旧的 main.dart.js（Flutter 脚本 URL 无版本号，易强缓存）

注意：不再默认加 COOP/COEP。加「Cross-Origin-Embedder-Policy: require-corp」时，
若资源未带 CORP，CanvasKit/脚本可能被拦，出现有 flutter-view 但整页空白、Console 一条红错。

用法（在仓库根目录）：
  flutter build web --release --no-web-resources-cdn
  python tool/serve_web.py 8082
"""
from __future__ import annotations

import http.server
import mimetypes
import os
import sys
import time

mimetypes.add_type("application/wasm", ".wasm")


class Handler(http.server.SimpleHTTPRequestHandler):
    def end_headers(self) -> None:
        self.send_header("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0")
        self.send_header("Pragma", "no-cache")
        super().end_headers()


def _parse_port(argv: list[str]) -> int:
    """容错：PowerShell 误粘成 `8082)` 时仍能解析端口。"""
    if len(argv) < 2:
        return 8082
    digits = "".join(c for c in argv[1] if c.isdigit())
    return int(digits) if digits else 8082


def main() -> None:
    repo = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
    web_root = os.path.join(repo, "build", "web")
    index = os.path.join(web_root, "index.html")
    if not os.path.isfile(index):
        print(f"未找到: {index}")
        print("请先执行: flutter build web --release --no-web-resources-cdn")
        sys.exit(1)
    os.chdir(web_root)
    port = _parse_port(sys.argv)
    httpd = http.server.HTTPServer(("127.0.0.1", port), Handler)
    print(f"静态根目录: {os.path.abspath('.')}")
    js = os.path.join(os.path.abspath("."), "main.dart.js")
    if os.path.isfile(js):
        mtime = os.path.getmtime(js)
        print(f"main.dart.js 生成时间: {time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(mtime))}")
    print(f"已启动: http://127.0.0.1:{port}/")
    print("若设置里仍出现「主题氛围 / 四季」大卡片：① 确认本脚本所在仓库已执行 flutter build web；② Chrome → F12 → Application → 清除本站数据；③ 再 Ctrl+Shift+R。")
    print("若仍白屏/仍见旧报错：Chrome 按 Ctrl+Shift+R；或 F12 → Application → 清除本站数据。")
    print("也可改用: flutter run -d web-server")
    httpd.serve_forever()


if __name__ == "__main__":
    main()
