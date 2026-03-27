import Link from "next/link";
import { HeroSection } from "@/components/hero_section";
import { SectionTitle } from "@/components/section_title";
import { FeatureGrid } from "@/components/feature_grid";
import { CtaSection } from "@/components/cta_section";
import {
  homeSellingPoints,
  homeScenarios,
  homeTrustItems,
} from "@/lib/home_content";
import { screenshotShots } from "@/lib/screenshots_data";
import { buildMetadata } from "@/lib/seo";

export const metadata = buildMetadata({
  title: "首页",
  description:
    "心事匣是轻量、安静的心情日记应用：记录心情、日历回看、写作提示与本地优先的隐私体验。",
  path: "/",
});

export default function HomePage() {
  const previewShots = screenshotShots.slice(0, 5);

  return (
    <>
      <HeroSection />

      <section className="page-section page-section--tight-top">
        <div className="container">
          <SectionTitle
            align="center"
            eyebrow="定位"
            title="写下来，轻一点，被留住，更安心"
            subtitle="不是社交，也不是任务清单。只是一个你可以常回来看看的小角落。"
          />
        </div>
      </section>

      <section className="page-section">
        <div className="container">
          <SectionTitle
            eyebrow="核心"
            title="一些你可能在意的点"
            subtitle="没有夸张承诺，只是把产品在做的事说清楚。"
          />
          <FeatureGrid items={[...homeSellingPoints]} className="feature-grid--home" />
        </div>
      </section>

      <section className="page-section">
        <div className="container">
          <SectionTitle
            eyebrow="界面"
            title="产品截图预览"
            subtitle="以下为示意占位图，上线前请替换为真实截图。"
          />
          <div className="preview-strip">
            {previewShots.map((s) => (
              <div key={s.src} className="preview-strip__item">
                <img src={s.src} alt={s.alt} />
              </div>
            ))}
          </div>
          <p style={{ marginTop: "1.25rem", textAlign: "center" }}>
            <Link href="/screenshots" className="muted">
              查看全部截图 →
            </Link>
          </p>
        </div>
      </section>

      <section className="page-section">
        <div className="container">
          <SectionTitle
            eyebrow="场景"
            title="适合这样用"
            subtitle="你可以完全按自己的节奏来。"
          />
          <div className="scenario-list">
            {homeScenarios.map((s) => (
              <div key={s.title} className="scenario-list__item">
                <h3>{s.title}</h3>
                <p className="muted">{s.body}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      <section className="page-section">
        <div className="container">
          <SectionTitle
            eyebrow="信任"
            title="隐私、草稿与支持"
            subtitle="官网与 App 内说明会保持同步更新；若有出入，以应用内最新版本为准。"
          />
          <div className="trust-strip">
            {homeTrustItems.map((t) => (
              <div key={t.title} className="trust-strip__item">
                <h3>{t.title}</h3>
                <p className="muted">{t.body}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      <section className="page-section">
        <div className="container">
          <CtaSection />
        </div>
      </section>
    </>
  );
}
