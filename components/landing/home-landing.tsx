"use client";

import Link from "next/link";
import { motion } from "framer-motion";
import { FadeIn } from "./fade-in";

const features = [
  {
    title: "轻松记录心情",
    desc: "几句话就好，把此刻轻轻放下。",
    tint: "from-[rgba(255,255,255,0.85)] to-[#faf5ef]",
  },
  {
    title: "日历回看轨迹",
    desc: "在月历里看见情绪走过的痕迹。",
    tint: "from-[rgba(255,255,255,0.85)] to-[#fdf5f6]",
  },
  {
    title: "写作提示",
    desc: "温柔引导，降低开口的难度。",
    tint: "from-[rgba(255,255,255,0.85)] to-[#f2f8f5]",
  },
  {
    title: "自动保存",
    desc: "草稿悄悄留住，少一份担心。",
    tint: "from-[rgba(255,255,255,0.85)] to-[#f8f4ef]",
  },
  {
    title: "本地优先",
    desc: "文字先属于你与设备，更安心。",
    tint: "from-[rgba(255,255,255,0.85)] to-[#f0f6f3]",
  },
  {
    title: "多端同步",
    desc: "能力随版本迭代，以应用内为准。",
    tint: "from-[rgba(255,255,255,0.85)] to-[#f5f3fa]",
  },
] as const;

const paperCard =
  "rounded-2xl border border-white/55 bg-[rgba(255,255,255,0.7)] shadow-paper backdrop-blur-[12px]";

export function HomeLanding() {
  return (
    <div className="relative overflow-x-hidden bg-transparent">
      {/* Hero */}
      <section className="relative px-5 pb-24 pt-14 md:px-10 md:pb-36 md:pt-24">
        <div className="mx-auto flex max-w-6xl flex-col gap-16 lg:flex-row lg:items-center lg:gap-24">
          <FadeIn className="flex-1">
            <p className="mb-4 text-xs font-medium uppercase tracking-[0.22em] text-sub">
              心情记录
            </p>
            <h1 className="text-[clamp(2.25rem,6vw,3.35rem)] font-semibold leading-[1.15] tracking-tight text-ink">
              心事匣
            </h1>
            <p className="mt-7 max-w-md text-lg leading-[1.75] text-sub">
              一个轻量、安静、低打扰的记录空间
            </p>
            <div className="mt-11 flex flex-wrap gap-4">
              <motion.div whileHover={{ y: -2 }} whileTap={{ scale: 0.98 }}>
                <Link
                  href="/download"
                  className="inline-flex items-center justify-center rounded-full bg-warm px-8 py-3.5 text-[15px] font-medium text-white shadow-warm transition-colors hover:bg-warm-deep"
                >
                  立即体验
                </Link>
              </motion.div>
              <motion.div whileHover={{ y: -2 }} whileTap={{ scale: 0.98 }}>
                <Link
                  href="/features"
                  className={`inline-flex items-center justify-center rounded-full border border-white/60 bg-[rgba(255,255,255,0.55)] px-8 py-3.5 text-[15px] font-medium text-ink shadow-paper backdrop-blur-sm transition-colors hover:border-warm/30 hover:bg-white/75`}
                >
                  查看功能
                </Link>
              </motion.div>
            </div>
          </FadeIn>

          <FadeIn delay={0.06} className="flex flex-1 justify-center lg:justify-end">
            <div className="relative w-full max-w-[340px]">
              <div className={`relative min-h-[300px] overflow-hidden p-9 ${paperCard}`}>
                <div className="absolute -right-12 -top-12 h-40 w-40 rounded-full bg-blush/25 blur-2xl" />
                <div className="absolute -bottom-10 -left-10 h-36 w-36 rounded-full bg-sage/20 blur-2xl" />
                <div className="relative space-y-5">
                  <div className="h-1.5 w-14 rounded-full bg-gradient-to-r from-warm/70 to-warm/40" />
                  <p className="text-sm leading-relaxed text-sub">
                    今天过得怎么样？
                  </p>
                  <div className="flex flex-wrap gap-2">
                    {["淡", "静", "暖", "轻"].map((w) => (
                      <span
                        key={w}
                        className="rounded-full border border-white/60 bg-[rgba(255,255,255,0.5)] px-3 py-1 text-xs text-ink/85"
                      >
                        {w}
                      </span>
                    ))}
                  </div>
                  <div className="rounded-2xl border border-white/50 bg-[rgba(255,255,255,0.45)] p-5">
                    <p className="text-sm italic leading-relaxed text-sub">
                      「写下来，心里就轻一点。」
                    </p>
                  </div>
                </div>
              </div>
            </div>
          </FadeIn>
        </div>
      </section>

      {/* Features */}
      <section className="px-5 py-20 md:px-10 md:py-32">
        <div className="mx-auto max-w-6xl">
          <FadeIn>
            <h2 className="text-center text-2xl font-semibold text-ink md:text-[1.65rem]">
              为你准备的小事
            </h2>
            <p className="mx-auto mt-5 max-w-lg text-center text-[15px] leading-relaxed text-sub">
              不堆砌功能，只保留日常里用得上的温柔。
            </p>
          </FadeIn>
          <div className="mt-16 grid gap-5 sm:grid-cols-2 lg:grid-cols-3">
            {features.map((f, i) => (
              <FadeIn key={f.title} delay={i * 0.04}>
                <motion.div
                  whileHover={{ y: -3 }}
                  transition={{ type: "spring", stiffness: 420, damping: 28 }}
                  className={`h-full rounded-2xl border border-white/50 bg-gradient-to-br p-7 shadow-paper backdrop-blur-[10px] ${f.tint}`}
                >
                  <h3 className="text-lg font-semibold text-ink">{f.title}</h3>
                  <p className="mt-3 text-sm leading-relaxed text-sub">{f.desc}</p>
                </motion.div>
              </FadeIn>
            ))}
          </div>
        </div>
      </section>

      {/* Emotion copy */}
      <section className="px-5 py-20 md:px-10 md:py-28">
        <FadeIn>
          <div
            className={`mx-auto max-w-2xl px-10 py-14 text-center md:px-14 md:py-16 ${paperCard}`}
          >
            <h2 className="text-[clamp(1.35rem,4vw,1.75rem)] font-semibold leading-snug text-ink">
              写下来，轻一点，被留住，更安心
            </h2>
            <p className="mx-auto mt-8 max-w-sm text-[15px] leading-[1.8] text-sub">
              不是社交，不是任务清单
              <br />
              只是一个你可以回来看的地方
            </p>
          </div>
        </FadeIn>
      </section>

      {/* Download */}
      <section className="px-5 pb-28 pt-8 md:px-10 md:pb-36">
        <div className="mx-auto max-w-6xl">
          <FadeIn>
            <h2 className="text-2xl font-semibold text-ink md:text-[1.65rem]">获取方式</h2>
            <p className="mt-4 max-w-md text-[15px] leading-relaxed text-sub">
              当前为测试版本，正式上架后会更新本页。
            </p>
          </FadeIn>
          <div className="mt-14 grid gap-6 md:grid-cols-2">
            <FadeIn delay={0.05}>
              <motion.div
                whileHover={{ y: -3 }}
                transition={{ type: "spring", stiffness: 400, damping: 26 }}
                className={`p-9 ${paperCard}`}
              >
                <p className="text-xs font-medium uppercase tracking-[0.2em] text-warm">
                  iOS
                </p>
                <h3 className="mt-3 text-xl font-semibold text-ink">即将上线</h3>
                <p className="mt-4 text-sm leading-relaxed text-sub">
                  App Store 版本筹备中，敬请期待。
                </p>
              </motion.div>
            </FadeIn>
            <FadeIn delay={0.08}>
              <motion.div
                whileHover={{ y: -3 }}
                transition={{ type: "spring", stiffness: 400, damping: 26 }}
                className={`p-9 ${paperCard}`}
              >
                <p className="text-xs font-medium uppercase tracking-[0.2em] text-[#6d8a7c]">
                  Android
                </p>
                <h3 className="mt-3 text-xl font-semibold text-ink">开发中</h3>
                <p className="mt-4 text-sm leading-relaxed text-sub">
                  正式分发渠道确定后会在此同步说明。
                </p>
              </motion.div>
            </FadeIn>
          </div>
          <FadeIn delay={0.1} className="mt-12 text-center md:text-left">
            <motion.div whileHover={{ y: -1 }}>
              <Link
                href="/download"
                className="text-sm font-medium text-warm-deep underline-offset-[6px] hover:underline"
              >
                查看下载详情 →
              </Link>
            </motion.div>
          </FadeIn>
        </div>
      </section>
    </div>
  );
}
