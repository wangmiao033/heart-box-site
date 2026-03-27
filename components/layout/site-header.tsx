"use client";

import Image from "next/image";
import Link from "next/link";
import { usePathname } from "next/navigation";
import { useCallback, useEffect, useState } from "react";
import { AnimatePresence, motion, useReducedMotion } from "framer-motion";
import { Menu, X } from "lucide-react";
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
  const [menuOpen, setMenuOpen] = useState(false);
  const pathname = usePathname();
  const reduceMotion = useReducedMotion();

  useEffect(() => {
    const onScroll = () => setScrolled(window.scrollY > 8);
    onScroll();
    window.addEventListener("scroll", onScroll, { passive: true });
    return () => window.removeEventListener("scroll", onScroll);
  }, []);

  useEffect(() => {
    setMenuOpen(false);
  }, [pathname]);

  useEffect(() => {
    if (!menuOpen) return;
    const prev = document.body.style.overflow;
    document.body.style.overflow = "hidden";
    const onKey = (e: KeyboardEvent) => {
      if (e.key === "Escape") setMenuOpen(false);
    };
    window.addEventListener("keydown", onKey);
    return () => {
      document.body.style.overflow = prev;
      window.removeEventListener("keydown", onKey);
    };
  }, [menuOpen]);

  const closeMenu = useCallback(() => setMenuOpen(false), []);

  return (
    <>
      <header
        className={cn(
          "sticky top-0 z-50 border-b backdrop-blur-md transition-[background-color,box-shadow,border-color] duration-500 ease-soft safe-x",
          scrolled
            ? "border-line/90 bg-page/92 shadow-header-scrolled"
            : "border-line/50 bg-page/78",
        )}
      >
        <div className="safe-t mx-auto flex max-w-6xl items-center justify-between gap-3 px-4 py-2.5 sm:px-5 md:px-9 md:py-3 lg:px-10">
          <Link
            href="/"
            className="inline-flex min-h-[40px] min-w-0 items-center gap-2 rounded-md text-ink no-underline transition-opacity hover:opacity-85 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-accent"
            onClick={closeMenu}
          >
            <Image
              src="/logo.png"
              alt=""
              width={32}
              height={32}
              className="size-8 shrink-0 rounded-control shadow-paper md:size-[34px]"
            />
            <span className="truncate text-[14px] font-semibold tracking-tight md:text-[15px]">
              {siteConfig.name}
            </span>
          </Link>
          <nav
            className="hidden text-[13px] text-sm md:block"
            aria-label="主导航"
          >
            <ul className="flex flex-wrap justify-end gap-x-6 lg:gap-x-7">
              {nav.map((item) => (
                <li key={item.href}>
                  <Link
                    href={item.href}
                    className={cn(
                      "rounded-md px-1 py-1 text-sub no-underline transition-colors duration-300 ease-soft hover:text-ink",
                    )}
                  >
                    {item.label}
                  </Link>
                </li>
              ))}
            </ul>
          </nav>
          <button
            type="button"
            className="flex min-h-[44px] min-w-[44px] items-center justify-center rounded-control text-ink md:hidden"
            aria-expanded={menuOpen}
            aria-controls="mobile-nav-panel"
            aria-label={menuOpen ? "关闭菜单" : "打开菜单"}
            onClick={() => setMenuOpen((o) => !o)}
          >
            {menuOpen ? (
              <X className="h-6 w-6" strokeWidth={1.5} />
            ) : (
              <Menu className="h-6 w-6" strokeWidth={1.5} />
            )}
          </button>
        </div>
      </header>

      <AnimatePresence>
        {menuOpen ? (
          <motion.div
            className="fixed inset-0 z-[70] md:hidden"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            transition={{ duration: reduceMotion ? 0.12 : 0.2 }}
            role="dialog"
            aria-modal="true"
            aria-label="网站导航"
          >
            <button
              type="button"
              className="absolute inset-0 bg-ink/25 backdrop-blur-[2px]"
              aria-label="关闭菜单"
              onClick={closeMenu}
            />
            <motion.nav
              id="mobile-nav-panel"
              className="absolute right-0 top-0 flex h-full w-[min(100%,300px)] flex-col border-l border-line/80 bg-page-elevated/98 shadow-2xl backdrop-blur-md safe-b"
              style={{
                paddingTop: "max(0.75rem, env(safe-area-inset-top, 0px))",
                paddingBottom: "max(1rem, env(safe-area-inset-bottom, 0px))",
              }}
              initial={reduceMotion ? undefined : { x: "100%" }}
              animate={{ x: 0 }}
              exit={reduceMotion ? undefined : { x: "100%" }}
              transition={{
                type: "spring",
                stiffness: 380,
                damping: 34,
              }}
            >
              <div className="flex items-center justify-between border-b border-line/60 px-4 py-3">
                <span className="text-xs font-medium uppercase tracking-[0.14em] text-sub">
                  导航
                </span>
                <button
                  type="button"
                  className="flex min-h-[44px] min-w-[44px] items-center justify-center rounded-control text-sub hover:text-ink"
                  aria-label="关闭菜单"
                  onClick={closeMenu}
                >
                  <X className="h-5 w-5" strokeWidth={1.5} />
                </button>
              </div>
              <ul className="flex flex-1 flex-col gap-0.5 px-3 py-4">
                {nav.map((item) => (
                  <li key={item.href}>
                    <Link
                      href={item.href}
                      className="block rounded-control px-4 py-3.5 text-[15px] font-medium text-ink no-underline transition-colors hover:bg-card/90"
                      onClick={closeMenu}
                    >
                      {item.label}
                    </Link>
                  </li>
                ))}
              </ul>
            </motion.nav>
          </motion.div>
        ) : null}
      </AnimatePresence>
    </>
  );
}
