"use client";

import { FadeIn } from "@/components/ui/fade-in";
import { SectionTitle } from "@/components/ui/section-title";
import { Container } from "@/components/layout/container";
import { productScenarios } from "@/lib/data/scenes";

export function ScenarioSection() {
  return (
    <section className="py-20 md:py-28">
      <Container>
        <FadeIn>
          <SectionTitle
            eyebrow="场景"
            title="你可能会在这些时刻打开它"
            align="center"
          />
        </FadeIn>
        <ul className="mx-auto mt-14 flex max-w-2xl flex-col gap-3.5">
          {productScenarios.map((text, i) => (
            <FadeIn key={text} delay={i * 0.05}>
              <li className="flex items-start gap-3.5 rounded-card-md border border-line/95 bg-card px-5 py-4 shadow-paper transition-shadow duration-500 ease-soft hover:shadow-paper-hover">
                <span
                  className="mt-1.5 h-1.5 w-1.5 shrink-0 rounded-full bg-accent/75"
                  aria-hidden
                />
                <span className="text-[15px] leading-[1.72] text-ink">{text}</span>
              </li>
            </FadeIn>
          ))}
        </ul>
      </Container>
    </section>
  );
}
