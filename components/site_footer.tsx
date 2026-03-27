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
    <footer className="mt-auto border-t border-[rgba(214,167,122,0.1)] bg-gradient-to-b from-page to-page-soft">
      <div className="mx-auto grid max-w-6xl gap-12 px-5 py-16 md:grid-cols-[1.3fr_1fr_1fr] md:px-10 md:py-20">
        <div>
          <p className="text-base font-semibold text-ink">{siteConfig.name}</p>
          <p className="mt-3 text-sm leading-relaxed text-sub">{siteConfig.tagline}</p>
          <p className="mt-5 text-sm leading-relaxed text-sub">
            {siteConfig.officialSiteNote}
          </p>
          <p className="mt-5 text-sm text-ink/90">
            <span className="text-sub">公司：</span>
            {siteConfig.companyName}
          </p>
          <p className="mt-2 text-sm">
            <span className="text-sub">邮箱：</span>
            <a
              href={`mailto:${siteConfig.contactEmail}`}
              className="text-warm-deep no-underline hover:underline"
            >
              {siteConfig.contactEmail}
            </a>
          </p>
        </div>
        {columns.map((col) => (
          <div key={col.title}>
            <p className="text-[11px] font-medium uppercase tracking-[0.14em] text-sub">
              {col.title}
            </p>
            <ul className="mt-4 space-y-2.5 text-sm">
              {col.links.map((l) => (
                <li key={l.href}>
                  <Link
                    href={l.href}
                    className="text-ink/88 no-underline transition-colors hover:text-warm-deep"
                  >
                    {l.label}
                  </Link>
                </li>
              ))}
            </ul>
          </div>
        ))}
      </div>
      <div className="border-t border-[rgba(214,167,122,0.08)]">
        <div className="mx-auto flex max-w-6xl flex-col gap-2 px-5 py-7 text-xs text-sub md:flex-row md:items-center md:justify-between md:px-10">
          <p>
            <Link
              href="/privacy"
              className="text-warm-deep no-underline hover:underline"
            >
              隐私政策
            </Link>
          </p>
          <p>
            © {year} {siteConfig.companyName} · {siteConfig.name}
          </p>
        </div>
      </div>
    </footer>
  );
}
