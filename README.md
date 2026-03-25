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

---

## 用 Vercel 临时在线测（固定网址）

可以，**有一个稳定的 `https://xxx.vercel.app` 比本机端口更方便给别人打开**；但要满足两点，否则会像你遇到的 **404**：

1. **线上必须是 Flutter 打出来的 Web 包**（`build/web/` 里的 `index.html`、`main.dart.js`、`assets/` 等），不能只把 **Dart 源码**当静态站部署。  
2. **前端路由**（`go_router`）需要让所有「非静态文件」回退到 `index.html`，仓库根目录已提供 **`vercel.json`**。

### 推荐流程（本地构建 + 上传 `build/web`）

在项目根目录：

```bash
flutter build web
```

把 **`vercel.json` 复制到 `build/web/`**（与 `index.html` 同级），例如 PowerShell：

```powershell
Copy-Item vercel.json build\web\vercel.json
cd build\web
npx vercel --prod
```

（需已安装 Node 以便 `npx vercel`，或安装 [Vercel CLI](https://vercel.com/docs/cli) 后执行 `vercel --prod`。）

### 若用 GitHub 连接 Vercel

默认环境 **没有 Flutter**，一般不会自动执行 `flutter build web`。要么：

- 用上面的方式 **本地 build 后只部署 `build/web`**，要么  
- 在仓库里加 **GitHub Actions**（安装 Flutter → `build web` → 再推到 Vercel），需要配置 `VERCEL_TOKEN` 等，比本地部署多一步。

**总结：** 用 Vercel 测可以、也更「稳定」给别人发链接；**当前 404** 多半是 **没部署 `build/web` 或缺少 SPA 配置**。按上面复制 `vercel.json` 到 `build/web` 再部署即可。
