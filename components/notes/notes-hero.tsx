"use client";

import { FadeIn } from "@/components/ui/fade-in";
import { Container } from "@/components/layout/container";

export function NotesHero() {
  return (
    <section className="border-b border-line/55 bg-gradient-to-b from-page-elevated/50 to-page/80 pb-10 pt-10 sm:pb-12 sm:pt-11 md:pb-16 md:pt-14 lg:pb-20 lg:pt-16">
      <Container>
        <FadeIn>
          <p className="text-[11px] font-medium uppercase tracking-[0.2em] text-sub md:text-xs">
            心事展示
          </p>
          <h1 className="mt-3 max-w-[20ch] text-[clamp(1.5rem,5.5vw,2.4rem)] font-semibold leading-[1.18] tracking-tight text-ink sm:mt-4 md:mt-5 md:max-w-[18ch] md:leading-[1.2]">
            一些被轻轻放下的话
          </h1>
          <p className="mt-4 max-w-xl text-[15px] leading-[1.72] text-sub sm:mt-5 md:mt-6 md:text-[16px] md:leading-[1.78]">
            它们不需要很大声，也值得被看见。
          </p>
          <p className="mt-3 max-w-xl text-[14px] leading-[1.7] text-sub/92 sm:mt-4 md:mt-5 md:text-[15px] md:leading-[1.75]">
            有些话不需要发出去，也值得被认真放着。
          </p>
          <p className="mt-4 text-[12px] leading-relaxed text-sub/80 sm:mt-5 sm:text-sm">
            以下为官网示例文案，与真实用户数据无关。
          </p>
        </FadeIn>
      </Container>
    </section>
  );
}
