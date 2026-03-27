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
    <section className="py-20 md:py-28">
      <Container>
        <FadeIn>
          <SectionTitle
            eyebrow="场景"
            title="适合这样用"
            subtitle="你可以完全按自己的节奏来。"
            align="center"
          />
        </FadeIn>
        <div className="mt-14 grid gap-6 md:grid-cols-3 md:gap-7">
          {homeScenes.map((s, i) => (
            <FadeIn key={s.title} delay={i * 0.06}>
              <motion.article
                className={cn(
                  "h-full rounded-card-md border border-line/95 bg-page-elevated/85 p-8 shadow-paper",
                  "transition-shadow duration-500 ease-soft hover:shadow-paper-hover",
                )}
                whileHover={reduceMotion ? undefined : { y: -2 }}
                transition={{ type: "spring", stiffness: 400, damping: 32 }}
              >
                <h3 className="text-lg font-semibold tracking-tight text-ink">
                  {s.title}
                </h3>
                <p className="mt-4 text-sm leading-[1.72] text-sub">{s.body}</p>
              </motion.article>
            </FadeIn>
          ))}
        </div>
      </Container>
    </section>
  );
}
