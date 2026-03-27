"use client";

import { FadeIn } from "@/components/ui/fade-in";
import { SectionTitle } from "@/components/ui/section-title";
import { Container } from "@/components/layout/container";
import { productScenarios } from "@/lib/data/scenes";

export function ScenarioSection() {
  return (
    <section className="py-14 md:py-20 lg:py-24">
      <Container>
        <FadeIn>
          <SectionTitle
            eyebrow="场景"
            title="你可能会在这些时刻打开它"
            align="center"
          />
        </FadeIn>
        <ul className="mx-auto mt-9 flex max-w-2xl flex-col gap-2.5 sm:mt-10 sm:gap-3 md:mt-11">
          {productScenarios.map((text, i) => (
            <FadeIn key={text} delay={i * 0.05}>
              <li className="flex items-start gap-3 rounded-card-md border border-line/95 bg-card px-4 py-3.5 shadow-paper transition-shadow duration-500 ease-soft hover:shadow-paper-hover sm:gap-3.5 sm:px-5 sm:py-4">
                <span
                  className="mt-1.5 h-1.5 w-1.5 shrink-0 rounded-full bg-accent/75"
                  aria-hidden
                />
                <span className="text-[14px] leading-[1.68] text-ink sm:text-[15px] sm:leading-[1.72]">
                  {text}
                </span>
              </li>
            </FadeIn>
          ))}
        </ul>
      </Container>
    </section>
  );
}
