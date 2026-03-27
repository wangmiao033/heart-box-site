"use client";

import { FadeIn } from "@/components/ui/fade-in";
import { Container } from "@/components/layout/container";

export function ProductHero() {
  return (
    <section className="border-b border-line/55 bg-gradient-to-b from-page-elevated/45 to-page/70 pb-16 pt-12 md:pb-24 md:pt-20">
      <Container>
        <FadeIn>
          <p className="text-xs font-medium uppercase tracking-[0.22em] text-sub">
            产品
          </p>
          <h1 className="mt-5 max-w-2xl text-[clamp(1.85rem,4.2vw,2.45rem)] font-semibold leading-[1.22] tracking-tight text-ink">
            一个不催促你的记录空间
          </h1>
          <p className="mt-8 max-w-xl text-[16px] leading-[1.75] text-sub">
            像一本只属于你的笔记本：可长可短，可写可停，没有 KPI，也没有观众。
          </p>
        </FadeIn>
      </Container>
    </section>
  );
}
