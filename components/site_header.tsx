import Link from "next/link";
import { siteConfig } from "@/lib/site_config";

const nav = [
  { href: "/features", label: "功能介绍" },
  { href: "/screenshots", label: "产品截图" },
  { href: "/download", label: "下载" },
  { href: "/support", label: "用户支持" },
];

export function SiteHeader() {
  return (
    <header className="site-header">
      <div className="container site-header__inner">
        <Link href="/" className="site-header__brand">
          <img
            src="/logo.png"
            alt=""
            width={36}
            height={36}
            className="site-header__logo"
          />
          <span className="site-header__name">{siteConfig.name}</span>
        </Link>
        <nav className="site-header__nav" aria-label="主导航">
          <ul>
            {nav.map((item) => (
              <li key={item.href}>
                <Link href={item.href}>{item.label}</Link>
              </li>
            ))}
          </ul>
        </nav>
      </div>
    </header>
  );
}
