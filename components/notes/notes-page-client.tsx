"use client";

import { useState } from "react";
import { NotesFilterBar } from "./notes-filter-bar";
import { NotesGrid } from "./notes-grid";
import { FadeIn } from "@/components/ui/fade-in";
import { Container } from "@/components/layout/container";
import type { NoteFilterId } from "@/lib/data/notes";

export function NotesPageClient() {
  const [filter, setFilter] = useState<NoteFilterId>("all");

  return (
    <section className="py-14 md:py-20">
      <Container>
        <FadeIn>
          <NotesFilterBar active={filter} onChange={setFilter} />
        </FadeIn>
        <FadeIn delay={0.06} className="mt-12">
          <NotesGrid filter={filter} />
        </FadeIn>
      </Container>
    </section>
  );
}
