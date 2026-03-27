/**
 * 上线前请将 baseUrl 改为正式域名（用于 OG、sitemap、robots）。
 */
export const siteConfig = {
  name: "心事匣",
  tagline: "轻量、安静的心情日记",
  description:
    "心事匣是一款轻量的心情日记应用，帮你写下此刻、用日历回看、安心保存草稿与回忆。",
  baseUrl: process.env.NEXT_PUBLIC_SITE_URL ?? "https://heart-box-site.vercel.app",
  contactEmail: "pingce@dxyx6888.com",
  companyName: "广州熊动科技有限公司",
  officialSiteNote: "本网站为「心事匣」产品官方网站",
  /** 应用商店或 Web 入口，暂无则留空，页面会显示「即将推出」类说明 */
  download: {
    iosUrl: "" as string,
    androidUrl: "" as string,
    webUrl: "" as string,
  },
} as const;
