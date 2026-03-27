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
    <section className="py-10 md:py-14 lg:py-16">
      <Container>
        <FadeIn>
          <NotesFilterBar active={filter} onChange={setFilter} />
        </FadeIn>
        <FadeIn delay={0.05} className="mt-8 md:mt-9 lg:mt-10">
          <NotesGrid filter={filter} />
        </FadeIn>
      </Container>
    </section>
  );
}
