"use client";

import { motion, useReducedMotion } from "framer-motion";
import { FadeIn } from "@/components/ui/fade-in";
import { SectionTitle } from "@/components/ui/section-title";
import { Container } from "@/components/layout/container";
import { CapabilityPreviewMock } from "@/components/product/capability-preview-mock";
import { capabilityModules } from "@/lib/data/features";
import { cn } from "@/lib/utils/cn";

export function CapabilitySection() {
  const reduceMotion = useReducedMotion();

  return (
    <section className="py-14 md:py-20 lg:py-24">
      <Container>
        <FadeIn>
          <SectionTitle
            eyebrow="能力"
            title="核心能力"
            subtitle="按模块拆开说，方便你对照自己需要什么。"
            align="center"
          />
        </FadeIn>
        <div className="mt-9 space-y-8 sm:mt-10 md:mt-11 md:space-y-9 lg:space-y-10">
          {capabilityModules.map((m, i) => (
            <FadeIn key={m.title} delay={i * 0.04}>
              <motion.div
                className={cn(
                  "flex flex-col gap-5 rounded-card-md border border-line/95 bg-page-elevated/55 p-5 shadow-paper sm:gap-6 sm:p-6 md:flex-row md:items-stretch md:gap-8 md:p-8 lg:gap-10 lg:p-9",
                  m.side === "right" && "md:flex-row-reverse",
                )}
                whileHover={reduceMotion ? undefined : { y: -1 }}
                transition={{ type: "spring", stiffness: 420, damping: 32 }}
              >
                <div className="flex min-w-0 flex-1 flex-col justify-center">
                  <p className="text-[11px] font-medium uppercase tracking-[0.14em] text-sub/80 md:text-xs md:tracking-[0.16em]">
                    {String(i + 1).padStart(2, "0")}
                  </p>
                  <h3 className="mt-2 text-lg font-semibold leading-snug tracking-tight text-ink sm:mt-2.5 md:mt-3 md:text-xl">
                    {m.title}
                  </h3>
                  <p className="mt-3 max-w-prose text-[14px] leading-[1.72] text-sub sm:mt-3.5 sm:text-[15px] sm:leading-[1.75] md:mt-4">
                    {m.description}
                  </p>
                </div>
                <div className="w-full shrink-0 md:w-[min(100%,300px)] md:max-w-[42%] lg:w-[min(100%,320px)]">
                  <CapabilityPreviewMock variant={i} className="h-full min-h-[156px] md:min-h-[180px] lg:min-h-[200px]" />
                </div>
              </motion.div>
            </FadeIn>
          ))}
        </div>
      </Container>
    </section>
  );
}
