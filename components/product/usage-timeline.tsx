"use client";

import { useReducedMotion } from "framer-motion";
import { FadeIn } from "@/components/ui/fade-in";
import { SectionTitle } from "@/components/ui/section-title";
import { Container } from "@/components/layout/container";
import { usageSteps } from "@/lib/data/scenes";
import { cn } from "@/lib/utils/cn";

export function UsageTimeline() {
  const reduceMotion = useReducedMotion();

  return (
    <section className="py-14 md:py-20 lg:py-24">
      <Container>
        <FadeIn>
          <SectionTitle
            eyebrow="流程"
            title="使用流程"
            subtitle="四步足够，不必记复杂操作。"
            align="center"
          />
        </FadeIn>
        <ol className="relative mx-auto mt-9 max-w-2xl sm:mt-10 md:mt-12">
          <div
            className="absolute bottom-6 left-[13px] top-7 w-px sm:left-[14px] sm:top-8 md:left-[15px]"
            style={{
              background:
                "linear-gradient(to bottom, rgba(232,222,214,0.2), rgba(231,191,167,0.45), rgba(232,222,214,0.25))",
            }}
            aria-hidden
          />
          {usageSteps.map((step, i) => (
            <FadeIn key={step.title} delay={i * 0.07}>
              <li
                className={cn(
                  "relative flex gap-4 pb-8 last:pb-0 sm:gap-5 sm:pb-9 md:gap-7 md:pb-10 lg:pb-12",
                )}
              >
                <div className="relative z-[1] flex shrink-0 flex-col items-center">
                  <span
                    className={cn(
                      "flex h-8 w-8 items-center justify-center rounded-full border-2 border-accent/80 bg-card text-[11px] font-semibold text-ink shadow-paper sm:h-9 sm:w-9 sm:text-xs",
                      !reduceMotion && "ring-2 ring-[#FFF8F0]/80 ring-offset-1 ring-offset-page sm:ring-offset-2",
                    )}
                  >
                    {i + 1}
                  </span>
                </div>
                <div className="min-w-0 flex-1 pb-0.5 pt-0.5">
                  <h3 className="text-base font-semibold leading-snug text-ink sm:text-lg">
                    {step.title}
                  </h3>
                  <p className="mt-2 text-[13px] leading-[1.72] text-sub sm:mt-2.5 sm:text-sm">
                    {step.desc}
                  </p>
                </div>
              </li>
            </FadeIn>
          ))}
        </ol>
      </Container>
    </section>
  );
}
