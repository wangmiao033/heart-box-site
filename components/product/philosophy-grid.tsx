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
    <section className="py-20 md:py-28">
      <Container>
        <FadeIn>
          <SectionTitle
            eyebrow="理念"
            title="我们相信的事"
            align="center"
          />
        </FadeIn>
        <div className="mt-14 grid gap-6 md:grid-cols-3 md:gap-7">
          {philosophyCards.map((c, i) => {
            const Icon = icons[i] ?? BookOpen;
            return (
              <FadeIn key={c.title} delay={i * 0.06}>
                <motion.article
                  className="relative h-full overflow-hidden rounded-card border border-line/95 bg-card p-8 shadow-paper transition-[transform,box-shadow] duration-500 ease-soft hover:-translate-y-0.5 hover:shadow-paper-hover"
                  whileHover={reduceMotion ? undefined : { y: -2 }}
                  transition={{ type: "spring", stiffness: 400, damping: 30 }}
                >
                  <div
                    className="pointer-events-none absolute -right-8 -top-8 h-28 w-28 rounded-full bg-[#FFF4E6]/40 blur-2xl"
                    aria-hidden
                  />
                  <div className="relative flex items-start gap-4">
                    <span className="flex h-10 w-10 shrink-0 items-center justify-center rounded-full border border-line/90 bg-page-elevated text-sm font-semibold text-accent">
                      {i + 1}
                    </span>
                    <div className="flex h-10 w-10 shrink-0 items-center justify-center rounded-control border border-line/80 bg-page-elevated/90 text-accent">
                      <Icon className="h-5 w-5" strokeWidth={1.35} />
                    </div>
                  </div>
                  <h3 className="relative mt-6 text-lg font-semibold leading-snug tracking-tight text-ink">
                    {c.title}
                  </h3>
                  <p className="relative mt-4 text-sm leading-[1.72] text-sub">
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
