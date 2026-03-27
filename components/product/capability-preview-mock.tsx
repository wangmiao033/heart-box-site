"use client";

import { cn } from "@/lib/utils/cn";

type Props = { variant: number; className?: string };

/** 示意用「产品预览」块，非真实界面 */
export function CapabilityPreviewMock({ variant, className }: Props) {
  const v = variant % 3;
  return (
    <div
      className={cn(
        "relative min-h-[200px] w-full overflow-hidden rounded-card-md border border-line/90 bg-[#FDFBF8] shadow-paper",
        "before:pointer-events-none before:absolute before:inset-0 before:bg-paper-lines before:opacity-35",
        className,
      )}
    >
      <div
        className="pointer-events-none absolute inset-0 texture-noise opacity-30 mix-blend-multiply"
        aria-hidden
      />
      <div className="relative flex h-full flex-col p-5">
        {v === 0 ? (
          <>
            <div className="mb-3 flex items-center gap-2">
              <span className="h-2 w-2 rounded-full bg-accent/70" />
              <span className="h-2 w-16 rounded-full bg-line" />
            </div>
            <div className="flex-1 space-y-2.5 rounded-control border border-line/70 bg-card/90 p-4 shadow-[inset_0_1px_0_rgba(255,255,255,0.9)]">
              <div className="h-2 w-3/4 max-w-[200px] rounded-full bg-ink/8" />
              <div className="h-2 w-full max-w-[240px] rounded-full bg-ink/6" />
              <div className="h-2 w-5/6 max-w-[180px] rounded-full bg-ink/6" />
              <div className="mt-4 h-8 w-24 rounded-full bg-accent/35" />
            </div>
          </>
        ) : null}
        {v === 1 ? (
          <>
            <div className="mb-4 grid grid-cols-7 gap-1.5">
              {Array.from({ length: 7 }).map((_, i) => (
                <span
                  key={i}
                  className={cn(
                    "aspect-square rounded-md border border-line/60",
                    i === 3 ? "bg-accent/30" : "bg-page-elevated/80",
                  )}
                />
              ))}
            </div>
            <div className="flex flex-1 flex-col justify-end gap-2 rounded-control border border-line/70 bg-card/90 p-4">
              <div className="h-2 w-2/3 rounded-full bg-ink/7" />
              <div className="h-2 w-full rounded-full bg-ink/5" />
            </div>
          </>
        ) : null}
        {v === 2 ? (
          <div className="flex flex-1 flex-col gap-3">
            <div className="flex gap-2">
              <span className="rounded-full bg-accent/25 px-2.5 py-1 text-[10px] text-sub">
                提示
              </span>
              <span className="rounded-full border border-line/80 px-2.5 py-1 text-[10px] text-sub">
                草稿
              </span>
            </div>
            <div className="flex-1 rounded-control border border-dashed border-line/80 bg-page-elevated/50 p-4">
              <div className="space-y-2">
                <div className="h-2 w-full rounded-full bg-ink/6" />
                <div className="h-2 w-4/5 rounded-full bg-ink/5" />
              </div>
            </div>
          </div>
        ) : null}
      </div>
    </div>
  );
}
