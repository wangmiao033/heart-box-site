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
    <section className="py-20 md:py-28">
      <Container>
        <FadeIn>
          <SectionTitle
            eyebrow="功能"
            title="为你准备的小事"
            subtitle="不堆砌，只保留日常里用得上的温柔。"
            align="center"
          />
        </FadeIn>
        <div className="mt-14 grid auto-rows-fr gap-5 sm:grid-cols-2 lg:grid-cols-3">
          {homeFeatures.map((f, i) => {
            const Icon = featureIcons[i] ?? PenLine;
            return (
              <FadeIn key={f.title} delay={i * 0.04}>
                <motion.article
                  className={cn(
                    "flex h-full min-h-[200px] flex-col rounded-card-md border border-line/95 bg-card p-7 shadow-paper",
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
                  <div className="mb-5 flex h-11 w-11 items-center justify-center rounded-control border border-line/80 bg-page-elevated/90 text-accent shadow-[inset_0_1px_0_rgba(255,255,255,0.85)]">
                    <Icon className="h-[22px] w-[22px]" strokeWidth={1.35} />
                  </div>
                  <h3 className="text-lg font-semibold leading-snug tracking-tight text-ink">
                    {f.title}
                  </h3>
                  <p className="mt-3 flex-1 text-sm leading-[1.68] text-sub">
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
