"use client";

import { useCallback, useId, useRef, useState } from "react";
import { AnimatePresence, motion, useReducedMotion } from "framer-motion";
import { ChevronDown } from "lucide-react";
import { FadeIn } from "@/components/ui/fade-in";
import { SectionTitle } from "@/components/ui/section-title";
import { Container } from "@/components/layout/container";
import type { FaqItem } from "@/lib/data/faqs";
import { cn } from "@/lib/utils/cn";

type Props = { items: FaqItem[]; title?: string; eyebrow?: string };

export function FaqList({
  items,
  title = "常见问题",
  eyebrow = "FAQ",
}: Props) {
  const reduceMotion = useReducedMotion();
  const baseId = useId();
  const [open, setOpen] = useState<number | null>(null);
  const btnRefs = useRef<(HTMLButtonElement | null)[]>([]);

  const toggle = useCallback((i: number) => {
    setOpen((prev) => (prev === i ? null : i));
  }, []);

  const onKeyDown = useCallback(
    (e: React.KeyboardEvent, i: number) => {
      if (e.key === "ArrowDown") {
        e.preventDefault();
        const next = (i + 1) % items.length;
        btnRefs.current[next]?.focus();
        setOpen(next);
      }
      if (e.key === "ArrowUp") {
        e.preventDefault();
        const next = (i - 1 + items.length) % items.length;
        btnRefs.current[next]?.focus();
        setOpen(next);
      }
      if (e.key === "Home") {
        e.preventDefault();
        btnRefs.current[0]?.focus();
        setOpen(0);
      }
      if (e.key === "End") {
        e.preventDefault();
        const last = items.length - 1;
        btnRefs.current[last]?.focus();
        setOpen(last);
      }
    },
    [items.length],
  );

  return (
    <section className="py-14 md:pb-24 md:pt-10 lg:pb-28">
      <Container>
        <FadeIn>
          <SectionTitle eyebrow={eyebrow} title={title} align="center" />
        </FadeIn>
        <div className="mx-auto mt-9 max-w-2xl sm:mt-10 md:mt-11">
          {items.map((item, i) => {
            const isOpen = open === i;
            const panelId = `${baseId}-panel-${i}`;
            const headerId = `${baseId}-header-${i}`;
            return (
              <FadeIn key={item.q} delay={i * 0.04}>
                <div className="border-b border-line/75 first:border-t first:border-line/75">
                  <h3 className="m-0">
                    <button
                      ref={(el) => {
                        btnRefs.current[i] = el;
                      }}
                      type="button"
                      id={headerId}
                      aria-expanded={isOpen}
                      aria-controls={panelId}
                      onClick={() => toggle(i)}
                      onKeyDown={(e) => onKeyDown(e, i)}
                      className={cn(
                        "flex min-h-[52px] w-full items-start justify-between gap-3 py-3.5 text-left transition-colors duration-200 sm:min-h-[56px] sm:gap-4 sm:py-4 md:py-5",
                        "hover:text-ink/90",
                        "focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-accent",
                      )}
                    >
                      <span className="text-[14px] font-semibold leading-snug text-ink sm:text-[15px]">
                        {item.q}
                      </span>
                      <ChevronDown
                        className={cn(
                          "mt-0.5 h-5 w-5 shrink-0 text-sub transition-transform duration-300 ease-soft",
                          isOpen && "rotate-180 text-ink/70",
                        )}
                        strokeWidth={1.5}
                        aria-hidden
                      />
                    </button>
                  </h3>
                  <AnimatePresence initial={false}>
                    {isOpen ? (
                      <motion.div
                        id={panelId}
                        role="region"
                        aria-labelledby={headerId}
                        initial={reduceMotion ? { opacity: 0 } : { height: 0, opacity: 0 }}
                        animate={
                          reduceMotion
                            ? { opacity: 1 }
                            : { height: "auto", opacity: 1 }
                        }
                        exit={reduceMotion ? { opacity: 0 } : { height: 0, opacity: 0 }}
                        transition={{
                          duration: reduceMotion ? 0.15 : 0.34,
                          ease: [0.25, 0.46, 0.45, 0.94],
                        }}
                        className="overflow-hidden"
                      >
                        <div className="pb-4 pr-1 text-[13px] leading-[1.75] text-sub sm:pb-5 sm:pr-2 sm:text-sm md:pb-6 md:pr-8">
                          {item.a}
                        </div>
                      </motion.div>
                    ) : null}
                  </AnimatePresence>
                </div>
              </FadeIn>
            );
          })}
        </div>
      </Container>
    </section>
  );
}
