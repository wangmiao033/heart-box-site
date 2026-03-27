"use client";

import { motion, useReducedMotion } from "framer-motion";
import type { NoteEntry, NoteFilterId } from "@/lib/data/notes";
import { cn } from "@/lib/utils/cn";

type Props = { note: NoteEntry };

const moodLabel: Partial<Record<NoteFilterId, string>> = {
  gentle: "温柔",
  low: "低落",
  miss: "想念",
  encourage: "鼓励",
};

function slipRotation(id: string): number {
  let h = 0;
  for (let i = 0; i < id.length; i++) h = (h + id.charCodeAt(i) * (i + 1)) % 17;
  return (h / 17 - 0.5) * 1.4;
}

export function NoteCard({ note }: Props) {
  const reduceMotion = useReducedMotion();
  const rotate = reduceMotion ? 0 : slipRotation(note.id);
  const chip = moodLabel[note.mood];

  return (
    <motion.article
      style={{ rotate }}
      className={cn(
        "group flex min-h-[168px] flex-col rounded-[18px] border border-line/90 bg-[#FDFBF8] p-6 shadow-paper",
        "transition-[box-shadow,border-color] duration-300 ease-soft",
        "before:pointer-events-none before:absolute before:inset-0 before:rounded-[18px] before:bg-paper-lines before:opacity-40",
        "relative overflow-hidden hover:-translate-y-0.5 hover:border-line hover:shadow-paper-hover",
      )}
      whileHover={reduceMotion ? undefined : { y: -2 }}
      transition={{ type: "spring", stiffness: 460, damping: 34 }}
    >
      <div
        className="pointer-events-none absolute right-0 top-0 h-16 w-24 bg-gradient-to-bl from-[#FFF4E6]/50 to-transparent"
        aria-hidden
      />
      {chip ? (
        <p className="relative z-[1] mb-3 text-[11px] font-medium uppercase tracking-[0.14em] text-sub/75">
          {chip}
        </p>
      ) : null}
      <p className="relative z-[1] flex-1 text-[15px] leading-[1.72] text-ink">
        {note.excerpt}
      </p>
      <p className="relative z-[1] mt-5 border-t border-line/50 pt-4 text-xs text-sub">
        {note.dateLabel}
      </p>
    </motion.article>
  );
}
