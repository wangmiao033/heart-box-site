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
    <section className="py-20 md:py-28">
      <Container>
        <FadeIn>
          <SectionTitle
            eyebrow="流程"
            title="使用流程"
            subtitle="四步足够，不必记复杂操作。"
            align="center"
          />
        </FadeIn>
        <ol className="relative mx-auto mt-16 max-w-2xl">
          <div
            className="absolute left-[15px] top-8 hidden w-px md:block"
            style={{
              height: "calc(100% - 3rem)",
              background:
                "linear-gradient(to bottom, rgba(232,222,214,0.2), rgba(231,191,167,0.45), rgba(232,222,214,0.25))",
            }}
            aria-hidden
          />
          {usageSteps.map((step, i) => (
            <FadeIn key={step.title} delay={i * 0.07}>
              <li
                className={cn(
                  "relative flex gap-5 pb-12 last:pb-0 md:gap-8",
                  "md:pl-0",
                )}
              >
                <div className="relative z-[1] flex shrink-0 flex-col items-center">
                  <span
                    className={cn(
                      "flex h-9 w-9 items-center justify-center rounded-full border-2 border-accent/80 bg-card text-xs font-semibold text-ink shadow-paper",
                      !reduceMotion && "ring-2 ring-[#FFF8F0]/80 ring-offset-2 ring-offset-page",
                    )}
                  >
                    {i + 1}
                  </span>
                </div>
                <div className="min-w-0 flex-1 pb-1 pt-0.5">
                  <h3 className="text-lg font-semibold leading-snug text-ink">
                    {step.title}
                  </h3>
                  <p className="mt-2.5 text-sm leading-[1.72] text-sub">
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
