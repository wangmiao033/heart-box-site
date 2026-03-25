# 心事匣 (Heart Box)

本地心情日记 Flutter MVP，仓库：[heart-box-app](https://github.com/wangmiao033/heart-box-app)。

## 开发（桌面 / 手机）

```bash
flutter pub get
flutter run
```

首次使用 Flutter 可参考：[官方文档](https://docs.flutter.dev/get-started/install)。

---

## Web 端测试

工程已包含 `web/`，并使用 `sqflite_common_ffi_web` 在浏览器里初始化 SQLite，**可以专门用 Web 做界面与流程测试**。

### 1. 准备

```bash
flutter pub get
```

（若在国内网络拉包慢，可设置镜像后再执行，例如 `PUB_HOSTED_URL`、`FLUTTER_STORAGE_BASE_URL`。）

### 2. 调试运行（推荐先用这个）

在**项目根目录**执行其一：

```bash
# 启动本地 HTTP 服务，终端里会打印地址，用浏览器打开（如 http://localhost:xxxxx）
flutter run -d web-server

# 或直接调起 Chrome（若本机 Chrome 调试端口异常，可改用上一行）
flutter run -d chrome
```

### 3. 打 Web 包（验证能否发布构建）

```bash
flutter build web
```

产物在 **`build/web/`**，可用任意静态服务器打开该目录做联调（不要用 `file://` 直接打开 `index.html`，容易有路径问题）。

### 4. Web 上测试时要注意

| 能力 | Web 说明 |
|------|-----------|
| 列表 / 新建 / 搜索 / 日历 / 回顾 / 主题 | 可测，与逻辑一致 |
| 本地数据库 | 已接 WASM SQLite，数据在浏览器存储内 |
| 应用锁 / PIN / 生物识别 | 与桌面/手机**行为可能不同**，正式验收请以 **Windows / Android / iOS** 为准 |

**结论：可以测试。** 日常 Web 快速验 UI 用 `flutter run -d web-server` 即可；完整隐私与锁相关能力建议在原生目标上再验一遍。
