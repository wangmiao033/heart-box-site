"use client";

import { useMemo } from "react";
import { Feather } from "lucide-react";
import { NoteCard } from "./note-card";
import type { NoteEntry, NoteFilterId } from "@/lib/data/notes";
import { sampleNotes } from "@/lib/data/notes";

type Props = {
  filter: NoteFilterId;
};

function applyFilter(notes: NoteEntry[], filter: NoteFilterId): NoteEntry[] {
  if (filter === "all") return notes;
  if (filter === "recent") {
    return notes.filter((n) =>
      ["今天", "昨天", "三天前"].some((k) => n.dateLabel.includes(k)),
    );
  }
  return notes.filter((n) => n.mood === filter);
}

export function NotesGrid({ filter }: Props) {
  const list = useMemo(() => applyFilter(sampleNotes, filter), [filter]);

  if (list.length === 0) {
    return (
      <div className="relative overflow-hidden rounded-card-md border border-dashed border-line/90 bg-page-elevated/40 py-20 text-center md:py-24">
        <div
          className="pointer-events-none absolute inset-0 texture-noise opacity-25"
          aria-hidden
        />
        <div className="relative mx-auto flex max-w-sm flex-col items-center px-6">
          <div className="mb-5 flex h-14 w-14 items-center justify-center rounded-full border border-line/80 bg-card/90 text-accent shadow-paper">
            <Feather className="h-6 w-6" strokeWidth={1.35} aria-hidden />
          </div>
          <p className="text-[15px] leading-relaxed text-ink/85">
            这里还很安静。
          </p>
          <p className="mt-2 text-sm leading-relaxed text-sub">
            等你放进第一张小纸条，我们再一起慢慢看。
          </p>
        </div>
      </div>
    );
  }

  return (
    <ul className="grid grid-cols-1 gap-6 sm:grid-cols-2 sm:gap-7 lg:grid-cols-3 lg:gap-8">
      {list.map((note) => (
        <li key={note.id} className="flex">
          <NoteCard note={note} />
        </li>
      ))}
    </ul>
  );
}
