import { NotesHero } from "@/components/notes/notes-hero";
import { NotesPageClient } from "@/components/notes/notes-page-client";
import { buildMetadata } from "@/lib/seo";

export const metadata = buildMetadata({
  title: "心事展示",
  description:
    "一些被轻轻放下的话——心事匣示例心事列表，支持按情绪筛选浏览。",
  path: "/notes",
});

export default function NotesPage() {
  return (
    <>
      <NotesHero />
      <NotesPageClient />
    </>
  );
}
