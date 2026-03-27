"use client";

import { useCallback, useEffect, useRef, useState } from "react";
import { AnimatePresence, motion, useReducedMotion } from "framer-motion";
import { Heart } from "lucide-react";
import { FadeIn } from "@/components/ui/fade-in";
import { Modal } from "@/components/ui/modal";
import { NotebookTextarea } from "@/components/ui/notebook-textarea";
import { PaperCard } from "@/components/ui/paper-card";
import { SectionTitle } from "@/components/ui/section-title";
import { Container } from "@/components/layout/container";
import { randomAfterPlaceQuote } from "@/lib/data/healing-quotes";
import { cn } from "@/lib/utils/cn";

type FlyPayload = {
  key: number;
  x0: number;
  y0: number;
  x1: number;
  y1: number;
  preview: string;
};

export function HeartBoxInteractive() {
  const [value, setValue] = useState("");
  const [tip, setTip] = useState<string | null>(null);
  const [fly, setFly] = useState<FlyPayload | null>(null);
  const [boxGlow, setBoxGlow] = useState(false);
  const [modalOpen, setModalOpen] = useState(false);

  const areaRef = useRef<HTMLDivElement>(null);
  const boxRef = useRef<HTMLButtonElement>(null);
  const reduceMotion = useReducedMotion();

  useEffect(() => {
    if (!tip) return;
    const t = window.setTimeout(() => setTip(null), 4200);
    return () => window.clearTimeout(t);
  }, [tip]);

  const handlePlace = useCallback(() => {
    const trimmed = value.trim();
    if (!trimmed || !areaRef.current || !boxRef.current) return;

    const tr = areaRef.current.getBoundingClientRect();
    const br = boxRef.current.getBoundingClientRect();

    setFly({
      key: Date.now(),
      x0: tr.left + tr.width / 2,
      y0: tr.top + tr.height / 2,
      x1: br.left + br.width / 2,
      y1: br.top + br.height / 2,
      preview: trimmed.length > 36 ? `${trimmed.slice(0, 36)}…` : trimmed,
    });
  }, [value]);

  const onFlyComplete = useCallback(() => {
    setFly(null);
    setValue("");
    setTip(randomAfterPlaceQuote());
    setBoxGlow(true);
    window.setTimeout(() => setBoxGlow(false), 1100);
  }, []);

  const disabled = !value.trim();
  const flyDuration = reduceMotion ? 0.28 : 0.78;
  const flyEase = [0.2, 0.85, 0.32, 1] as const;

  return (
    <section className="py-20 md:py-28">
      <Container>
        <FadeIn>
          <SectionTitle
            eyebrow="互动"
            title="把心里的一句话，先放进匣子里"
            subtitle="只是演示：不会上传到服务器，刷新页面就会消失。"
            align="center"
          />
        </FadeIn>

        <FadeIn delay={0.08} className="mt-14 md:mt-16">
          <div className="mx-auto grid max-w-4xl gap-10 lg:grid-cols-[1fr_220px] lg:items-start lg:gap-12">
            <PaperCard padding="lg" className="relative overflow-hidden">
              <div
                className="pointer-events-none absolute -right-20 -top-24 h-48 w-48 rounded-full bg-[#FFE8D4]/30 blur-3xl"
                aria-hidden
              />
              <div ref={areaRef} className="relative">
                <NotebookTextarea
                  value={value}
                  onChange={(e) => setValue(e.target.value)}
                  placeholder="写一句就好……可以是心情、念头，或今天一件很小的事。"
                  rows={5}
                />
              </div>
              <div className="relative mt-6 flex min-h-[52px] flex-wrap items-center gap-4">
                <motion.button
                  type="button"
                  onClick={handlePlace}
                  disabled={disabled}
                  className={cn(
                    "inline-flex min-h-[48px] items-center justify-center rounded-full px-9 py-3 text-[15px] font-medium tracking-tight text-ink",
                    "bg-accent shadow-paper transition-[transform,box-shadow,opacity,background-color] duration-300 ease-soft",
                    "focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-accent",
                    !disabled &&
                      "hover:-translate-y-0.5 hover:bg-[#E5B59A] hover:shadow-paper-hover active:translate-y-0 active:scale-[0.98]",
                    disabled &&
                      "cursor-not-allowed opacity-42 shadow-none saturate-[0.85]",
                  )}
                  whileTap={disabled || reduceMotion ? undefined : { scale: 0.98 }}
                >
                  放进去
                </motion.button>
                <div className="relative min-h-[24px] flex-1">
                  <AnimatePresence mode="wait">
                    {tip ? (
                      <motion.p
                        key={tip}
                        role="status"
                        aria-live="polite"
                        initial={{ opacity: 0, y: 6 }}
                        animate={{ opacity: 1, y: 0 }}
                        exit={{ opacity: 0, y: -4 }}
                        transition={{
                          duration: reduceMotion ? 0.12 : 0.38,
                          ease: flyEase,
                        }}
                        className="text-sm leading-relaxed text-sub"
                      >
                        {tip}
                      </motion.p>
                    ) : null}
                  </AnimatePresence>
                </div>
              </div>
            </PaperCard>

            <div className="flex flex-col items-center gap-3 lg:pt-2">
              <p className="text-center text-xs tracking-wide text-sub lg:text-left">
                心事匣
              </p>
              <motion.button
                ref={boxRef}
                type="button"
                onClick={() => setModalOpen(true)}
                animate={
                  boxGlow
                    ? { scale: [1, 1.045, 1] }
                    : reduceMotion
                      ? {}
                      : { scale: [1, 1.012, 1] }
                }
                transition={
                  boxGlow
                    ? { duration: 0.55, ease: flyEase }
                    : {
                        duration: 4.2,
                        repeat: Infinity,
                        ease: "easeInOut",
                      }
                }
                className={cn(
                  "relative flex h-44 w-44 flex-col items-center justify-center rounded-card border-2 border-line/95 bg-page-elevated shadow-paper",
                  "transition-[box-shadow,border-color] duration-500 ease-soft",
                  "hover:border-accent-muted/60 hover:shadow-paper-hover",
                  "focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-accent",
                  boxGlow &&
                    "shadow-glow ring-2 ring-[#FFE8D4]/90 ring-offset-2 ring-offset-page",
                )}
                whileHover={reduceMotion ? undefined : { y: -2 }}
                whileTap={{ scale: 0.98 }}
                aria-label="打开心事匣说明"
              >
                <div
                  className="pointer-events-none absolute inset-3 rounded-[18px] bg-gradient-to-b from-white/55 to-transparent opacity-90"
                  aria-hidden
                />
                <Heart
                  className="relative z-[1] h-12 w-12 text-accent"
                  strokeWidth={1.25}
                  fill="rgba(231, 191, 167, 0.22)"
                />
                <span className="relative z-[1] mt-3 text-xs text-sub">
                  点我看看
                </span>
              </motion.button>
            </div>
          </div>
        </FadeIn>
      </Container>

      <AnimatePresence>
        {fly ? (
          <motion.div
            key={fly.key}
            className="pointer-events-none fixed z-[60] max-w-[220px] -translate-x-1/2 -translate-y-1/2 truncate rounded-control border border-line/90 bg-[#FDFBF8] px-3.5 py-2.5 text-left text-xs leading-snug text-ink shadow-paper-hover"
            style={{ transformOrigin: "center center" }}
            initial={{
              left: fly.x0,
              top: fly.y0,
              opacity: 1,
              scale: 1,
              rotate: reduceMotion ? 0 : -2,
            }}
            animate={{
              left: fly.x1,
              top: fly.y1,
              opacity: 0.08,
              scale: reduceMotion ? 0.45 : 0.34,
              rotate: reduceMotion ? 0 : 5,
            }}
            transition={{ duration: flyDuration, ease: flyEase }}
            onAnimationComplete={onFlyComplete}
          >
            {fly.preview}
          </motion.div>
        ) : null}
      </AnimatePresence>

      <Modal open={modalOpen} onClose={() => setModalOpen(false)} title="心事匣">
        <div className="space-y-5">
          <p className="rounded-control border border-line/60 bg-page-elevated/80 px-4 py-3 text-[15px] leading-[1.75] text-ink/90">
            你放下的那些小事，都在这里。
          </p>
          <p className="text-sm leading-[1.72] text-sub">
            在真实的 App
            里，它们会安静地躺在你的设备与账号里；这里只是官网上的温柔示意。
          </p>
          <p className="text-xs leading-relaxed text-sub/85">
            像把纸条折好、放进抽屉——不急着整理，也很好。
          </p>
        </div>
      </Modal>
    </section>
  );
}
