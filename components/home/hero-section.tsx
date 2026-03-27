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
    <section className="pb-10 pt-10 sm:pb-14 sm:pt-12 md:pb-20 md:pt-16 lg:pb-24 lg:pt-20">
      <Container>
        <div className="flex flex-col gap-8 sm:gap-10 lg:flex-row lg:items-center lg:gap-14 xl:gap-16">
          <div className="flex-1 text-left lg:min-w-0">
            <FadeIn>
              <p className="mb-3 text-[11px] font-medium uppercase tracking-[0.2em] text-sub md:mb-4 md:text-xs">
                心事匣
              </p>
              <h1 className="max-w-[15ch] text-[clamp(1.6rem,6.2vw,3.2rem)] font-semibold leading-[1.12] tracking-tight text-ink sm:max-w-[16ch] lg:text-[clamp(1.85rem,4.5vw,3.15rem)] lg:leading-[1.14]">
                把想说的话，轻轻放进去
              </h1>
              <p className="mt-5 max-w-md text-[15px] leading-[1.72] text-sub sm:mt-6 md:mt-7 md:max-w-xl md:text-[16px] md:leading-[1.75]">
                记录一点情绪，收好一点心事。
                <span className="hidden sm:inline">
                  {" "}
                  不打扰你，只给你留一个可以回来的地方。
                </span>
                <span className="sm:hidden">
                  <br />
                  不打扰你，只给你留一个可以回来的地方。
                </span>
              </p>
              <div className="mt-6 flex w-full flex-col gap-2.5 sm:mt-8 sm:flex-row sm:flex-wrap md:mt-9 md:gap-3">
                <PillButton
                  href="/product"
                  variant="primary"
                  className="w-full min-h-[46px] sm:w-auto sm:min-w-[140px]"
                >
                  了解产品
                </PillButton>
                <PillButton
                  href="/download"
                  variant="ghost"
                  className="w-full min-h-[46px] sm:w-auto sm:min-w-[140px]"
                >
                  前往下载
                </PillButton>
              </div>
            </FadeIn>
          </div>

          <FadeIn
            delay={0.06}
            className="w-full shrink-0 lg:flex lg:flex-1 lg:justify-end"
          >
            <motion.div
              className="relative mx-auto w-full max-w-[min(100%,380px)] lg:mx-0 lg:max-w-[min(100%,400px)]"
              animate={
                reduceMotion
                  ? undefined
                  : { y: [0, -4, 0] }
              }
              transition={{
                duration: 7,
                repeat: Infinity,
                ease: "easeInOut",
              }}
            >
              <div
                className={cn(
                  "relative overflow-hidden rounded-[18px] border border-line/90 bg-[#FDFBF8] sm:rounded-[20px] lg:rounded-[22px]",
                  "shadow-paper-hover",
                  "before:pointer-events-none before:absolute before:inset-0 before:rounded-[inherit] before:bg-gradient-to-br before:from-white/75 before:via-transparent before:to-[#FFF8F0]/40",
                  "after:pointer-events-none after:absolute after:-right-12 after:top-6 after:h-32 after:w-32 after:rounded-full after:bg-[#FFE8D4]/35 after:blur-3xl sm:after:-right-16 sm:after:top-8 sm:after:h-40 sm:after:w-40",
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
                <div className="relative px-5 pb-7 pt-7 sm:px-7 sm:pb-9 sm:pt-8 md:px-9 md:pb-10 md:pt-10 lg:px-10 lg:pb-11 lg:pt-11">
                  <div className="mb-4 flex items-start justify-between gap-3 sm:mb-5 md:mb-6">
                    <span className="inline-flex items-center rounded-full border border-accent-muted/50 bg-accent/15 px-2.5 py-0.5 text-[10px] font-medium tracking-wide text-ink/80 sm:px-3 sm:py-1 sm:text-[11px]">
                      已轻轻收好
                    </span>
                    <span
                      className="hidden h-2 w-12 rounded-full bg-gradient-to-r from-accent/40 to-transparent sm:block md:w-14"
                      aria-hidden
                    />
                  </div>
                  <p className="text-[10px] font-medium uppercase tracking-[0.16em] text-sub/80 sm:text-[11px] sm:tracking-[0.18em]">
                    一页心事
                  </p>
                  <p className="mt-5 text-[14px] leading-[1.78] text-ink/88 sm:mt-6 sm:text-[15px] md:mt-7 md:leading-[1.85]">
                    今天没有什么大事，
                    <br />
                    只是想把这一小段时光
                    <br />
                    对折好，收进角落。
                  </p>
                  <div className="mt-7 flex items-center gap-2.5 border-t border-line/55 pt-6 sm:mt-8 sm:gap-3 sm:pt-7 md:mt-9 md:pt-8">
                    <span className="h-1 w-9 rounded-full bg-accent/75 sm:w-10" />
                    <span className="h-1 w-5 rounded-full bg-accent-muted/55 sm:w-6" />
                  </div>
                  <p className="mt-6 text-right text-[11px] text-sub sm:mt-7 sm:text-xs">
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
