"use client";

import { motion, useReducedMotion } from "framer-motion";
import Link from "next/link";
import { FadeIn } from "@/components/ui/fade-in";
import { PillButton } from "@/components/ui/pill-button";
import { Container } from "@/components/layout/container";
import { cn } from "@/lib/utils/cn";

export function HeroSection() {
  const reduceMotion = useReducedMotion();

  return (
    <section className="pb-24 pt-16 md:pb-36 md:pt-28">
      <Container>
        <div className="flex flex-col gap-16 lg:flex-row lg:items-center lg:gap-24">
          <div className="flex-1">
            <FadeIn>
              <p className="mb-5 text-xs font-medium uppercase tracking-[0.22em] text-sub">
                心事匣
              </p>
              <h1 className="max-w-[16ch] text-[clamp(2.05rem,5.2vw,3.35rem)] font-semibold leading-[1.14] tracking-tight text-ink">
                把想说的话，轻轻放进去
              </h1>
              <p className="mt-9 max-w-xl text-[17px] leading-[1.78] text-sub">
                记录一点情绪，收好一点心事。不打扰你，只给你留一个可以回来的地方。
              </p>
              <div className="mt-12 flex flex-wrap gap-3.5">
                <PillButton href="/product" variant="primary">
                  了解产品
                </PillButton>
                <PillButton href="/download" variant="ghost">
                  前往下载
                </PillButton>
              </div>
            </FadeIn>
          </div>

          <FadeIn delay={0.08} className="flex flex-1 justify-center lg:justify-end">
            <motion.div
              className="relative w-full max-w-[420px]"
              animate={
                reduceMotion
                  ? undefined
                  : { y: [0, -5, 0] }
              }
              transition={{
                duration: 7,
                repeat: Infinity,
                ease: "easeInOut",
              }}
            >
              <div
                className={cn(
                  "relative overflow-hidden rounded-[22px] border border-line/90 bg-[#FDFBF8]",
                  "shadow-paper-hover",
                  "before:pointer-events-none before:absolute before:inset-0 before:rounded-[22px] before:bg-gradient-to-br before:from-white/75 before:via-transparent before:to-[#FFF8F0]/40",
                  "after:pointer-events-none after:absolute after:-right-16 after:top-8 after:h-40 after:w-40 after:rounded-full after:bg-[#FFE8D4]/35 after:blur-3xl",
                )}
              >
                <div
                  className="pointer-events-none absolute inset-0 bg-paper-lines opacity-[0.65]"
                  aria-hidden
                />
                <div
                  className="pointer-events-none absolute inset-0 texture-noise opacity-35 mix-blend-multiply"
                  aria-hidden
                />
                <div className="relative px-8 pb-10 pt-9 md:px-10 md:pb-12 md:pt-11">
                  <div className="mb-6 flex items-start justify-between gap-4">
                    <span className="inline-flex items-center rounded-full border border-accent-muted/50 bg-accent/15 px-3 py-1 text-[11px] font-medium tracking-wide text-ink/80">
                      已轻轻收好
                    </span>
                    <span
                      className="hidden h-2 w-14 rounded-full bg-gradient-to-r from-accent/40 to-transparent sm:block"
                      aria-hidden
                    />
                  </div>
                  <p className="text-[11px] font-medium uppercase tracking-[0.18em] text-sub/80">
                    一页心事
                  </p>
                  <p className="mt-7 text-[15px] leading-[1.85] text-ink/88">
                    今天没有什么大事，
                    <br />
                    只是想把这一小段时光
                    <br />
                    对折好，收进角落。
                  </p>
                  <div className="mt-10 flex items-center gap-3 border-t border-line/55 pt-8">
                    <span className="h-1 w-10 rounded-full bg-accent/75" />
                    <span className="h-1 w-6 rounded-full bg-accent-muted/55" />
                  </div>
                  <p className="mt-8 text-right text-xs text-sub">
                    <Link
                      href="/notes"
                      className="rounded underline-offset-4 transition-colors hover:text-ink hover:underline focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-accent"
                    >
                      看看示例心事 →
                    </Link>
                  </p>
                </div>
              </div>
            </motion.div>
          </FadeIn>
        </div>
      </Container>
    </section>
  );
}
