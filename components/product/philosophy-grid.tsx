"use client";

import { BookOpen, Hourglass, Leaf } from "lucide-react";
import { motion, useReducedMotion } from "framer-motion";
import { FadeIn } from "@/components/ui/fade-in";
import { SectionTitle } from "@/components/ui/section-title";
import { Container } from "@/components/layout/container";
import { philosophyCards } from "@/lib/data/scenes";

const icons = [BookOpen, Leaf, Hourglass] as const;

export function PhilosophyGrid() {
  const reduceMotion = useReducedMotion();

  return (
    <section className="py-14 md:py-20 lg:py-24">
      <Container>
        <FadeIn>
          <SectionTitle
            eyebrow="理念"
            title="我们相信的事"
            align="center"
          />
        </FadeIn>
        <div className="mt-9 grid gap-3.5 sm:mt-10 md:grid-cols-3 md:gap-4 lg:mt-11 lg:gap-5">
          {philosophyCards.map((c, i) => {
            const Icon = icons[i] ?? BookOpen;
            return (
              <FadeIn key={c.title} delay={i * 0.06}>
                <motion.article
                  className="relative h-full overflow-hidden rounded-card border border-line/95 bg-card p-5 shadow-paper transition-[transform,box-shadow] duration-500 ease-soft hover:-translate-y-0.5 hover:shadow-paper-hover sm:p-6 md:p-7 lg:p-8"
                  whileHover={reduceMotion ? undefined : { y: -2 }}
                  transition={{ type: "spring", stiffness: 400, damping: 30 }}
                >
                  <div
                    className="pointer-events-none absolute -right-8 -top-8 h-24 w-24 rounded-full bg-[#FFF4E6]/40 blur-2xl sm:h-28 sm:w-28"
                    aria-hidden
                  />
                  <div className="relative flex items-start gap-3 sm:gap-4">
                    <span className="flex h-9 w-9 shrink-0 items-center justify-center rounded-full border border-line/90 bg-page-elevated text-xs font-semibold text-accent sm:h-10 sm:w-10 sm:text-sm">
                      {i + 1}
                    </span>
                    <div className="flex h-9 w-9 shrink-0 items-center justify-center rounded-control border border-line/80 bg-page-elevated/90 text-accent sm:h-10 sm:w-10">
                      <Icon className="h-4 w-4 sm:h-5 sm:w-5" strokeWidth={1.35} />
                    </div>
                  </div>
                  <h3 className="relative mt-4 text-base font-semibold leading-snug tracking-tight text-ink sm:mt-5 sm:text-lg md:mt-6">
                    {c.title}
                  </h3>
                  <p className="relative mt-3 text-[13px] leading-[1.68] text-sub sm:mt-3.5 sm:text-sm sm:leading-[1.72] md:mt-4">
                    {c.body}
                  </p>
                </motion.article>
              </FadeIn>
            );
          })}
        </div>
      </Container>
    </section>
  );
}
