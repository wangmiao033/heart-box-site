"use client";

import { FadeIn } from "@/components/ui/fade-in";
import { PaperCard } from "@/components/ui/paper-card";
import { Container } from "@/components/layout/container";
import { cn } from "@/lib/utils/cn";

export function VersionCard() {
  return (
    <section className="pb-14 md:pb-20 lg:pb-24">
      <Container>
        <FadeIn>
          <h2 className="text-center text-lg font-semibold tracking-tight text-ink sm:text-xl md:text-2xl">
            版本说明
          </h2>
        </FadeIn>
        <FadeIn delay={0.05} className="mx-auto mt-8 max-w-2xl sm:mt-9 md:mt-10">
          <PaperCard padding="lg" className="relative overflow-hidden">
            <div
              className="pointer-events-none absolute inset-0 texture-noise opacity-20"
              aria-hidden
            />
            <div className="relative flex flex-col gap-3 border-b border-line/50 pb-4 sm:flex-row sm:flex-wrap sm:items-center sm:gap-2 sm:pb-5 md:pb-6">
              <div className="flex flex-wrap items-center gap-2">
                <span
                  className={cn(
                    "rounded-full border border-accent-muted/50 bg-accent/15 px-2.5 py-0.5 text-[11px] font-semibold text-ink sm:px-3 sm:py-1 sm:text-xs",
                  )}
                >
                  v0.3.0
                </span>
                <span className="rounded-full border border-line/90 bg-page-elevated px-2.5 py-0.5 text-[11px] text-sub sm:px-3 sm:py-1 sm:text-xs">
                  内测
                </span>
              </div>
              <time
                className="text-[11px] text-sub sm:ml-auto sm:text-xs md:text-sm"
                dateTime="2025-03-20"
              >
                更新 · 2025-03-20
              </time>
            </div>
            <dl className="relative mt-6 space-y-6 text-[14px] sm:mt-7 sm:space-y-7 sm:text-[15px] md:mt-8 md:space-y-8">
              <div>
                <dt className="text-[11px] font-medium uppercase tracking-[0.1em] text-sub/80 sm:text-xs sm:tracking-[0.12em]">
                  测试说明
                </dt>
                <dd className="mt-2 leading-[1.72] text-ink/90 sm:mt-2.5 sm:leading-[1.75] md:mt-3">
                  功能与文案可能随版本调整；若你通过内测渠道安装，请以应用内「关于」为准。
                </dd>
              </div>
              <div>
                <dt className="text-[11px] font-medium uppercase tracking-[0.1em] text-sub/80 sm:text-xs sm:tracking-[0.12em]">
                  兼容性
                </dt>
                <dd className="mt-2 leading-[1.72] text-ink/90 sm:mt-2.5 sm:leading-[1.75] md:mt-3">
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
