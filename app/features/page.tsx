import { SectionTitle } from "@/components/section_title";
import { FeatureGrid } from "@/components/feature_grid";
import { CtaSection } from "@/components/cta_section";
import { buildMetadata } from "@/lib/seo";

export const metadata = buildMetadata({
  title: "功能介绍",
  description:
    "了解心事匣：心情与日记记录、情绪日历、回顾统计、写作提示、情绪安抚、草稿自动保存、本地隐私与未来云同步规划。",
  path: "/features",
});

const featureItems = [
  {
    title: "记录心情与日记",
    description:
      "支持以简短或完整的方式记录当下。可配合心情标记，让条目日后更容易被想起。",
    tone: "mist" as const,
  },
  {
    title: "情绪日历",
    description:
      "在月视图中查看情绪分布与记录密度，用温和的方式回看一段时间内的自己。",
    tone: "lavender" as const,
  },
  {
    title: "回顾与统计",
    description:
      "汇总片段化的记录，帮助你在不施压的前提下，看见习惯与变化。具体统计项以应用内为准。",
    tone: "sage" as const,
  },
  {
    title: "写作提示",
    description:
      "在空白页面前提供轻柔引导，降低「不知道写什么」的门槛，可随时忽略。",
    tone: "blush" as const,
  },
  {
    title: "情绪安抚",
    description:
      "在需要时提供简短、克制的安抚与引导，不替代专业帮助；严重困扰请寻求现实支持。",
    tone: "mist" as const,
  },
  {
    title: "草稿自动保存",
    description:
      "编辑过程中自动保存草稿，减少因切换应用或意外退出造成的内容丢失。",
    tone: "lavender" as const,
  },
  {
    title: "本地隐私保护",
    description:
      "默认以设备本地存储为主；系统级权限（如通知、存储）遵循操作系统与应用内授权说明。",
    tone: "sage" as const,
  },
  {
    title: "云同步与账号",
    description:
      "若正式上线账号、云同步与多设备恢复，将通过应用内公告与隐私政策更新说明。当前是否开放以你设备上的版本为准。",
    tone: "blush" as const,
  },
];

export default function FeaturesPage() {
  return (
    <>
      <div className="container page-hero">
        <h1 className="page-hero__title">功能介绍</h1>
        <p className="page-hero__lead muted">
          下面是心事匣希望做好的几件事。细节会随版本迭代调整，请以应用内实际能力为准。
        </p>
      </div>

      <section className="page-section">
        <div className="container">
          <SectionTitle
            align="left"
            eyebrow="能力清单"
            title="记录、回看与安心"
            subtitle="我们尽量用直白的话描述，避免堆砌概念。"
          />
          <FeatureGrid items={[...featureItems]} />
        </div>
      </section>

      <section className="page-section">
        <div className="container">
          <CtaSection
            title="想看看界面？"
            body="截图页有各主要界面的预览（占位图可替换为正式素材）。"
            primaryHref="/screenshots"
            primaryLabel="查看截图"
            secondaryHref="/download"
            secondaryLabel="下载 / 打开"
          />
        </div>
      </section>
    </>
  );
}
