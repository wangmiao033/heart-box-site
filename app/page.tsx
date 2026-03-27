import { DownloadPreview } from "@/components/home/download-preview";
import { FeatureGrid } from "@/components/home/feature-grid";
import { HeartBoxInteractive } from "@/components/home/heart-box-interactive";
import { HeroSection } from "@/components/home/hero-section";
import { SceneGrid } from "@/components/home/scene-grid";
import { buildMetadata } from "@/lib/seo";

export const metadata = buildMetadata({
  title: "首页",
  description:
    "心事匣：把想说的话轻轻放进去。温馨、安静的记录空间，轻量心情日记与心事匣互动体验。",
  path: "/",
});

export default function HomePage() {
  return (
    <>
      <HeroSection />
      <FeatureGrid />
      <HeartBoxInteractive />
      <SceneGrid />
      <DownloadPreview />
    </>
  );
}
