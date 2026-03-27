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
    <section className="py-20 md:py-28">
      <Container>
        <FadeIn>
          <SectionTitle
            eyebrow="能力"
            title="核心能力"
            subtitle="按模块拆开说，方便你对照自己需要什么。"
            align="center"
          />
        </FadeIn>
        <div className="mt-16 space-y-12 md:space-y-14">
          {capabilityModules.map((m, i) => (
            <FadeIn key={m.title} delay={i * 0.04}>
              <motion.div
                className={cn(
                  "flex flex-col gap-8 rounded-card-md border border-line/95 bg-page-elevated/55 p-8 shadow-paper md:flex-row md:items-stretch md:gap-12 md:p-10",
                  m.side === "right" && "md:flex-row-reverse",
                )}
                whileHover={reduceMotion ? undefined : { y: -1 }}
                transition={{ type: "spring", stiffness: 420, damping: 32 }}
              >
                <div className="flex min-w-0 flex-1 flex-col justify-center">
                  <p className="text-xs font-medium uppercase tracking-[0.16em] text-sub/80">
                    {String(i + 1).padStart(2, "0")}
                  </p>
                  <h3 className="mt-3 text-xl font-semibold leading-snug tracking-tight text-ink">
                    {m.title}
                  </h3>
                  <p className="mt-4 max-w-prose text-[15px] leading-[1.75] text-sub">
                    {m.description}
                  </p>
                </div>
                <div className="w-full shrink-0 md:w-[min(100%,320px)] md:max-w-[40%]">
                  <CapabilityPreviewMock variant={i} className="h-full min-h-[200px]" />
                </div>
              </motion.div>
            </FadeIn>
          ))}
        </div>
      </Container>
    </section>
  );
}
