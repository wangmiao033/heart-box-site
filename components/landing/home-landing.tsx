"use client";

import Link from "next/link";
import { motion } from "framer-motion";
import { AmbientOrbs } from "./ambient-orbs";
import { FadeIn } from "./fade-in";

const features = [
  {
    title: "轻松记录心情",
    desc: "几句话就好，把此刻轻轻放下。",
    tint: "from-white/70 to-[#f3f0ff]",
  },
  {
    title: "日历回看轨迹",
    desc: "在月历里看见情绪走过的痕迹。",
    tint: "from-white/70 to-[#fff5f8]",
  },
  {
    title: "写作提示",
    desc: "温柔引导，降低开口的难度。",
    tint: "from-white/70 to-[#eefaf8]",
  },
  {
    title: "自动保存",
    desc: "草稿悄悄留住，少一份担心。",
    tint: "from-white/70 to-[#f3f0ff]",
  },
  {
    title: "本地优先",
    desc: "文字先属于你与设备，更安心。",
    tint: "from-white/70 to-[#eefaf8]",
  },
  {
    title: "多端同步",
    desc: "能力随版本迭代，以应用内为准。",
    tint: "from-white/70 to-[#fff5f8]",
  },
] as const;

const glassCard =
  "rounded-[20px] border border-white/30 bg-white/60 shadow-glass backdrop-blur-[20px]";

export function HomeLanding() {
  return (
    <div className="relative overflow-x-hidden bg-page">
      <AmbientOrbs />

      {/* Hero */}
      <section className="relative px-5 pb-16 pt-10 md:px-8 md:pb-24 md:pt-16">
        <div className="mx-auto flex max-w-6xl flex-col gap-12 lg:flex-row lg:items-center lg:gap-16">
          <FadeIn className="flex-1">
            <p className="mb-3 text-xs font-medium uppercase tracking-[0.2em] text-sub">
              心情记录
            </p>
            <h1 className="text-[clamp(2.25rem,6vw,3.5rem)] font-semibold leading-[1.12] tracking-tight text-ink">
              心事匣
            </h1>
            <p className="mt-5 max-w-md text-lg leading-relaxed text-sub">
              一个轻量、安静、低打扰的记录空间
            </p>
            <div className="mt-8 flex flex-wrap gap-3">
              <motion.div whileHover={{ scale: 1.03 }} whileTap={{ scale: 0.98 }}>
                <Link
                  href="/download"
                  className="inline-flex items-center justify-center rounded-full bg-gradient-to-r from-brand via-[#9d8fff] to-[#b8a9ff] px-7 py-3.5 text-[15px] font-medium text-white shadow-lift transition-shadow hover:shadow-[0_16px_40px_rgba(139,124,255,0.28)]"
                >
                  立即体验
                </Link>
              </motion.div>
              <motion.div whileHover={{ scale: 1.03 }} whileTap={{ scale: 0.98 }}>
                <Link
                  href="/features"
                  className={`inline-flex items-center justify-center rounded-full px-7 py-3.5 text-[15px] font-medium text-ink ${glassCard} hover:border-white/50 hover:bg-white/75`}
                >
                  查看功能
                </Link>
              </motion.div>
            </div>
          </FadeIn>

          <FadeIn delay={0.08} className="flex flex-1 justify-center lg:justify-end">
            <div className="relative w-full max-w-[340px]">
              <div
                className={`relative overflow-hidden p-8 ${glassCard} min-h-[280px]`}
              >
                <div className="absolute -right-16 -top-16 h-48 w-48 rounded-full bg-brand/25 blur-3xl" />
                <div className="absolute -bottom-12 -left-8 h-40 w-40 rounded-full bg-blush/30 blur-3xl" />
                <div className="relative space-y-4">
                  <div className="h-2 w-12 rounded-full bg-gradient-to-r from-brand/60 to-mint/50" />
                  <p className="text-sm leading-relaxed text-sub">
                    今天过得怎么样？
                  </p>
                  <div className="flex gap-2">
                    {["淡", "静", "暖", "轻"].map((w) => (
                      <span
                        key={w}
                        className="rounded-full border border-white/40 bg-white/40 px-3 py-1 text-xs text-ink/80 backdrop-blur-sm"
                      >
                        {w}
                      </span>
                    ))}
                  </div>
                  <div className="rounded-2xl border border-white/35 bg-white/35 p-4 backdrop-blur-md">
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

      {/* Features 2×3 */}
      <section className="px-5 py-12 md:px-8 md:py-16">
        <div className="mx-auto max-w-6xl">
          <FadeIn>
            <h2 className="text-center text-2xl font-semibold text-ink md:text-3xl">
              为你准备的小事
            </h2>
            <p className="mx-auto mt-3 max-w-lg text-center text-sub">
              不堆砌功能，只保留日常里用得上的温柔。
            </p>
          </FadeIn>
          <div className="mt-12 grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
            {features.map((f, i) => (
              <FadeIn key={f.title} delay={i * 0.05}>
                <motion.div
                  whileHover={{ scale: 1.03, y: -6 }}
                  transition={{ type: "spring", stiffness: 400, damping: 24 }}
                  className={`h-full rounded-[20px] border border-white/30 bg-gradient-to-br p-6 shadow-glass backdrop-blur-[20px] ${f.tint}`}
                >
                  <h3 className="text-lg font-semibold text-ink">{f.title}</h3>
                  <p className="mt-2 text-sm leading-relaxed text-sub">{f.desc}</p>
                </motion.div>
              </FadeIn>
            ))}
          </div>
        </div>
      </section>

      {/* Emotion copy */}
      <section className="px-5 py-16 md:px-8 md:py-20">
        <FadeIn>
          <div
            className={`mx-auto max-w-3xl px-8 py-12 text-center md:px-12 md:py-14 ${glassCard}`}
          >
            <h2 className="text-[clamp(1.35rem,4vw,1.85rem)] font-semibold leading-snug text-ink">
              写下来，轻一点，被留住，更安心
            </h2>
            <p className="mx-auto mt-6 max-w-md text-sub leading-relaxed">
              不是社交，不是任务清单
              <br />
              只是一个你可以回来看的地方
            </p>
          </div>
        </FadeIn>
      </section>

      {/* Download */}
      <section className="px-5 py-16 md:px-8 md:py-20">
        <div className="mx-auto max-w-6xl">
          <FadeIn>
            <h2 className="text-2xl font-semibold text-ink md:text-3xl">获取方式</h2>
            <p className="mt-2 text-sub">当前为测试版本，正式上架后会更新本页。</p>
          </FadeIn>
          <div className="mt-10 grid gap-4 md:grid-cols-2">
            <FadeIn delay={0.05}>
              <motion.div
                whileHover={{ y: -4 }}
                className={`p-8 ${glassCard}`}
              >
                <p className="text-xs font-medium uppercase tracking-widest text-brand">
                  iOS
                </p>
                <h3 className="mt-2 text-xl font-semibold text-ink">即将上线</h3>
                <p className="mt-3 text-sm leading-relaxed text-sub">
                  App Store 版本筹备中，敬请期待。
                </p>
              </motion.div>
            </FadeIn>
            <FadeIn delay={0.1}>
              <motion.div
                whileHover={{ y: -4 }}
                className={`p-8 ${glassCard}`}
              >
                <p className="text-xs font-medium uppercase tracking-widest text-mint">
                  Android
                </p>
                <h3 className="mt-2 text-xl font-semibold text-ink">开发中</h3>
                <p className="mt-3 text-sm leading-relaxed text-sub">
                  正式分发渠道确定后会在此同步说明。
                </p>
              </motion.div>
            </FadeIn>
          </div>
          <FadeIn delay={0.12} className="mt-8 text-center">
            <motion.div whileHover={{ scale: 1.02 }} whileTap={{ scale: 0.98 }}>
              <Link
                href="/download"
                className="inline-flex text-sm font-medium text-brand underline-offset-4 hover:underline"
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
