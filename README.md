# heart-box-site（心事匣官网）

轻量、静态导出的产品介绍站，技术栈为 **Next.js 14（App Router）+ TypeScript**，默认 `output: 'export'`，适合部署在 **Vercel** 或任意静态托管。

## 本地开发

```bash
npm install
npm run placeholders   # 若缺少截图/logo/og 占位图时可选
npm run dev
```

构建静态产物：

```bash
npm run build
```

导出目录为 `out/`。若在本机 Windows 上因路径含中文等非 ASCII 字符出现 `readlink` / `EISDIR` 类错误，可尝试将仓库放在仅含英文的路径下构建，或直接在 Vercel 上构建（Linux 环境通常无此问题）。

## 环境变量

| 变量 | 说明 |
|------|------|
| `NEXT_PUBLIC_SITE_URL` | 正式站点根地址，无末尾斜杠，例如 `https://www.example.com`。用于 `metadataBase`、canonical、与 `lib/site_config.ts` 中的 `baseUrl` 一致。 |

部署前请同步修改 **`public/sitemap.xml`** 与 **`public/robots.txt`** 中的域名（当前占位为 `https://heart-box-site.vercel.app`），与实际上线地址一致。

## 仓库结构（摘要）

- `app/` — 页面与路由
- `components/` — 站点级 UI 组件
- `lib/` — `site_config.ts`（站点名、联系邮箱、下载链接）、`seo.ts`（metadata 辅助）
- `public/` — 静态资源、favicon、OG 图、截图目录
- `styles/globals.css` — 全局样式与设计 token
- `scripts/write-placeholders.mjs` — 生成本地占位 PNG（可选）

## 与 Flutter 主工程的关系

本目录为**独立官网仓库**，与 App 主仓库分离；仅通过你手动替换截图与文案保持品牌一致。
