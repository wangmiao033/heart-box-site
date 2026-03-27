import { SectionTitle } from "@/components/section_title";
import { ScreenshotGallery } from "@/components/screenshot_gallery";
import { CtaSection } from "@/components/cta_section";
import { screenshotShots } from "@/lib/screenshots_data";
import { buildMetadata } from "@/lib/seo";

export const metadata = buildMetadata({
  title: "产品截图",
  description:
    "心事匣主要界面截图：首页、写作、情绪日历、回顾与设置。当前为占位图，可替换为真实应用截图。",
  path: "/screenshots",
});

export default function ScreenshotsPage() {
  return (
    <>
      <div className="container page-hero">
        <h1 className="page-hero__title">产品截图</h1>
        <p className="page-hero__lead muted">
          通过界面快速了解产品结构。若你看到的是浅色占位块，说明尚未替换为正式截图——替换{" "}
          <code style={{ fontSize: "0.9em" }}>public/screenshots/</code>{" "}
          下对应文件即可。
        </p>
      </div>

      <section className="page-section">
        <div className="container">
          <SectionTitle
            align="left"
            eyebrow="界面"
            title="主要页面一览"
          />
          <ScreenshotGallery shots={[...screenshotShots]} columns={2} />
        </div>
      </section>

      <section className="page-section">
        <div className="container">
          <CtaSection
            title="准备体验？"
            body="在下载页查看当前可用的获取方式。"
            primaryHref="/download"
            primaryLabel="前往下载页"
            secondaryHref="/features"
            secondaryLabel="返回功能介绍"
          />
        </div>
      </section>
    </>
  );
}
