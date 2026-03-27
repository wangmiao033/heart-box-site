"use client";

import { FadeIn } from "@/components/ui/fade-in";
import { Container } from "@/components/layout/container";

export function DownloadHero() {
  return (
    <section className="border-b border-line/55 bg-gradient-to-b from-page-elevated/45 to-page/70 pb-16 pt-12 md:pb-24 md:pt-20">
      <Container>
        <FadeIn>
          <p className="text-xs font-medium uppercase tracking-[0.22em] text-sub">
            下载
          </p>
          <h1 className="mt-5 text-[clamp(1.85rem,4.2vw,2.45rem)] font-semibold leading-[1.22] tracking-tight text-ink">
            获取心事匣
          </h1>
          <p className="mt-8 max-w-xl text-[16px] leading-[1.75] text-sub">
            当前为测试与筹备阶段，商店链接就绪后会第一时间更新本页。
          </p>
        </FadeIn>
      </Container>
    </section>
  );
}
