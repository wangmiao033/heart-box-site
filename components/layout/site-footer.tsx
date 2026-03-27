import Link from "next/link";
import { siteConfig } from "@/lib/site_config";

const productLinks = [
  { href: "/product", label: "产品介绍" },
  { href: "/download", label: "下载" },
  { href: "/notes", label: "心事展示" },
];

const legalLinks = [
  { href: "/privacy", label: "隐私政策" },
  { href: "/support", label: "用户支持" },
  { href: "/terms", label: "服务条款" },
];

export function SiteFooter() {
  const year = new Date().getFullYear();
  return (
    <footer className="mt-auto border-t border-line bg-page-elevated/50">
      <div className="mx-auto grid max-w-6xl gap-12 px-5 py-16 md:grid-cols-[1.2fr_1fr_1fr] md:px-10 md:py-20">
        <div>
          <p className="text-base font-semibold text-ink">{siteConfig.name}</p>
          <p className="mt-3 text-sm leading-relaxed text-sub">
            {siteConfig.tagline}
          </p>
          <p className="mt-4 text-sm leading-relaxed text-sub">
            {siteConfig.officialSiteNote}
          </p>
          <p className="mt-5 text-sm text-ink">
            <span className="text-sub">公司：</span>
            {siteConfig.companyName}
          </p>
          <p className="mt-2 text-sm">
            <span className="text-sub">邮箱：</span>
            <a
              href={`mailto:${siteConfig.contactEmail}`}
              className="rounded text-ink underline-offset-4 hover:underline focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-accent"
            >
              {siteConfig.contactEmail}
            </a>
          </p>
        </div>
        <div>
          <p className="text-[11px] font-medium uppercase tracking-[0.14em] text-sub">
            导航
          </p>
          <ul className="mt-4 space-y-2.5 text-sm">
            {productLinks.map((l) => (
              <li key={l.href}>
                <Link
                  href={l.href}
                  className="rounded text-ink/90 no-underline transition-opacity hover:opacity-70 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-accent"
                >
                  {l.label}
                </Link>
              </li>
            ))}
          </ul>
        </div>
        <div>
          <p className="text-[11px] font-medium uppercase tracking-[0.14em] text-sub">
            支持
          </p>
          <ul className="mt-4 space-y-2.5 text-sm">
            {legalLinks.map((l) => (
              <li key={l.href}>
                <Link
                  href={l.href}
                  className="rounded text-ink/90 no-underline transition-opacity hover:opacity-70 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-accent"
                >
                  {l.label}
                </Link>
              </li>
            ))}
          </ul>
        </div>
      </div>
      <div className="border-t border-line/70">
        <div className="mx-auto flex max-w-6xl flex-col gap-2 px-5 py-6 text-xs text-sub md:flex-row md:items-center md:justify-between md:px-10">
          <p>
            © {year} {siteConfig.companyName}
          </p>
          <p>{siteConfig.name} · 官方网站</p>
        </div>
      </div>
    </footer>
  );
}
