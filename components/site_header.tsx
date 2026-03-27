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
    <header className="sticky top-0 z-50 border-b border-white/40 bg-page/65 backdrop-blur-xl supports-[backdrop-filter]:bg-page/55">
      <div className="mx-auto flex max-w-6xl items-center justify-between gap-4 px-5 py-3.5 md:px-8">
        <Link
          href="/"
          className="inline-flex items-center gap-2.5 rounded-2xl text-ink no-underline transition-opacity hover:opacity-85"
        >
          <img
            src="/logo.png"
            alt=""
            width={36}
            height={36}
            className="rounded-xl shadow-glass"
          />
          <span className="text-[15px] font-semibold tracking-tight">
            {siteConfig.name}
          </span>
        </Link>
        <nav className="text-[13px] md:text-sm" aria-label="主导航">
          <ul className="flex flex-wrap justify-end gap-x-4 gap-y-1 md:gap-x-6">
            {nav.map((item) => (
              <li key={item.href}>
                <Link
                  href={item.href}
                  className="text-sub no-underline transition-colors hover:text-brand"
                >
                  {item.label}
                </Link>
              </li>
            ))}
          </ul>
        </nav>
      </div>
    </header>
  );
}
