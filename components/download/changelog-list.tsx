"use client";

import { FadeIn } from "@/components/ui/fade-in";
import { Container } from "@/components/layout/container";
import { changelogEntries } from "@/lib/data/changelog";

export function ChangelogList() {
  return (
    <section className="border-t border-line/60 bg-page-elevated/35 py-20 md:py-28">
      <Container>
        <FadeIn>
          <h2 className="text-center text-xl font-semibold tracking-tight text-ink md:text-2xl">
            更新日志
          </h2>
          <p className="mx-auto mt-4 max-w-md text-center text-sm leading-relaxed text-sub">
            以下为示例条目，便于展示版式；实际上线后以真实发布记录为准。
          </p>
        </FadeIn>
        <div className="relative mx-auto mt-16 max-w-2xl">
          <div
            className="absolute left-[11px] top-3 bottom-3 hidden w-px bg-gradient-to-b from-line/30 via-accent-muted/40 to-line/20 md:block"
            aria-hidden
          />
          <ol className="relative space-y-12 md:space-y-14">
            {changelogEntries.map((entry, i) => (
              <FadeIn key={entry.version} delay={i * 0.06}>
                <li className="relative md:pl-10">
                  <span
                    className="absolute left-0 top-2 hidden h-2.5 w-2.5 rounded-full border-2 border-card bg-accent/80 shadow-paper md:block"
                    aria-hidden
                  />
                  <article className="rounded-card-md border border-line/95 bg-card p-6 shadow-paper md:p-8">
                    <div className="flex flex-wrap items-baseline gap-x-3 gap-y-1">
                      <span className="text-lg font-semibold tracking-tight text-ink">
                        v{entry.version}
                      </span>
                      <time
                        className="text-sm text-sub"
                        dateTime={entry.date}
                      >
                        {entry.date}
                      </time>
                    </div>
                    <ul className="mt-5 space-y-3 border-t border-line/45 pt-5 text-sm leading-[1.72] text-sub">
                      {entry.items.map((line) => (
                        <li key={line} className="flex gap-3 pl-0.5">
                          <span
                            className="mt-2 h-1 w-1 shrink-0 rounded-full bg-accent/60"
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
