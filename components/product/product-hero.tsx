"use client";

import { FadeIn } from "@/components/ui/fade-in";
import { Container } from "@/components/layout/container";

export function ProductHero() {
  return (
    <section className="border-b border-line/55 bg-gradient-to-b from-page-elevated/45 to-page/70 pb-10 pt-10 sm:pb-12 sm:pt-11 md:pb-16 md:pt-14 lg:pb-20 lg:pt-16">
      <Container>
        <FadeIn>
          <p className="text-[11px] font-medium uppercase tracking-[0.2em] text-sub md:text-xs">
            产品
          </p>
          <h1 className="mt-3 max-w-2xl text-[clamp(1.5rem,5vw,2.4rem)] font-semibold leading-[1.18] tracking-tight text-ink sm:mt-4 md:mt-5 md:leading-[1.22]">
            一个不催促你的记录空间
          </h1>
          <p className="mt-4 max-w-xl text-[15px] leading-[1.72] text-sub sm:mt-5 md:mt-6 md:text-[16px] md:leading-[1.75]">
            像一本只属于你的笔记本：可长可短，可写可停，没有 KPI，也没有观众。
          </p>
        </FadeIn>
      </Container>
    </section>
  );
}
