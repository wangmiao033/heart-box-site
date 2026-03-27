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

#### 若出现白屏：先确认 `build` 有没有真正成功

终端里若出现 **`Got socket error trying to find package sqflite at https://pub.dev`**、**`Failed to update packages`**，说明 **`flutter build web` 时依赖没拉全**，`build/web` 可能不完整 → **页面白、DevTools Console 一条红错**。

**解决：** 构建前务必设置镜像再 `pub get`（与上文「准备」一致），或使用一键脚本（自动设镜像并依次执行 get / build / 本地服务）：

```powershell
cd H:\heart-box-app
.\tool\build_and_serve_web.ps1
```

成功后浏览器打开 **`http://127.0.0.1:8082`**。不要用 `view-source:`；若仍异常，按 F12 看 **Console** 全文。

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

### 仍 404：GitHub 连 Vercel 时默认不会跑 `flutter build web`

只把代码推到 GitHub、让 Vercel「自动部署」，**不会**生成 `build/web`，线上就没有真正的 Web 包 → **404**。

仓库已包含 **GitHub Actions**（`.github/workflows/deploy-vercel-web.yml`）：在云端 `flutter build web` 后把 **`build/web`** 部署到 Vercel。

**你需要做的：**

1. **Vercel** → Account Settings → **Tokens**，新建并复制 **Token**。  
2. 在本机项目根目录执行一次（需已 [安装 Vercel CLI](https://vercel.com/docs/cli) 并已登录）：
   ```bash
   vercel link
   ```
   选现有项目 `heart-box-app`，完成后打开 **`.vercel/project.json`**，里面有 **`projectId`** 和 **`orgId`**。  
3. 打开 GitHub 仓库 → **Settings → Secrets and variables → Actions → New repository secret**，添加：

   | Name | 值 |
   |------|-----|
   | `VERCEL_TOKEN` | 步骤 1 的 Token |
   | `VERCEL_ORG_ID` | `project.json` 里的 `orgId` |
   | `VERCEL_PROJECT_ID` | `project.json` 里的 `projectId` |

4. **避免重复部署**：在 Vercel 该项目 → **Settings → Git** → **Ignored Build Step**，命令填 **`exit 1`**（让 Vercel **不要**对每次 push 自己做一次无效构建）；**真正上线只走 GitHub Actions**。

5. 推送任意提交到 `main`，或到 GitHub **Actions** 里手动 **Run workflow**。成功后刷新 `heart-box-app.vercel.app`。

`.vercel/` 已写入 `.gitignore`，请勿把 Token 提交进仓库。
