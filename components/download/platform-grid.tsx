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
    <section className="py-20 md:py-28">
      <Container>
        <FadeIn>
          <SectionTitle
            eyebrow="平台"
            title="选择你的设备"
            align="center"
          />
        </FadeIn>
        <div className="mt-14 grid gap-6 md:grid-cols-3 md:gap-7">
          {platformCards.map((p, i) => {
            const Icon = icons[p.icon];
            return (
              <FadeIn key={p.id} delay={i * 0.05}>
                <motion.article
                  className={cn(
                    "relative flex h-full flex-col overflow-hidden rounded-card-md border border-line/95 bg-card p-8 shadow-paper",
                    "transition-[transform,box-shadow] duration-500 ease-soft hover:-translate-y-0.5 hover:shadow-paper-hover",
                    p.status === "即将上线" &&
                      "ring-1 ring-[#FFE8D4]/60 ring-offset-2 ring-offset-page",
                  )}
                  whileHover={reduceMotion ? undefined : { y: -2 }}
                  transition={{ type: "spring", stiffness: 400, damping: 28 }}
                >
                  <div
                    className="pointer-events-none absolute -right-12 top-0 h-32 w-32 rounded-full bg-[#FFF4E6]/35 blur-2xl"
                    aria-hidden
                  />
                  <div className="relative flex h-11 w-11 items-center justify-center rounded-control border border-line/80 bg-page-elevated/90 text-accent">
                    <Icon className="h-9 w-9" strokeWidth={1.25} />
                  </div>
                  <h3 className="relative mt-5 text-lg font-semibold tracking-tight text-ink">
                    {p.name}
                  </h3>
                  <p
                    className={cn(
                      "relative mt-3 inline-flex w-fit rounded-full border px-3 py-1 text-xs font-medium",
                      statusBadgeClass(p.status),
                    )}
                  >
                    {p.status}
                  </p>
                  <p className="relative mt-5 flex-1 text-sm leading-[1.72] text-sub">
                    {p.description}
                  </p>
                  <div className="relative mt-6">
                    <span
                      className={cn(
                        "inline-flex min-h-[40px] w-full items-center justify-center rounded-full border border-line/90 bg-page-elevated/80 px-4 text-sm text-sub",
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
