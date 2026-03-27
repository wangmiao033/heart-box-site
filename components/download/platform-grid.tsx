"use client";

import { Apple, Globe, Smartphone } from "lucide-react";
import { motion, useReducedMotion } from "framer-motion";
import { FadeIn } from "@/components/ui/fade-in";
import { SectionTitle } from "@/components/ui/section-title";
import { Container } from "@/components/layout/container";
import {
  platformCards,
  type PlatformStatus,
} from "@/lib/data/downloads";
import { cn } from "@/lib/utils/cn";

const icons = {
  apple: Apple,
  android: Smartphone,
  globe: Globe,
} as const;

function statusBadgeClass(status: PlatformStatus) {
  switch (status) {
    case "即将上线":
      return "border-accent-muted/55 bg-accent/18 text-ink shadow-[inset_0_1px_0_rgba(255,255,255,0.5)]";
    case "开发中":
      return "border-line bg-page-elevated text-sub";
    case "测试中":
      return "border-line bg-card text-ink";
    case "规划中":
    default:
      return "border-dashed border-sub/30 bg-transparent text-sub";
  }
}

export function PlatformGrid() {
  const reduceMotion = useReducedMotion();

  return (
    <section className="py-14 md:py-20 lg:py-24">
      <Container>
        <FadeIn>
          <SectionTitle
            eyebrow="平台"
            title="选择你的设备"
            align="center"
          />
        </FadeIn>
        <div className="mt-9 grid gap-3.5 sm:mt-10 md:grid-cols-3 md:gap-4 lg:mt-11 lg:gap-5">
          {platformCards.map((p, i) => {
            const Icon = icons[p.icon];
            return (
              <FadeIn key={p.id} delay={i * 0.05}>
                <motion.article
                  className={cn(
                    "relative flex h-full flex-col overflow-hidden rounded-card-md border border-line/95 bg-card p-5 shadow-paper sm:p-6 md:p-7",
                    "transition-[transform,box-shadow] duration-500 ease-soft hover:-translate-y-0.5 hover:shadow-paper-hover",
                    p.status === "即将上线" &&
                      "ring-1 ring-[#FFE8D4]/60 ring-offset-2 ring-offset-page",
                  )}
                  whileHover={reduceMotion ? undefined : { y: -2 }}
                  transition={{ type: "spring", stiffness: 400, damping: 28 }}
                >
                  <div
                    className="pointer-events-none absolute -right-12 top-0 h-28 w-28 rounded-full bg-[#FFF4E6]/35 blur-2xl sm:h-32 sm:w-32"
                    aria-hidden
                  />
                  <div className="relative flex h-10 w-10 items-center justify-center rounded-control border border-line/80 bg-page-elevated/90 text-accent sm:h-11 sm:w-11">
                    <Icon className="h-8 w-8 sm:h-9 sm:w-9" strokeWidth={1.25} />
                  </div>
                  <h3 className="relative mt-4 text-base font-semibold tracking-tight text-ink sm:mt-5 sm:text-lg">
                    {p.name}
                  </h3>
                  <p
                    className={cn(
                      "relative mt-2 inline-flex w-fit rounded-full border px-2.5 py-0.5 text-[11px] font-medium sm:mt-2.5 sm:px-3 sm:py-1 sm:text-xs",
                      statusBadgeClass(p.status),
                    )}
                  >
                    {p.status}
                  </p>
                  <p className="relative mt-3 flex-1 text-[13px] leading-[1.72] text-sub sm:mt-4 sm:text-sm sm:leading-[1.72]">
                    {p.description}
                  </p>
                  <div className="relative mt-4 sm:mt-5">
                    <span
                      className={cn(
                        "inline-flex min-h-[44px] w-full items-center justify-center rounded-full border border-line/90 bg-page-elevated/80 px-3 py-2.5 text-[13px] text-sub sm:min-h-[40px] sm:px-4 sm:text-sm",
                        p.status === "即将上线" && "border-accent-muted/40 text-ink/80",
                      )}
                    >
                      {p.status === "即将上线"
                        ? "上架后将开放下载"
                        : p.status === "开发中"
                          ? "敬请期待后续公告"
                          : "保持关注即可"}
                    </span>
                  </div>
                </motion.article>
              </FadeIn>
            );
          })}
        </div>
      </Container>
    </section>
  );
}
