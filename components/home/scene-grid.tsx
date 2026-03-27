"use client";

import { motion, useReducedMotion } from "framer-motion";
import { FadeIn } from "@/components/ui/fade-in";
import { SectionTitle } from "@/components/ui/section-title";
import { Container } from "@/components/layout/container";
import { homeScenes } from "@/lib/data/scenes";
import { cn } from "@/lib/utils/cn";

export function SceneGrid() {
  const reduceMotion = useReducedMotion();

  return (
    <section className="py-14 md:py-20 lg:py-24">
      <Container>
        <FadeIn>
          <SectionTitle
            eyebrow="场景"
            title="适合这样用"
            subtitle="你可以完全按自己的节奏来。"
            align="center"
          />
        </FadeIn>
        <div className="mt-9 grid gap-3.5 sm:mt-10 md:grid-cols-3 md:gap-4 lg:mt-11 lg:gap-5">
          {homeScenes.map((s, i) => (
            <FadeIn key={s.title} delay={i * 0.06}>
              <motion.article
                className={cn(
                  "h-full rounded-card-md border border-line/95 bg-page-elevated/85 p-5 shadow-paper sm:p-6 md:p-7",
                  "transition-shadow duration-500 ease-soft hover:shadow-paper-hover",
                )}
                whileHover={reduceMotion ? undefined : { y: -2 }}
                transition={{ type: "spring", stiffness: 400, damping: 32 }}
              >
                <h3 className="text-base font-semibold tracking-tight text-ink md:text-lg">
                  {s.title}
                </h3>
                <p className="mt-3 text-[13px] leading-[1.68] text-sub md:mt-3.5 md:text-sm md:leading-[1.72]">
                  {s.body}
                </p>
              </motion.article>
            </FadeIn>
          ))}
        </div>
      </Container>
    </section>
  );
}
