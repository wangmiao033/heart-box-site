import { ChangelogList } from "@/components/download/changelog-list";
import { DownloadHero } from "@/components/download/download-hero";
import { PlatformGrid } from "@/components/download/platform-grid";
import { VersionCard } from "@/components/download/version-card";
import { FaqList } from "@/components/product/faq-list";
import { downloadFaqs } from "@/lib/data/faqs";
import { buildMetadata } from "@/lib/seo";

export const metadata = buildMetadata({
  title: "下载",
  description:
    "获取心事匣：iOS、Android、Web 状态，版本说明、更新日志与下载常见问题。",
  path: "/download",
});

export default function DownloadPage() {
  return (
    <>
      <DownloadHero />
      <PlatformGrid />
      <VersionCard />
      <ChangelogList />
      <FaqList items={downloadFaqs} title="下载常见问题" />
    </>
  );
}
