"use client";

import Image from "next/image";
import Link from "next/link";
import { useEffect, useState } from "react";
import { siteConfig } from "@/lib/site_config";
import { cn } from "@/lib/utils/cn";

const nav = [
  { href: "/", label: "首页" },
  { href: "/product", label: "产品" },
  { href: "/download", label: "下载" },
  { href: "/notes", label: "心事" },
];

export function SiteHeader() {
  const [scrolled, setScrolled] = useState(false);

  useEffect(() => {
    const onScroll = () => setScrolled(window.scrollY > 8);
    onScroll();
    window.addEventListener("scroll", onScroll, { passive: true });
    return () => window.removeEventListener("scroll", onScroll);
  }, []);

  return (
    <header
      className={cn(
        "sticky top-0 z-50 border-b backdrop-blur-md transition-[background-color,box-shadow,border-color] duration-500 ease-soft",
        scrolled
          ? "border-line/90 bg-page/92 shadow-header-scrolled"
          : "border-line/50 bg-page/78",
      )}
    >
      <div className="mx-auto flex max-w-6xl items-center justify-between gap-4 px-5 py-3.5 md:px-10 md:py-4">
        <Link
          href="/"
          className="inline-flex items-center gap-2.5 rounded-md text-ink no-underline transition-opacity hover:opacity-85 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-accent"
        >
          <Image
            src="/logo.png"
            alt=""
            width={34}
            height={34}
            className="rounded-control shadow-paper"
          />
          <span className="text-[15px] font-semibold tracking-tight">
            {siteConfig.name}
          </span>
        </Link>
        <nav className="text-[13px] md:text-sm" aria-label="主导航">
          <ul className="flex flex-wrap justify-end gap-x-4 gap-y-1 md:gap-x-7">
            {nav.map((item) => (
              <li key={item.href}>
                <Link
                  href={item.href}
                  className={cn(
                    "rounded-md px-1 py-0.5 text-sub no-underline transition-colors duration-300 ease-soft hover:text-ink",
                  )}
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
