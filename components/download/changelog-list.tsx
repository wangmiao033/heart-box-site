"use client";

import { FadeIn } from "@/components/ui/fade-in";
import { Container } from "@/components/layout/container";
import { changelogEntries } from "@/lib/data/changelog";

export function ChangelogList() {
  return (
    <section className="border-t border-line/60 bg-page-elevated/35 py-14 md:py-20 lg:py-24">
      <Container>
        <FadeIn>
          <h2 className="text-center text-lg font-semibold tracking-tight text-ink sm:text-xl md:text-2xl">
            更新日志
          </h2>
          <p className="mx-auto mt-3 max-w-md px-1 text-center text-[13px] leading-relaxed text-sub sm:mt-4 sm:text-sm">
            以下为示例条目，便于展示版式；实际上线后以真实发布记录为准。
          </p>
        </FadeIn>
        <div className="relative mx-auto mt-10 max-w-2xl sm:mt-12 md:mt-14">
          <div
            className="absolute bottom-4 left-[10px] top-3 hidden w-px bg-gradient-to-b from-line/30 via-accent-muted/40 to-line/20 sm:left-[11px] sm:block"
            aria-hidden
          />
          <ol className="relative space-y-8 sm:space-y-9 md:space-y-10 lg:space-y-12">
            {changelogEntries.map((entry, i) => (
              <FadeIn key={entry.version} delay={i * 0.06}>
                <li className="relative sm:pl-9 md:pl-10">
                  <span
                    className="absolute left-0 top-2 hidden h-2 w-2 rounded-full border-2 border-card bg-accent/80 shadow-paper sm:block sm:h-2.5 sm:w-2.5"
                    aria-hidden
                  />
                  <article className="rounded-card-md border border-line/95 bg-card p-4 shadow-paper sm:p-6 md:p-7 lg:p-8">
                    <div className="flex flex-wrap items-baseline gap-x-2 gap-y-1 sm:gap-x-3">
                      <span className="text-base font-semibold tracking-tight text-ink sm:text-lg">
                        v{entry.version}
                      </span>
                      <time
                        className="text-[13px] text-sub sm:text-sm"
                        dateTime={entry.date}
                      >
                        {entry.date}
                      </time>
                    </div>
                    <ul className="mt-4 space-y-3 border-t border-line/45 pt-4 text-[13px] leading-[1.78] text-sub sm:mt-5 sm:space-y-3.5 sm:pt-5 sm:text-sm sm:leading-[1.8]">
                      {entry.items.map((line) => (
                        <li key={line} className="flex gap-2.5 pl-0.5 sm:gap-3">
                          <span
                            className="mt-2 h-1 w-1 shrink-0 rounded-full bg-accent/60 sm:mt-2.5"
                            aria-hidden
                          />
                          <span>{line}</span>
                        </li>
                      ))}
                    </ul>
                  </article>
                </li>
              </FadeIn>
            ))}
          </ol>
        </div>
      </Container>
    </section>
  );
}
