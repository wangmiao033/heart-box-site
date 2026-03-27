import { CapabilitySection } from "@/components/product/capability-section";
import { FaqList } from "@/components/product/faq-list";
import { PhilosophyGrid } from "@/components/product/philosophy-grid";
import { ProductHero } from "@/components/product/product-hero";
import { ScenarioSection } from "@/components/product/scenario-section";
import { UsageTimeline } from "@/components/product/usage-timeline";
import { productFaqs } from "@/lib/data/faqs";
import { buildMetadata } from "@/lib/seo";

export const metadata = buildMetadata({
  title: "产品",
  description:
    "了解心事匣：不催促的记录空间、核心能力、使用流程与常见问题。",
  path: "/product",
});

export default function ProductPage() {
  return (
    <>
      <ProductHero />
      <PhilosophyGrid />
      <CapabilitySection />
      <UsageTimeline />
      <ScenarioSection />
      <FaqList items={productFaqs} />
    </>
  );
}
