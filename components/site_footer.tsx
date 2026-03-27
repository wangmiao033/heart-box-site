import Link from "next/link";
import { siteConfig } from "@/lib/site_config";

const columns = [
  {
    title: "产品",
    links: [
      { href: "/features", label: "功能介绍" },
      { href: "/screenshots", label: "产品截图" },
      { href: "/download", label: "下载 / 打开" },
    ],
  },
  {
    title: "支持",
    links: [
      { href: "/support", label: "用户支持" },
      { href: "/privacy", label: "隐私政策" },
      { href: "/terms", label: "服务条款" },
    ],
  },
];

export function SiteFooter() {
  const year = new Date().getFullYear();
  return (
    <footer className="site-footer">
      <div className="container site-footer__grid">
        <div className="site-footer__brand">
          <p className="site-footer__name">{siteConfig.name}</p>
          <p className="muted site-footer__tagline">{siteConfig.tagline}</p>
          <p className="site-footer__contact muted">
            联系：
            <a href={`mailto:${siteConfig.contactEmail}`}>
              {siteConfig.contactEmail}
            </a>
          </p>
        </div>
        {columns.map((col) => (
          <div key={col.title} className="site-footer__col">
            <p className="site-footer__col-title">{col.title}</p>
            <ul>
              {col.links.map((l) => (
                <li key={l.href}>
                  <Link href={l.href}>{l.label}</Link>
                </li>
              ))}
            </ul>
          </div>
        ))}
      </div>
      <div className="site-footer__bottom container">
        <p className="muted">
          © {year} {siteConfig.name}。保留所有权利。
        </p>
      </div>
    </footer>
  );
}
