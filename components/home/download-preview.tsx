"use client";

import { motion, useReducedMotion } from "framer-motion";
import { Apple, Globe, Smartphone } from "lucide-react";
import Link from "next/link";
import { FadeIn } from "@/components/ui/fade-in";
import { SectionTitle } from "@/components/ui/section-title";
import { Container } from "@/components/layout/container";
import { platformCards } from "@/lib/data/downloads";
import { cn } from "@/lib/utils/cn";

const icons = {
  apple: Apple,
  android: Smartphone,
  globe: Globe,
} as const;

export function DownloadPreview() {
  const reduceMotion = useReducedMotion();

  return (
    <section className="py-14 md:py-20 lg:py-24">
      <Container>
        <FadeIn>
          <SectionTitle
            eyebrow="获取"
            title="先知道怎么找到我们"
            subtitle="正式上架后会更新链接；这里先看状态与说明。"
            align="center"
          />
        </FadeIn>
        <div className="mt-9 grid gap-3.5 sm:mt-10 md:grid-cols-3 md:gap-4 lg:mt-11 lg:gap-5">
          {platformCards.map((p, i) => {
            const Icon = icons[p.icon];
            return (
              <FadeIn key={p.id} delay={i * 0.05}>
                <motion.div
                  className="flex h-full flex-col rounded-card-md border border-line/95 bg-card p-5 shadow-paper transition-shadow duration-500 ease-soft hover:shadow-paper-hover sm:p-6 md:p-7"
                  whileHover={reduceMotion ? undefined : { y: -2 }}
                  transition={{ type: "spring", stiffness: 400, damping: 28 }}
                >
                  <Icon className="h-7 w-7 text-accent sm:h-8 sm:w-8" strokeWidth={1.25} />
                  <p className="mt-3 text-[11px] font-medium uppercase tracking-widest text-sub sm:mt-4 sm:text-xs">
                    {p.name}
                  </p>
                  <p
                    className={cn(
                      "mt-1.5 inline-flex w-fit rounded-full border border-line bg-page-elevated px-2.5 py-0.5 text-[11px] text-ink sm:mt-2 sm:px-3 sm:py-1 sm:text-xs",
                    )}
                  >
                    {p.status}
                  </p>
                  <p className="mt-3 flex-1 text-[13px] leading-relaxed text-sub sm:mt-4 sm:text-sm">
                    {p.description}
                  </p>
                </motion.div>
              </FadeIn>
            );
          })}
        </div>
        <FadeIn delay={0.1} className="mt-9 text-center sm:mt-10">
          <Link
            href="/download"
            className="inline-flex min-h-[44px] items-center justify-center rounded-md text-sm font-medium text-ink underline-offset-[6px] hover:underline focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-accent"
          >
            查看完整下载页 →
          </Link>
        </FadeIn>
      </Container>
    </section>
  );
}
