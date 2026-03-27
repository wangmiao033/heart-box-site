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
    <section className="py-20 md:py-28">
      <Container>
        <FadeIn>
          <SectionTitle
            eyebrow="获取"
            title="先知道怎么找到我们"
            subtitle="正式上架后会更新链接；这里先看状态与说明。"
            align="center"
          />
        </FadeIn>
        <div className="mt-14 grid gap-6 md:grid-cols-3 md:gap-7">
          {platformCards.map((p, i) => {
            const Icon = icons[p.icon];
            return (
              <FadeIn key={p.id} delay={i * 0.05}>
                <motion.div
                  className="flex h-full flex-col rounded-card-md border border-line/95 bg-card p-8 shadow-paper transition-shadow duration-500 ease-soft hover:shadow-paper-hover"
                  whileHover={reduceMotion ? undefined : { y: -2 }}
                  transition={{ type: "spring", stiffness: 400, damping: 28 }}
                >
                  <Icon className="h-8 w-8 text-accent" strokeWidth={1.25} />
                  <p className="mt-4 text-xs font-medium uppercase tracking-widest text-sub">
                    {p.name}
                  </p>
                  <p
                    className={cn(
                      "mt-2 inline-flex w-fit rounded-full border border-line bg-page-elevated px-3 py-1 text-xs text-ink",
                    )}
                  >
                    {p.status}
                  </p>
                  <p className="mt-4 flex-1 text-sm leading-relaxed text-sub">
                    {p.description}
                  </p>
                </motion.div>
              </FadeIn>
            );
          })}
        </div>
        <FadeIn delay={0.12} className="mt-12 text-center">
          <Link
            href="/download"
            className="rounded-md text-sm font-medium text-ink underline-offset-[6px] hover:underline focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-accent"
          >
            查看完整下载页 →
          </Link>
        </FadeIn>
      </Container>
    </section>
  );
}
