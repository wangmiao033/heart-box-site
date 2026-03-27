"use client";

import { FadeIn } from "@/components/ui/fade-in";
import { Container } from "@/components/layout/container";

export function NotesHero() {
  return (
    <section className="border-b border-line/55 bg-gradient-to-b from-page-elevated/50 to-page/80 pb-16 pt-14 md:pb-24 md:pt-20">
      <Container>
        <FadeIn>
          <p className="text-xs font-medium uppercase tracking-[0.22em] text-sub">
            心事展示
          </p>
          <h1 className="mt-5 max-w-[18ch] text-[clamp(1.85rem,4.2vw,2.45rem)] font-semibold leading-[1.2] tracking-tight text-ink">
            一些被轻轻放下的话
          </h1>
          <p className="mt-8 max-w-xl text-[16px] leading-[1.78] text-sub">
            它们不需要很大声，也值得被看见。
          </p>
          <p className="mt-5 max-w-xl text-[15px] leading-[1.75] text-sub/92">
            有些话不需要发出去，也值得被认真放着。
          </p>
          <p className="mt-6 text-sm leading-relaxed text-sub/80">
            以下为官网示例文案，与真实用户数据无关。
          </p>
        </FadeIn>
      </Container>
    </section>
  );
}
