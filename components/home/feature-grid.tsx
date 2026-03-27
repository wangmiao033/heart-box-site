"use client";

import {
  Bookmark,
  CalendarDays,
  Cloud,
  PenLine,
  Shield,
  Sparkles,
} from "lucide-react";
import { motion, useReducedMotion } from "framer-motion";
import { FadeIn } from "@/components/ui/fade-in";
import { SectionTitle } from "@/components/ui/section-title";
import { Container } from "@/components/layout/container";
import { homeFeatures } from "@/lib/data/features";
import { cn } from "@/lib/utils/cn";

const featureIcons = [PenLine, CalendarDays, Sparkles, Bookmark, Shield, Cloud] as const;

export function FeatureGrid() {
  const reduceMotion = useReducedMotion();

  return (
    <section className="py-14 md:py-20 lg:py-24">
      <Container>
        <FadeIn>
          <SectionTitle
            eyebrow="功能"
            title="为你准备的小事"
            subtitle="不堆砌，只保留日常里用得上的温柔。"
            align="center"
          />
        </FadeIn>
        <div className="mt-9 grid auto-rows-fr gap-3.5 sm:mt-10 sm:grid-cols-2 sm:gap-4 lg:mt-11 lg:grid-cols-3 lg:gap-5">
          {homeFeatures.map((f, i) => {
            const Icon = featureIcons[i] ?? PenLine;
            return (
              <FadeIn key={f.title} delay={i * 0.04}>
                <motion.article
                  className={cn(
                    "flex h-full min-h-0 flex-col rounded-card-md border border-line/95 bg-card p-5 shadow-paper sm:min-h-[168px] md:p-6 lg:p-7",
                    "transition-[transform,box-shadow,border-color] duration-500 ease-soft",
                    "before:pointer-events-none before:absolute before:inset-0 before:rounded-card-md before:opacity-0 before:shadow-[inset_0_1px_0_rgba(255,255,255,0.9)] before:transition-opacity",
                    "relative overflow-hidden hover:-translate-y-0.5 hover:border-line hover:shadow-paper-hover hover:before:opacity-100",
                  )}
                  whileHover={
                    reduceMotion
                      ? undefined
                      : { y: -2 }
                  }
                  transition={{ type: "spring", stiffness: 420, damping: 32 }}
                >
                  <div className="mb-3.5 flex h-10 w-10 items-center justify-center rounded-control border border-line/80 bg-page-elevated/90 text-accent shadow-[inset_0_1px_0_rgba(255,255,255,0.85)] md:mb-4 md:h-11 md:w-11">
                    <Icon className="h-5 w-5 md:h-[22px] md:w-[22px]" strokeWidth={1.35} />
                  </div>
                  <h3 className="text-base font-semibold leading-snug tracking-tight text-ink md:text-lg">
                    {f.title}
                  </h3>
                  <p className="mt-2 flex-1 text-[13px] leading-[1.65] text-sub md:mt-2.5 md:text-sm md:leading-[1.68]">
                    {f.description}
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
