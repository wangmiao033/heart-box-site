import { HomeLanding } from "@/components/landing/home-landing";
import { buildMetadata } from "@/lib/seo";

export const metadata = buildMetadata({
  title: "首页",
  description:
    "心事匣是轻量、安静的心情记录空间：柔和界面、日历回看、写作提示与本地优先的安心体验。",
  path: "/",
});

export default function HomePage() {
  return <HomeLanding />;
}
