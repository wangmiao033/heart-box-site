"use client";

import { FadeIn } from "@/components/ui/fade-in";
import { PaperCard } from "@/components/ui/paper-card";
import { Container } from "@/components/layout/container";
import { cn } from "@/lib/utils/cn";

export function VersionCard() {
  return (
    <section className="pb-20 md:pb-28">
      <Container>
        <FadeIn>
          <h2 className="text-center text-xl font-semibold tracking-tight text-ink md:text-2xl">
            版本说明
          </h2>
        </FadeIn>
        <FadeIn delay={0.06} className="mx-auto mt-10 max-w-2xl">
          <PaperCard padding="lg" className="relative overflow-hidden">
            <div
              className="pointer-events-none absolute inset-0 texture-noise opacity-20"
              aria-hidden
            />
            <div className="relative flex flex-wrap items-center gap-2 border-b border-line/50 pb-6">
              <span
                className={cn(
                  "rounded-full border border-accent-muted/50 bg-accent/15 px-3 py-1 text-xs font-semibold text-ink",
                )}
              >
                v0.3.0
              </span>
              <span className="rounded-full border border-line/90 bg-page-elevated px-3 py-1 text-xs text-sub">
                内测
              </span>
              <time
                className="ml-auto text-xs text-sub md:text-sm"
                dateTime="2025-03-20"
              >
                更新 · 2025-03-20
              </time>
            </div>
            <dl className="relative mt-8 space-y-8 text-[15px]">
              <div>
                <dt className="text-xs font-medium uppercase tracking-[0.12em] text-sub/80">
                  测试说明
                </dt>
                <dd className="mt-3 leading-[1.75] text-ink/90">
                  功能与文案可能随版本调整；若你通过内测渠道安装，请以应用内「关于」为准。
                </dd>
              </div>
              <div>
                <dt className="text-xs font-medium uppercase tracking-[0.12em] text-sub/80">
                  兼容性
                </dt>
                <dd className="mt-3 leading-[1.75] text-ink/90">
                  iOS 与 Android
                  的最低系统要求以商店页与安装包说明为准；旧机型可能出现部分动效降级。
                </dd>
              </div>
            </dl>
          </PaperCard>
        </FadeIn>
      </Container>
    </section>
  );
}
